require 'optparse'

# Runs by default in "safe-mode" where confirmation is requested before
# removing directories. Run `RAKE_FORCE_DELETE=true rake pull_repos` to
# force directory deletion without any confirmation.
desc 'Pulls down the CE, EE, and Omnibus git repos and merges the content of their doc directories into the nanoc site'
task :pull_repos do
  force = ENV['RAKE_FORCE_DELETE']

  ce_repo = 'https://gitlab.com/gitlab-org/gitlab-ce.git'
  ce_dir = 'tmp/ce/'
  dest_ce_dir = 'content/ce/'

  ee_repo = 'https://gitlab.com/gitlab-org/gitlab-ee.git'
  ee_dir = 'tmp/ee/'
  dest_ee_dir = 'content/ee/'

  unless force
    puts "Are you sure you want to remove #{ce_dir}, #{dest_ce_dir}, #{ee_dir}, and #{dest_ee_dir}? [y/n]"
    exit unless STDIN.gets.index(/y/i) == 0
  end

  [ce_dir, dest_ce_dir, ee_dir, dest_ee_dir].each do |dir|
    puts "\n=> Deleting #{dir} if it exists\n"
    `rm -rf #{dir}`
  end
  
  puts "\n=> Cloning #{ce_repo} into #{ce_dir}\n"
  `git clone #{ce_repo} #{ce_dir} --depth 1`

  puts "\n=> Moving #{ce_dir}doc/ into #{dest_ce_dir}\n"
  cp Dir["standard_data/*.data"], "testdata"
  `mv #{ce_dir}doc/ #{dest_ce_dir}`

  puts "\n=> Cloning #{ee_repo} into #{ee_dir}\n"
  `git clone #{ee_repo} #{ee_dir} --depth 1`

  puts "\n=> Moving #{ee_dir}doc/ into #{dest_ee_dir}\n"
  `mv #{ee_dir}doc/ #{dest_ee_dir}`
end
