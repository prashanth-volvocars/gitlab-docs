.PHONY: all clean test up

up: setup view

view:
	@bundle exec nanoc compile && bundle exec nanoc view

live:
	@bundle exec nanoc compile && bundle exec nanoc live

setup:
	@asdf install && bundle install && yarn install --frozen-lockfile

clean:
	@rm -rf tmp public

test: setup
	@bundle exec rspec && yarn test && yarn eslint && yarn prettier
