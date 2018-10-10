source 'https://rubygems.org'

gem 'nanoc', '~> 4.9'
gem 'adsf', '~> 1.4'
gem 'adsf-live', '~> 1.4'
gem 'sass', '~> 3.6'
gem 'redcarpet', '~> 3.4'
gem 'rouge', '~> 2.2'
gem 'rake', '~> 12.3'

group :nanoc do
  gem 'guard-nanoc', '~> 2.1'

  # nanoc checks
  gem 'nokogiri', '~> 1.7.0'

  # Needed to generate Sitemap
  gem 'builder', '~> 3.2'
end

group :test, :development do
  gem 'scss_lint', '~> 0.57', require: false
  gem 'highline', '~> 2.0'
end
