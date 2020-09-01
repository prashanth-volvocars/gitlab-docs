source 'https://rubygems.org'

gem 'nanoc', '~> 4.10'
gem 'adsf', '~> 1.4'
gem 'adsf-live', '~> 1.4'
gem 'sassc', '~> 2.0'
gem 'rouge', '~> 3.11'
gem 'rake', '~> 12.3'

group :nanoc do
  gem 'guard-nanoc'

  # custom kramdown dialect
  gem 'gitlab_kramdown', '~> 0.10.0'

  # nanoc checks
  gem 'nokogiri', '~> 1.10.3'

  # Needed to generate Sitemap
  gem 'builder', '~> 3.2'
end

group :test, :development do
  gem 'scss_lint', '~> 0.57', require: false
  gem 'highline', '~> 2.0'
  gem 'rspec', '~> 3.5'
  gem 'pry-byebug', '~> 3.7', require: false
  # Although we now use markdownlint-cli, we need the mdl gem for backwards compatibility
  gem 'mdl'
end
