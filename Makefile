up: setup live

live:
	@bundle exec nanoc live

setup:
	@asdf install && bundle install && yarn install --frozen-lockfile
