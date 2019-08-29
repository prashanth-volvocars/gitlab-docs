source 'https://rubygems.org'

# Use the development branch of Nanoc to test
# https://github.com/nanoc/nanoc/issues/1445#issuecomment-525607877
gem 'nanoc', github: 'nanoc/nanoc', ref: '94422c7'
#gem 'nanoc', '~> 4.10'
#
gem 'adsf', '~> 1.4'
gem 'adsf-live', '~> 1.4'
gem 'sassc', '~> 2.0'
gem 'rouge', '~> 3.2'
gem 'rake', '~> 12.3'

group :nanoc do
  gem 'guard-nanoc', '~> 2.1'

  # custom kramdown dialect
  gem 'gitlab_kramdown', '~> 0.6.0'

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
  gem 'mdl', '~> 0.5.0'
end
