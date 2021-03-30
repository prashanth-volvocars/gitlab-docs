require './lib/task_helpers'
require 'fileutils'

task default: [:setup_repos, :pull_repos, :setup_content_dirs]

task :setup_git do
  puts "\n=> Setting up dummy user/email in Git"

  `git config --global user.name "John Doe"`
  `git config --global user.email johndoe@example.com`
end

desc 'Setup repositories for EE, Omnibus, and Runner in special way exposing only their doc directories'
task :setup_repos do
  products.each_value do |product|
    branch = retrieve_branch(product['slug'])

    # Limit the pipeline to pull only the repo where the MR is, not all 4, to save time/space.
    # First we check if the branch on the docs repo is other than the default branch and
    # then we skip if the remote branch variable is the default branch name. Finally,
    # check if the pipeline was triggered via the API (multi-project pipeline)
    # to exclude the case where we create a branch right off the gitlab-docs
    # project.
    next if ENV["CI_COMMIT_REF_NAME"] != ENV['CI_DEFAULT_BRANCH'] && branch == ENV['CI_DEFAULT_BRANCH'] && ENV["CI_PIPELINE_SOURCE"] == 'pipeline'

    next if File.exist?(product['dirs']['temp_dir'])

    puts "\n=> Setting up repository #{product['repo']} into #{product['dirs']['temp_dir']}\n"
    `git init #{product['dirs']['temp_dir']}`

    Dir.chdir(product['dirs']['temp_dir']) do
      `git remote add origin #{product['repo']}`

      # Configure repository for sparse-checkout
      `git config core.sparsecheckout true`
      File.open('.git/info/sparse-checkout', 'w') { |f| f.write("/#{product['dirs']['doc_dir']}/*") }
    end
  end
end

desc 'Pulls down the CE, EE, Omnibus and Runner git repos fetching and keeping only the most recent commit'
task :pull_repos do
  products.each_value do |product|
    branch = retrieve_branch(product['slug'])

    # Limit the pipeline to pull only the repo where the MR is, not all 4, to save time/space.
    # First we check if the branch on the docs repo is other than the default branch and
    # then we skip if the remote branch variable is the default branch name. Finally,
    # check if the pipeline was triggered via the API (multi-project pipeline)
    # to exclude the case where we create a branch right off the gitlab-docs
    # project.
    next if ENV["CI_COMMIT_REF_NAME"] != ENV['CI_DEFAULT_BRANCH'] && branch == ENV['CI_DEFAULT_BRANCH'] && ENV["CI_PIPELINE_SOURCE"] == 'pipeline'

    puts "\n=> Pulling #{branch} of #{product['repo']}\n"

    # Enter the temporary directory and return after block is completed.
    Dir.chdir(product['dirs']['temp_dir']) do
      `git fetch origin #{branch} --depth 1`

      # Stash modified and untracked files so we have "clean" environment
      # without accidentally deleting data
      `git stash -u` if git_workdir_dirty?
      `git checkout #{branch}`

      # Reset so that if the repo is cached, the latest commit will be used
      `git reset --hard origin/#{branch}`
      # Print the latest commit so that we can compare it to the branch we're
      # pulling from, should we need to debug anything.
      puts "Latest commit: #{`git log --oneline -n 1`}"
    end
  end
end

desc 'Setup content directories by symlinking to the repositories documentation folder'
task :setup_content_dirs do
  products.each_value do |product|
    next unless File.exist?(product['dirs']['temp_dir'])

    source = File.join('../', product['dirs']['temp_dir'], product['dirs']['doc_dir'])
    target = product['dirs']['dest_dir']

    next if File.symlink?(target)

    puts "\n=> Setting up content directory for #{product['repo']}\n"

    `ln -s #{source} #{target}`
  end
end

desc 'Clean temp directories and symlinks'
task :clean_dirs do
  products.each_value do |product|
    temp_dir = product['dirs']['temp_dir']
    dest_dir = product['dirs']['dest_dir']

    FileUtils.rm_rf(temp_dir)
    puts "Removed #{temp_dir}"

    FileUtils.rm_rf(dest_dir)
    puts "Removed #{dest_dir}"
  end
end

namespace :release do
  desc 'Creates a single release archive'
  task :single, :version do |t, args|
    require "highline/import"
    version = args.version.to_s
    source_dir = File.expand_path(__dir__)

    raise 'You need to specify a version, like 10.1' unless version.match?(/\A\d+\.\d+\z/)

    # Check if the chart version has been defined
    unless chart_version_added?(version)
      abort('Rake aborted! The chart version does not exist. Make sure `content/_data/charts_versions.yaml` is updated.
            https://docs.gitlab.com/ee/development/documentation/site_architecture/release_process.html#1-add-the-chart-version')
    end

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
    ci_yaml_content.gsub!("BRANCH_RUNNER: 'master'", "BRANCH_RUNNER: '#{version.tr('.', '-')}-stable'")
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
      on how to create it: https://docs.gitlab.com/ee/development/documentation/site_architecture/versions.html#3-create-the-release-merge-request
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
      https://docs.gitlab.com/ee/development/documentation/site_architecture/versions.html#3-create-the-release-merge-request
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
      `git push origin #{branch_name} -o merge_request.create -o merge_request.target=#{version} -o merge_request.remove_source_branch -o merge_request.title="#{mr_title}" -o merge_request.description="#{mr_description}" -o merge_request.label="Technical Writing" -o merge_request.label="release"`
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
      f.puts "#{redirect.fetch('from')} #{redirect.fetch('to')} 302"
    end
  end
end
