require './lib/task_helpers'
require 'fileutils'

task :default => [:setup_repos, :pull_repos, :setup_content_dirs]

task :setup_git do
  puts "\n=> Setting up dummy user/email in Git"

  `git config --global user.name "John Doe"`
  `git config --global user.email johndoe@example.com`
end

desc 'Setup repositories for CE, EE, Omnibus and Runner in special way exposing only their doc directories'
task :setup_repos do
  products.each_value do |product|
    branch = retrieve_branch(product['slug'])

    # Limit the pipeline to pull only the repo where the MR is, not all 4, to save time/space.
    # First we check if the branch on the docs repo is other than 'master' and
    # then we skip if the remote branch variable is 'master'. Finally,
    # check if the pipeline was triggered via the API (multi-project pipeline)
    # to exclude the case where we create a branch right off the gitlab-docs
    # project.
    next if ENV["CI_COMMIT_REF_NAME"] != 'master' and branch == 'master' and ENV["CI_PIPELINE_SOURCE"] == 'pipeline'

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
    # First we check if the branch on the docs repo is other than 'master' and
    # then we skip if the remote branch variable is 'master'. Finally,
    # check if the pipeline was triggered via the API (multi-project pipeline)
    # to exclude the case where we create a branch right off the gitlab-docs
    # project.
    next if ENV["CI_COMMIT_REF_NAME"] != 'master' and branch == 'master' and ENV["CI_PIPELINE_SOURCE"] == 'pipeline'

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
    source_dir = File.expand_path('../', __FILE__)

    raise 'You need to specify a version, like 10.1' unless version =~ /\A\d+\.\d+\z/

    # Stash modified and untracked files so we have "clean" environment
    # without accidentally deleting data
    puts "Stashing changes"
    `git stash -u` if git_workdir_dirty?

    # Sync with upstream master
    `git checkout master`
    `git pull origin master`

    # Create branch
    `git checkout -b #{version}`

    dockerfile = "#{source_dir}/Dockerfile.#{version}"

    if File.exist?(dockerfile)
      abort('rake aborted!') if ask("#{dockerfile} already exists. Do you want to overwrite?", %w[y n]) == 'n'
    end

    content = File.read('dockerfiles/Dockerfile.single')
    content.gsub!('X.Y', version)
    content.gsub!('X-Y', version.tr('.', '-'))
    content.gsub!('W-Z', chart_version(version).tr('.', '-'))

    open(dockerfile, 'w') do |post|
      post.puts content
    end

    # Add and commit
    `git add Dockerfile.#{version}`
    `git commit -m 'Add #{version} Dockerfile'`

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
end
