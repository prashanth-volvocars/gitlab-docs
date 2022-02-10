source 'https://rubygems.org'

gem 'nanoc', '~> 4.12.0'
gem 'sassc', '~> 2.4.0'
gem 'rake', '~> 13.0.0'

group :nanoc do
  gem 'nanoc-live'

  # custom kramdown dialect
  gem 'gitlab_kramdown', git: 'https://gitlab.com/gitlab-org/gitlab_kramdown', branch: 'sh-plantuml-clickable-link'

  # Needed to generate Sitemap
  gem 'builder', '~> 3.2.0'

  # Needed to compile SCSS
  gem 'sass', '3.7.4'
end

group :test, :development do
  gem 'highline', '~> 2.0.0'
  gem 'rspec', '~> 3.10.0'
  gem 'pry-byebug', '~> 3.9.0', require: false
  gem 'gitlab-styles', '~> 6.6.0', require: false
end
