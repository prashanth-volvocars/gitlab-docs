source 'https://rubygems.org'

gem 'nanoc', '~> 4.10'
gem 'adsf', '~> 1.4'
gem 'adsf-live', '~> 1.4'
gem 'sassc', '~> 2.0'
# Later versions of Rouge cause nanoc to hang when
# processing some JSON fenced code blocks.
# Unpin when fixed (current latest version is 3.9.0).
gem 'rouge', '3.7.0'
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
end
