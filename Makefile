.PHONY: all clean test up

../gitlab/.git:
	@echo "\nINFO: Cloning GitLab project into parent directory.."
	@git clone git@gitlab.com:gitlab-org/gitlab.git ../gitlab

../gitlab-runner/.git:
	@echo "\nINFO: Cloning GitLab Runner project into parent directory.."
	@git clone git@gitlab.com:gitlab-org/gitlab-runner.git ../gitlab-runner

../omnibus-gitlab/.git:
	@echo "\nINFO: Cloning Omnibus GitLab project into parent directory.."
	@git clone git@gitlab.com:gitlab-org/omnibus-gitlab.git ../omnibus-gitlab

../charts-gitlab/.git:
	@echo "\nINFO: Cloning GitLab Chart project into parent directory.."
	@git clone git@gitlab.com:gitlab-org/charts/gitlab.git ../charts-gitlab

../gitlab-operator/.git:
	@echo "\nINFO: Cloning GitLab Operator project into parent directory.."
	@git clone git@gitlab.com:gitlab-org/cloud-native/gitlab-operator.git ../gitlab-operator

clone-all-docs-projects: ../gitlab/.git ../gitlab-runner/.git ../omnibus-gitlab/.git ../charts-gitlab/.git ../gitlab-operator/.git

update-gitlab: ../gitlab/.git
	@echo "\nINFO: Stash any changes, switch to master branch, and pull updates to GitLab project.."
	@cd ../gitlab && git stash && git checkout master && git pull --ff-only

update-gitlab-runner: ../gitlab-runner/.git
	@echo "\nINFO: Stash any changes, switch to main branch, and pull updates to GitLab Runner project.."
	@cd ../gitlab-runner && git stash && git checkout main && git pull --ff-only

update-omnibus-gitlab: ../omnibus-gitlab/.git
	@echo "\nINFO: Stash any changes, switch to master branch, and pull updates to Omnibus GitLab project.."
	@cd ../omnibus-gitlab && git stash && git checkout master && git pull --ff-only

update-charts-gitlab: ../charts-gitlab/.git
	@echo "\nINFO: Stash any changes, switch to master branch, and pull updates to GitLab Chart project.."
	@cd ../charts-gitlab && git stash && git checkout master && git pull --ff-only

update-gitlab-operator: ../gitlab-operator/.git
	@echo "\nINFO: Stash any changes, switch to master branch, and pull updates to GitLab Operator project.."
	@cd ../gitlab-operator && git stash && git checkout master && git pull --ff-only

update-all-docs-projects: update-gitlab update-gitlab-runner update-omnibus-gitlab update-charts-gitlab update-gitlab-operator

up: setup view

compile: setup
	@bundle exec nanoc compile

view: compile
	@bundle exec nanoc view

live: compile
	bundle exec nanoc live

setup:
	@asdf install && bundle install && yarn install --frozen-lockfile

update:
	@echo "\nINFO: Stash any changes, switch to main branch, and pull updates to GitLab Docs project.."
	@git stash && git checkout main && git pull --ff-only

update-all-projects: update update-all-docs-projects

clean:
	@rm -rf tmp public

internal-links-check: clone-all-docs-projects compile
	@bundle exec nanoc check internal_links

internal-anchors-check: clone-all-docs-projects compile
	@bundle exec nanoc check internal_anchors

internal-links-and-anchors-check: clone-all-docs-projects compile
	@parallel time bundle exec nanoc check ::: internal_links internal_anchors

external-links-check: compile
	@bundle exec nanoc check external_links

test: setup
	@bundle exec rspec && yarn test && yarn eslint && yarn prettier && hadolint latest.Dockerfile .gitpod.Dockerfile **/*.Dockerfile
