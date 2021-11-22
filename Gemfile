source 'https://rubygems.org'

gem 'nanoc', '~> 4.12.0'
gem 'sassc', '~> 2.4.0'
gem 'rouge', '~> 3.26.0'
gem 'rake', '~> 13.0.0'

group :nanoc do
  gem 'nanoc-live'

  # custom kramdown dialect
  gem 'gitlab_kramdown', '~> 0.14.0'

  # nanoc checks
  gem 'nokogiri', '~> 1.12.0'

  # Needed to generate Sitemap
  gem 'builder', '~> 3.2.0'

  # Needed to compile SCSS
  gem 'sass', '3.7.4'
end

group :test, :development do
  gem 'highline', '~> 2.0.0'
  gem 'rspec', '~> 3.10.0'
  gem 'pry-byebug', '~> 3.9.0', require: false
  gem 'gitlab-styles', '~> 6.5.0', require: false
end
