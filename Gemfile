source 'https://rubygems.org'

gem 'nanoc', '~> 4.11.0'
gem 'adsf', '~> 1.4.3'
gem 'adsf-live', '~> 1.4.3'
gem 'sassc', '~> 2.4.0'
gem 'rouge', '~> 3.26.0'
gem 'rake', '~> 13.0.1'

group :nanoc do
  gem 'guard-nanoc'

  # custom kramdown dialect
  gem 'gitlab_kramdown', '~> 0.10.0'

  # nanoc checks
  gem 'nokogiri', '~> 1.10.10'

  # Needed to generate Sitemap
  gem 'builder', '~> 3.2.4'
end

group :test, :development do
  gem 'scss_lint', '~> 0.59.0', require: false
  gem 'highline', '~> 2.0.3'
  gem 'rspec', '~> 3.10.0'
  gem 'pry-byebug', '~> 3.9.0', require: false
  gem 'gitlab-styles', '~> 5.3.0', require: false
end
