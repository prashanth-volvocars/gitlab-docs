.PHONY: all clean test up

up: setup view

compile: setup
	@bundle exec nanoc compile

view: compile
	@bundle exec nanoc view

live: compile
	bundle exec nanoc live

setup:
	@asdf install && bundle install && yarn install --frozen-lockfile

clean:
	@rm -rf tmp public

internal-links-check: compile
	@bundle exec nanoc check internal_links

internal-anchors-check: compile
	@bundle exec nanoc check internal_anchors

internal-links-and-anchors-check: compile
	@parallel time bundle exec nanoc check ::: internal_links internal_anchors

external-links-check: compile
	@bundle exec nanoc check external_links

test: setup
	@bundle exec rspec && yarn test && yarn eslint && yarn prettier && hadolint latest.Dockerfile .gitpod.Dockerfile **/*.Dockerfile
