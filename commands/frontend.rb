usage       'frontend [options]'
aliases     :ds, :stuff
summary     'uses nanoc cli to execute frontend related tasks'
description 'This command is used by the Nanoc CLI to bundle the JavaScript.'

flag   :h, :help, 'show help for this command' do |value, cmd|
  puts cmd.help
  exit 0
end
run do |opts, args, cmd|
  puts 'Compiling JavaScript...'
  unless system('yarn install --frozen-lockfile')
    abort <<~ERROR
      Error: failed to run yarn. JavaScript compilation failed. For more information, see:
      https://gitlab.com/gitlab-org/gitlab-docs/blob/master/README.md

      ERROR
  end
  unless system('yarn bundle')
    abort <<~ERROR
      Error: failed to run yarn. JavaScript compilation failed. For more information, see:
      https://gitlab.com/gitlab-org/gitlab-docs/blob/master/README.md

      ERROR
  end

  puts 'Create icons.svg ...'
  root = File.expand_path('../', __dir__)
  path = 'node_modules/@gitlab/svgs/dist/icons.svg'

  if File.write('public/assets/images/icons.svg', File.read("#{root}/#{path}"))
    puts 'Done!'
  else
    puts 'Failed to create icons.svg!'
  end
end
