# GitLab Docs linting (HTML) Docker image
#
FROM registry.gitlab.com/gitlab-org/gitlab-docs/base:alpine-3.15-ruby-2.7.5-ed77855b

# Report dependencies
RUN printf "\n\e[32mINFO: Dependency versions:\e[39m\n" \
    && echo "Ruby: $(ruby --version)" \
    && echo "RubyGems: $(gem --version)" \
    && echo "Bundler: $(bundle --version)" \
    && echo "Node.js: $(node --version)" \
    && echo "Yarn: $(yarn --version)" \
    && printf "\n"

WORKDIR /tmp

# Fetch gitlab-docs
RUN printf "\n\e[32mINFO: Fetching gitlab-docs from main branch..\e[39m\n" \
  && wget --quiet https://gitlab.com/gitlab-org/gitlab-docs/-/archive/main/gitlab-docs-main.tar.bz2 \
  && tar xvjf gitlab-docs-main.tar.bz2 \
  && mv gitlab-docs-main gitlab-docs \
  && rm gitlab-docs-main.tar.bz2

WORKDIR /tmp/gitlab-docs/

# Install gitlab-docs dependencies
RUN printf "\n\e[32mINFO: Installing Node.js and Ruby dependencies..\e[39m\n" \
  && yarn install --frozen-lockfile \
  && yarn cache clean --all \
  && bundle update --bundler \
  && bundle install --jobs 4
