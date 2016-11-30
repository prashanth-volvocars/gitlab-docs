desc 'Pulls down the CE, EE, Omnibus and Runner git repos and merges the content of their doc directories into the nanoc site'
task :pull_repos do
  require 'yaml'

  # By default won't delete any directories, requires all relevant directories
  # be empty. Run `RAKE_FORCE_DELETE=true rake pull_repos` to have directories
  # deleted.
  force_delete = ENV['RAKE_FORCE_DELETE']

  # Parse the config file and create a hash.
  config = YAML.load_file('./nanoc.yaml')

  # Pull products data from the config.
  ce = config["products"]["ce"]
  ee = config["products"]["ee"]
  omnibus = config["products"]["omnibus"]
  runner = config["products"]["runner"]

  products = [ce, ee, omnibus, runner]
  dirs = []
  products.each do |product|
    dirs.push(product['dirs']['temp_dir'])
    dirs.push(product['dirs']['dest_dir'])
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
    temp_dir = File.join(product['dirs']['temp_dir'])
    puts "\n=> Cloning #{product['repo']} into #{temp_dir}\n"

    `git clone #{product['repo']} #{temp_dir} --depth 1 --branch master`
    
    temp_doc_dir = File.join(product['dirs']['temp_dir'], product['dirs']['doc_dir'], '.')
    destination_dir = File.join(product['dirs']['dest_dir'])
    puts "\n=> Copying #{temp_doc_dir} into #{destination_dir}\n"
    FileUtils.cp_r(temp_doc_dir, destination_dir)
  end
end
