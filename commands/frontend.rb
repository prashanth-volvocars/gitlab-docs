usage       'frontend [options]'
aliases     :ds, :stuff
summary     'uses nanoc cli to execute frontend related tasks'
description 'This command is used by the Nanoc CLI to bundle the JavaScript.'

flag   :h, :help, 'show help for this command' do |value, cmd|
  puts cmd.help
  exit 0
end
run do |opts, args, cmd|

  puts '--------------------------------'

  if check_requirements?
    puts 'Compiling JavaScript...'

    system('yarn install --frozen-lockfile')

    system('yarn bundle')
  end
end

def check_requirements?
  puts 'Checking requirements...'

  has_requirements = command_exists?('node') && command_exists?('yarn')

  unless has_requirements
    puts 'Your system may be missing some requirements.'
    puts 'Please refer to the installation instructions for more details:'
    puts 'https://gitlab.com/gitlab-org/gitlab-docs/blob/master/README.md'
  end
  has_requirements
end

def command_exists?(command)
  exists = system("which #{command} > /dev/null 2>&1")
  puts "🚨 #{command} is not installed!" unless exists
  exists
end
