# By default won't delete any directories, requires all relevant directories
# be empty. Run `RAKE_FORCE_DELETE=true rake pull_repos` to have directories
# deleted.
desc 'Pulls down the CE, EE, and Omnibus git repos and merges the content of their doc directories into the nanoc site'
task :pull_repos do
  force_delete = ENV['RAKE_FORCE_DELETE']

  ce = {
    repo: 'https://gitlab.com/gitlab-org/gitlab-ce.git',
    temp_dir: 'tmp/ce/',
    dest_dir: 'content/ce'
  }

  ee = {
    repo: 'https://gitlab.com/gitlab-org/gitlab-ee.git',
    temp_dir: 'tmp/ee/',
    dest_dir: 'content/ee'
  }

  omnibus = {
    repo: 'https://gitlab.com/gitlab-org/omnibus-gitlab.git',
    temp_dir: 'tmp/omnibus/',
    dest_dir: 'content/omnibus'
  }

  products = [ce, ee, omnibus]
  dirs = []
  products.each do |product|
    dirs.push(product[:temp_dir])
    dirs.push(product[:dest_dir])
  end

  if force_delete
    puts "WARNING: Are you sure you want to remove #{dirs.join(', ')}? [y/n]"
    exit unless STDIN.gets.index(/y/i) == 0

    dirs.each do |dir|
      puts "\n=> Deleting #{dir} if it exists\n"
      `rm -rf #{dir}`
    end
  else
    puts "NOTE: The following directories must be empty otherwise this task " +
      "will fail:\n#{dirs.join(', ')}"
    puts "If you want to force-delete the `tmp/` and `content/` folders so \n" +
      "the task will run without manual intervention, run \n" +
      "`RAKE_FORCE_DELETE=true rake pull_repos`."
  end
  
  products.each do |product|
    puts "\n=> Cloning #{product[:repo]} into #{product[:temp_dir]}\n"
    `git clone #{product[:repo]} #{product[:temp_dir]} --depth 1`
    
    puts "\n=> Moving #{product[:temp_dir]}doc/ into #{product[:dest_dir]}\n"
    `mv #{product[:temp_dir]}doc/ #{product[:dest_dir]}`
  end
end
