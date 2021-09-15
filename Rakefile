require './lib/task_helpers'
require 'fileutils'
require 'pathname'

task default: [:clone_repositories, :generate_feature_flags]

task :setup_git do
  puts "\n=> Setting up dummy user/email in Git"

  `git config --global user.name "John Doe"`
  `git config --global user.email johndoe@example.com`
end

desc 'Clone Git repositories of documentation projects, keeping only the most recent commit'
task :clone_repositories do
  products.each_value do |product|
    branch = retrieve_branch(product['slug'])

    # Limit the pipeline to pull only the repo where the MR is, not all 4, to save time/space.
    # First we check if the branch on the docs repo is other than the default branch and
    # then we skip if the remote branch variable is the default branch name. Finally,
    # check if the pipeline was triggered via the API (multi-project pipeline)
    # to exclude the case where we create a branch right off the gitlab-docs
    # project.
    next if ENV["CI_COMMIT_REF_NAME"] != ENV['CI_DEFAULT_BRANCH'] && branch == ENV['CI_DEFAULT_BRANCH'] && ENV["CI_PIPELINE_SOURCE"] == 'pipeline'

    puts "\n=> Cloning #{product['repo']} into #{product['project_dir']}\n"

    `git clone --branch #{branch} --single-branch #{product['repo']} --depth 1 #{product['project_dir']}`

    # Print the latest commit from each project so that we can see which commit we're building from.
    puts "Latest commit: #{`git -C #{product['project_dir']} log --oneline -n 1`}"
  end
end

desc 'Generate feature flags data file'
task :generate_feature_flags do
  feature_flags_dir = Pathname.new('..').join('gitlab', 'config', 'feature_flags').expand_path
  feature_flags_ee_dir = Pathname.new('..').join('gitlab', 'ee', 'config', 'feature_flags').expand_path

  abort("The feature flags directory #{feature_flags_dir} does not exist.") unless feature_flags_dir.exist?
  abort("The feature flags EE directory #{feature_flags_ee_dir} does not exist.") unless feature_flags_ee_dir.exist?

  paths = {
    'GitLab Community Edition and Enterprise Edition' => feature_flags_dir.join('**', '*.yml'),
    'GitLab Enterprise Edition only' => feature_flags_ee_dir.join('**', '*.yml')
  }

  feature_flags = {
    products: {}
  }

  paths.each do |key, path|
    feature_flags[:products][key] = []

    Dir.glob(path).each do |feature_flag_yaml|
      feature_flags[:products][key] << YAML.safe_load(File.read(feature_flag_yaml))
    end
  end

  feature_flags_yaml = File.join('content', '_data', 'feature_flags.yaml')

  puts "Generating #{feature_flags_yaml}"
  File.write(feature_flags_yaml, feature_flags.to_yaml)
end

