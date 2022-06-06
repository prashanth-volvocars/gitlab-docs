# GitLab Docs linting (Markdown) Docker image
#
FROM registry.gitlab.com/gitlab-org/gitlab-docs/base:alpine-3.15-ruby-2.7.5-ed77855b

# VALE_VERSION and MARKDOWNLINT_VERSION are defined in .gitlab-ci.yml
ARG VALE_VERSION
ARG MARKDOWNLINT_VERSION

# Report dependencies
RUN printf "\n\e[32mINFO: Dependency versions:\e[39m\n" \
    && echo "Ruby: $(ruby --version)" \
    && echo "RubyGems: $(gem --version)" \
    && echo "Bundler: $(bundle --version)" \
    && echo "Node.js: $(node --version)" \
    && echo "Yarn: $(yarn --version)" \
    && printf "\n"

# Install Vale
RUN printf "\n\e[32mINFO: Installing Vale %s..\e[39m\n" "${VALE_VERSION}" \
  && wget --quiet https://github.com/errata-ai/vale/releases/download/v${VALE_VERSION}/vale_${VALE_VERSION}_Linux_64-bit.tar.gz \
  && tar -xvzf vale_${VALE_VERSION}_Linux_64-bit.tar.gz -C bin \
  && echo "Vale: $(vale --version)" \
  && printf "\n"

# Install markdownlint-cli
RUN printf "\n\e[32mINFO: Installing markdownlint-cli %s..\e[39m\n" "${MARKDOWNLINT_VERSION}" \
  && yarn global add markdownlint-cli@${MARKDOWNLINT_VERSION} && yarn cache clean \
  && echo "markdownlint-cli: $(markdownlint --version)" \
  && printf "\n"
