.PHONY: all clean test up

INFO = \033[32m
INFO_END = \033[0m

../gitlab/.git:
	@echo "\n$(INFO)INFO: Cloning GitLab project into parent directory..$(INFO_END)\n"
	@git clone git@gitlab.com:gitlab-org/gitlab.git ../gitlab

../gitlab-runner/.git:
	@printf "\n$(INFO)INFO: Cloning GitLab Runner project into parent directory..$(INFO_END)\n"
	@git clone git@gitlab.com:gitlab-org/gitlab-runner.git ../gitlab-runner

../omnibus-gitlab/.git:
	@printf "\n$(INFO)INFO: Cloning Omnibus GitLab project into parent directory..$(INFO_END)\n"
	@git clone git@gitlab.com:gitlab-org/omnibus-gitlab.git ../omnibus-gitlab

../charts-gitlab/.git:
	@printf "\n$(INFO)INFO: Cloning GitLab Chart project into parent directory..$(INFO_END)\n"
	@git clone git@gitlab.com:gitlab-org/charts/gitlab.git ../charts-gitlab

../gitlab-operator/.git:
	@printf "\n$(INFO)INFO: Cloning GitLab Operator project into parent directory..$(INFO_END)\n"
	@git clone git@gitlab.com:gitlab-org/cloud-native/gitlab-operator.git ../gitlab-operator

clone-all-docs-projects: ../gitlab/.git ../gitlab-runner/.git ../omnibus-gitlab/.git ../charts-gitlab/.git ../gitlab-operator/.git

update-gitlab: ../gitlab/.git
	@printf "\n$(INFO)INFO: Stash any changes, switch to master branch, and pull updates to GitLab project..$(INFO_END)\n"
	@cd ../gitlab && git stash && git checkout master && git pull --ff-only

update-gitlab-runner: ../gitlab-runner/.git
	@printf "\n$(INFO)INFO: Stash any changes, switch to main branch, and pull updates to GitLab Runner project..$(INFO_END)\n"
	@cd ../gitlab-runner && git stash && git checkout main && git pull --ff-only

update-omnibus-gitlab: ../omnibus-gitlab/.git
	@printf "\n$(INFO)INFO: Stash any changes, switch to master branch, and pull updates to Omnibus GitLab project..$(INFO_END)\n"
	@cd ../omnibus-gitlab && git stash && git checkout master && git pull --ff-only

update-charts-gitlab: ../charts-gitlab/.git
	@printf "\n$(INFO)INFO: Stash any changes, switch to master branch, and pull updates to GitLab Chart project..$(INFO_END)\n"
	@cd ../charts-gitlab && git stash && git checkout master && git pull --ff-only

update-gitlab-operator: ../gitlab-operator/.git
	@printf "\n$(INFO)INFO: Stash any changes, switch to master branch, and pull updates to GitLab Operator project..$(INFO_END)\n"
	@cd ../gitlab-operator && git stash && git checkout master && git pull --ff-only

update-all-docs-projects: update-gitlab update-gitlab-runner update-omnibus-gitlab update-charts-gitlab update-gitlab-operator

up: setup view

compile: setup
	@printf "\n$(INFO)INFO: Compiling GitLab documentation site..$(INFO_END)\n"
	@bundle exec nanoc compile

view: compile
	@printf "\n$(INFO)INFO: Starting GitLab documentation site..$(INFO_END)\n"
	@bundle exec nanoc view

live: compile
	@printf "\n$(INFO)INFO: Starting GitLab documentation site with live reload..$(INFO_END)\n"
	bundle exec nanoc live

setup:
	@printf "\n$(INFO)INFO: Installing dependencies..$(INFO_END)\n"
	@asdf install && bundle install && yarn install --frozen-lockfile

update:
	@printf "\n$(INFO)INFO: Stash any changes, switch to main branch, and pull updates to GitLab Docs project..$(INFO_END)\n"
	@git stash && git checkout main && git pull --ff-only

update-all-projects: update update-all-docs-projects

clean:
	@printf "\n$(INFO)INFO: Removing tmp and public directories..$(INFO_END)\n"
	@rm -rf tmp public

internal-links-check: clone-all-docs-projects compile
	@printf "\n$(INFO)INFO: Checking all internal links..$(INFO_END)\n"
	@bundle exec nanoc check internal_links

internal-anchors-check: clone-all-docs-projects compile
	@printf "\n$(INFO)INFO: Checking all internal anchors..$(INFO_END)\n"
	@bundle exec nanoc check internal_anchors

internal-links-and-anchors-check: clone-all-docs-projects compile
	@printf "\n$(INFO)INFO: Checking all internal links and anchors..$(INFO_END)\n"
	@parallel time bundle exec nanoc check ::: internal_links internal_anchors

external-links-check: compile
	@printf "\n$(INFO)INFO: Checking all external links..$(INFO_END)\n"
	@bundle exec nanoc check external_links

brew-bundle:
	@printf "\n$(INFO)INFO: Checking Brew dependencies, if Brew is available..$(INFO_END)\n"
	@(command -v brew > /dev/null 2>&1) && brew bundle --no-lock || true

rspec-tests:
	@printf "\n$(INFO)INFO: Running RSpec tests..$(INFO_END)\n"
	@bundle exec rspec

jest-tests:
	@printf "\n$(INFO)INFO: Running Jest tests..$(INFO_END)\n"
	@yarn test

eslint-tests:
	@printf "\n$(INFO)INFO: Running ESLint tests..$(INFO_END)\n"
	@yarn eslint

prettier-tests:
	@printf "\n$(INFO)INFO: Running Prettier tests..$(INFO_END)\n"
	@yarn prettier

stylelint-tests:
	@printf "\n$(INFO)INFO: Running Stylelint tests..$(INFO_END)\n"
	@scripts/run-stylelint.sh

hadolint-tests:
	@printf "\n$(INFO)INFO: Running hadolint tests..$(INFO_END)\n"
	@hadolint latest.Dockerfile .gitpod.Dockerfile **/*.Dockerfile

yamllint-tests:
	@printf "\n$(INFO)INFO: Running yamllint tests..$(INFO_END)\n"
	@yamllint .gitlab-ci.yml content/_data

test: setup brew-bundle rspec-test jest-tests eslint-tests prettier-tests stylelint-tests hadolint-tests yamllint-tests