namespace :release do
  desc 'Creates a single release archive'
  task :single, :version do |t, args|
    require "highline/import"
    version = args.version.to_s
    source_dir = File.expand_path(__dir__)

    raise 'You need to specify a version, like 10.1' unless version.match?(/\A\d+\.\d+\z/)

    # Check if local branch exists
    abort("Rake aborted! The branch already exists. Delete it with `git branch -D #{version}` and rerun the task.") if local_branch_exist?(version)

    # Stash modified and untracked files so we have "clean" environment
    # without accidentally deleting data
    puts "Stashing changes"
    `git stash -u` if git_workdir_dirty?

    # Sync with upstream default branch
    `git checkout #{ENV['CI_DEFAULT_BRANCH']}`
    `git pull origin #{ENV['CI_DEFAULT_BRANCH']}`

    # Create branch
    `git checkout -b #{version}`

    # Replace the branches variables in Dockerfile.X.Y
    dockerfile = "#{source_dir}/Dockerfile.#{version}"

    if File.exist?(dockerfile)
      abort('rake aborted!') if ask("#{dockerfile} already exists. Do you want to overwrite?", %w[y n]) == 'n'
    end

    content = File.read('dockerfiles/Dockerfile.single')
    content.gsub!('X.Y', version)
    content.gsub!('X-Y', version.tr('.', '-'))
    content.gsub!('W-Z', chart_version(version).tr('.', '-'))

    File.open(dockerfile, 'w') do |post|
      post.puts content
    end

    # Replace the branches variables in .gitlab-ci.yml
    ci_yaml = "#{source_dir}/.gitlab-ci.yml"
    ci_yaml_content = File.read(ci_yaml)
    ci_yaml_content.gsub!("BRANCH_EE: 'master'", "BRANCH_EE: '#{version.tr('.', '-')}-stable-ee'")
    ci_yaml_content.gsub!("BRANCH_OMNIBUS: 'master'", "BRANCH_OMNIBUS: '#{version.tr('.', '-')}-stable'")
    ci_yaml_content.gsub!("BRANCH_RUNNER: 'main'", "BRANCH_RUNNER: '#{version.tr('.', '-')}-stable'")
    ci_yaml_content.gsub!("BRANCH_CHARTS: 'master'", "BRANCH_CHARTS: '#{chart_version(version).tr('.', '-')}-stable'")

    File.open(ci_yaml, 'w') do |post|
      post.puts ci_yaml_content
    end

    # Add and commit
    `git add .gitlab-ci.yml Dockerfile.#{version}`
    `git commit -m 'Release cut #{version}'`

    puts
    puts "--------------------------------"
    puts
    puts "=> Created new Dockerfile: #{dockerfile}"
    puts
    puts "=> You can now add, commit and push the new branch:"
    puts
    puts "    git push origin #{version}"
    puts
    puts "--------------------------------"
  end

  desc 'Creates merge requests to update the dropdowns in all online versions'
  task :dropdowns do
    # Check if you're on the default branch before starting. Fail if you are.
    if `git branch --show-current`.tr("\n", '') == ENV['CI_DEFAULT_BRANCH']
      abort('
      It appears you are on the default branch. Create the current release
      branch and run the raketask again. Follow the documentation guide
      on how to create it: https://about.gitlab.com/handbook/engineering/ux/technical-writing/workflow/#create-release-merge-request
      ')
    end

    # Load online versions
    versions = YAML.load_file('./content/_data/versions.yaml')

    # The first online version should be the current stable one
    current_version = versions['online'].first

    # The release branch name
    release_branch = "release-#{current_version.tr('.', '-')}"

    # Check if a release branch has been created, if not fail and warn the user
    if `git rev-parse --verify #{release_branch}`.empty?
      abort('
      A release branch for the latest stable version has not been created.
      Follow the documentation guide on how to create one:
      https://about.gitlab.com/handbook/engineering/ux/technical-writing/workflow/#create-release-merge-request
      ')
    end

    # Create a merge request to update the dropdowns in all online versions
    versions['online'].each do |version|
      # Set the commit title
      mr_title = "Update #{version} dropdown to match that of #{current_version}"
      mr_description = "Update version dropdown of #{version} release for the #{current_version} release."
      branch_name = "update-#{version.tr('.', '-')}-for-release-#{current_version.tr('.', '-')}"

      puts "=> Fetch #{version} stable branch"
      `git fetch origin #{version}`

      puts "=> Create a new branch off of the online version"
      `git checkout -b #{branch_name} origin/#{version}`
      `git reset --hard origin/#{version}`

      puts "=> Copy the versions.yaml content from the release-#{current_version} branch"
      `git checkout release-#{current_version.tr('.', '-')} -- content/_data/versions.yaml`

      puts "=> Commit and push to create a merge request"
      `git commit -m "Update dropdown to #{current_version}"`
      `git push --set-upstream origin #{branch_name} -o merge_request.create -o merge_request.target=#{version} -o merge_request.remove_source_branch -o merge_request.title="#{mr_title}" -o merge_request.description="#{mr_description}" -o merge_request.label="Technical Writing" -o merge_request.label="release"`
    end
  end
end

desc 'Symlink READMEs'
task :symlink_readmes do
  readmes = YAML.load_file('content/_data/readmes.yaml')
  products.each_value do |product|
    branch = retrieve_branch(product['slug'])

    # Limit the pipeline to pull only the repo where the MR is, not all 4, to save time/space.
    # First we check if the branch on the docs repo is other than the default branch and
    # then we skip if the remote branch variable is the default branch name. Finally,
    # check if the pipeline was triggered via the API (multi-project pipeline)
    # to exclude the case where we create a branch right off the gitlab-docs
    # project.
    next if ENV["CI_COMMIT_REF_NAME"] != ENV['CI_DEFAULT_BRANCH'] && branch == ENV['CI_DEFAULT_BRANCH'] && ENV["CI_PIPELINE_SOURCE"] == 'pipeline'

    next if readmes.key?(product['slug']) == false

    next if readmes.fetch(product['slug']).nil?

    readmes.fetch(product['slug']).each do |readme|
      dirname = File.dirname(readme)
      target = "#{dirname}/index.html"

      next if File.symlink?(target)
      puts "=> Symlink to #{target}"
      `ln -sf README.html #{target}`
    end
  end
end

desc 'Create the _redirects file'
task :redirects do
  redirects_yaml = YAML.load_file('content/_data/redirects.yaml')
  redirects_file = 'public/_redirects'

  # Remove _redirects before populating it
  File.delete(redirects_file) if File.exists?(redirects_file)

  # Iterate over each entry and append to _redirects
  redirects_yaml.fetch('redirects').each do |redirect|
    File.open(redirects_file, 'a') do |f|
      f.puts "#{redirect.fetch('from')} #{redirect.fetch('to')} 301"
    end
  end
end

#
# https://docs.gitlab.com/ee/development/documentation/#move-or-rename-a-page
#
namespace :docs do
  require 'date'
  require 'pathname'
  require "yaml"
  desc 'GitLab | Docs | Clean up old redirects'
  task :clean_redirects do
    source_dir = File.expand_path(__dir__)
    redirects_yaml = "#{source_dir}/content/_data/redirects.yaml"
    today = Time.now.utc.to_date
    mr_title = "Clean up docs redirects - #{today}"
    mr_description = "Monthly cleanup of docs redirects.</br><p>See https://about.gitlab.com/handbook/engineering/ux/technical-writing/#regularly-scheduled-tasks</p></br></hr></br><p>_Created automatically: https://gitlab.com/gitlab-org/gitlab-docs/-/blob/main/README.md#clean-up-redirects_</p>"
    redirects_branch = "docs-clean-redirects-#{today}"
    # Disable lefthook because it was causing some PATH errors
    # https://docs.gitlab.com/ee/development/contributing/style_guides.html#disable-lefthook-temporarily
    ENV['LEFTHOOK'] = '0'

    puts "=> (gitlab-docs): Stashing changes of gitlab-docs and syncing with upstream default branch"
    system("git stash --quiet -u") if git_workdir_dirty?
    system("git checkout --quiet main")
    system("git fetch --quiet origin main")
    system("git reset --quiet --hard origin/main")

    products.each_value do |product|
      #
      # Calculate new path from the redirect URL.
      #
      # If the redirect is not a full URL:
      #   1. Create a new Pathname of the file
      #   2. Use dirname to get all but the last component of the path
      #   3. Join with the redirect_to entry
      #   4. Substitute:
      #      - '.md' => '.html'
      #      - 'doc/' => '/ee/'
      #
      # If the redirect URL is a full URL pointing to the Docs site
      # (cross-linking among the 4 products), remove the FQDN prefix:
      #
      #   From : https://docs.gitlab.com/ee/install/requirements.html
      #   To   : /ee/install/requirements.html
      #
      def new_path(redirect, filename, content_dir, slug)
        if !redirect.start_with?('http')
          Pathname.new(filename).dirname.join(redirect).to_s.gsub(/\.md/, '.html').gsub(content_dir, "/#{slug}")
        elsif redirect.start_with?('https://docs.gitlab.com')
          redirect.gsub('https://docs.gitlab.com', '')
        else
          redirect
        end
      end

      content_dir = product['content_dir']
      next unless Dir.exist?(content_dir)

      default_branch = default_branch(product['repo'])
      slug = product['slug']
      counter = 0

      Dir.chdir(content_dir)
      puts "=> (#{slug}): Stashing changes of #{slug} and syncing with upstream default branch"
      system("git stash --quiet -u") if git_workdir_dirty?
      system("git checkout --quiet #{default_branch}")
      system("git fetch --quiet origin #{default_branch}")
      system("git reset --quiet --hard origin/#{default_branch}")
      Dir.chdir(source_dir)

      #
      # Find the files to be deleted.
      # Exclude 'doc/development/documentation/redirects.md' because it
      # contains an example of the YAML front matter.
      #
      files_to_be_deleted = `grep -Ir 'remove_date:' #{content_dir} | grep -v doc/development/documentation/redirects.md | cut -d ":" -f1`.split("\n")

      #
      # Iterate over the files to be deleted and print the needed
      # YAML entries for the Docs site redirects.
      #
      files_to_be_deleted.each do |filename|
        frontmatter = YAML.safe_load(File.read(filename))
        remove_date = Date.parse(frontmatter['remove_date'])
        old_path = filename.gsub(/\.md/, '.html').gsub(content_dir, "/#{slug}")

        #
        # Check if the removal date is before today, and delete the file and
        # print the content to be pasted in
        # https://gitlab.com/gitlab-org/gitlab-docs/-/blob/master/content/_data/redirects.yaml.
        # The remove_date of redirects.yaml should be nine months in the future.
        # To not be confused with the remove_date of the Markdown page.
        #
        next unless remove_date < today

        counter += 1

        File.delete(filename) if File.exist?(filename)
        File.open(redirects_yaml, 'a') do |post|
          post.puts "  - from: #{old_path}"
          post.puts "    to: #{new_path(frontmatter['redirect_to'], filename, content_dir, slug)}"
          post.puts "    remove_date: #{remove_date >> 9}"
        end

        # If the 'from' path ends with 'index.html' we need an extra redirect
        # entry in 'redirects.yaml' that is without 'index.html'
        next unless old_path.end_with?('index.html')

        File.open(redirects_yaml, 'a') do |post|
          post.puts "  - from: #{old_path.gsub!('index.html', '')}"
          post.puts "    to: #{new_path(frontmatter['redirect_to'], filename, content_dir, slug)}"
          post.puts "    remove_date: #{remove_date >> 9}"
        end
      end

      #
      # If more than one files are found:
      #
      #   1. cd into each repository
      #   2. Create a redirects branch
      #   3. Add the changed files
      #   4. Commit and push the branch to create the MR
      #

      puts "=> (#{slug}): Found #{counter} redirect(s)"
      next unless counter.positive?

      Dir.chdir(content_dir)
      puts "=> (#{slug}): Creating a new branch for the redirects MR"
      system("git checkout --quiet -b #{redirects_branch} origin/#{default_branch}")
      puts "=> (#{slug}): Committing and pushing to create a merge request"
      system("git add .")
      system("git commit --quiet -m 'Update docs redirects #{today}'")
      `git push --set-upstream origin #{redirects_branch} -o merge_request.create -o merge_request.remove_source_branch -o merge_request.title="#{mr_title}" -o merge_request.description="#{mr_description}" -o merge_request.label="Technical Writing" -o merge_request.label="documentation" -o merge_request.label="docs::improvement"` if ENV['SKIP_MR'].nil?
      Dir.chdir(source_dir)
      puts
    end

    #
    # Finally, create the gitlab-docs MR
    #
    #   1. Create a redirects branch
    #   2. Add the changed files
    #   3. Commit and push the branch to create the MR
    #
    puts "=> (gitlab-docs): Creating a new branch for the redirects MR"
    system("git checkout --quiet -b #{redirects_branch} origin/main")
    puts "=> (gitlab-docs): Committing and pushing to create a merge request"
    system("git add #{redirects_yaml}")
    system("git commit --quiet -m 'Update docs redirects #{today}'")
    `git push --set-upstream origin #{redirects_branch} -o merge_request.create -o merge_request.remove_source_branch -o merge_request.title="#{mr_title}" -o merge_request.description="#{mr_description}" -o merge_request.label="Technical Writing" -o merge_request.label="redirects" -o merge_request.label="Category:Docs Site"` if ENV['SKIP_MR'].nil?
  end
end
