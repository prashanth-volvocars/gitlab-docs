desc 'Pulls down the CE, EE, Omnibus and Runner git repos and merges the content of their doc directories into the nanoc site'
task :pull_repos do
  # By default won't delete any directories, requires all relevant directories
  # be empty. Run `RAKE_FORCE_DELETE=true rake pull_repos` to have directories
  # deleted.
  force_delete = ENV['RAKE_FORCE_DELETE']

  ce = {
    name: 'ce',
    repo: 'https://gitlab.com/gitlab-org/gitlab-ce.git',
    temp_dir: 'tmp/ce/',
    dest_dir: 'content/ce',
    doc_dir:  'doc'
  }

  ee = {
    name: 'ee',
    repo: 'https://gitlab.com/gitlab-org/gitlab-ee.git',
    temp_dir: 'tmp/ee/',
    dest_dir: 'content/ee',
    doc_dir:  'doc'
  }

  omnibus = {
    name: 'omnibus',
    repo: 'https://gitlab.com/gitlab-org/omnibus-gitlab.git',
    temp_dir: 'tmp/omnibus/',
    dest_dir: 'content/omnibus',
    doc_dir:  'doc'
  }

  runner = {
    name: 'runner',
    repo: 'https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git',
    temp_dir: 'tmp/runner/',
    dest_dir: 'content/runner',
    doc_dir:  'docs'
  }

  products = [ce, ee, omnibus, runner]
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
      FileUtils.rm_r("#{dir}") if File.exist?("#{dir}")
    end
  else
    puts "NOTE: The following directories must be empty otherwise this task " +
      "will fail:\n#{dirs.join(', ')}"
    puts "If you want to force-delete the `tmp/` and `content/` folders so \n" +
      "the task will run without manual intervention, run \n" +
      "`RAKE_FORCE_DELETE=true rake pull_repos`."
  end

  dirs.each do |dir|
    unless "#{dir}".start_with?("tmp")
  
      puts "\n=> Making an empty #{dir}"
      FileUtils.mkdir("#{dir}") unless File.exist?("#{dir}")
    end
  end

  products.each do |product|
    temp_dir = File.join(product[:temp_dir])
    puts "\n=> Cloning #{product[:repo]} into #{temp_dir}\n"

    `git clone #{product[:repo]} #{temp_dir} --depth 1 --branch master`
    
    temp_doc_dir = File.join(product[:temp_dir], product[:doc_dir], '.')
    destination_dir = File.join(product[:dest_dir])
    puts "\n=> Copying #{temp_doc_dir} into #{destination_dir}\n"
    FileUtils.cp_r(temp_doc_dir, destination_dir)
  end
end
