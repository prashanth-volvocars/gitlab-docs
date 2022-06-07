# Base image for other Docker images
#
# RUBY_VERSION and ALPINE_VERSION are defined in ../.gitlab-ci.yml
ARG RUBY_VERSION
ARG ALPINE_VERSION

FROM ruby:${RUBY_VERSION}-alpine${ALPINE_VERSION}

# Install dependencies
RUN printf "\n\e[32mINFO: Installing dependencies..\e[39m\n" && apk add --no-cache -U \
    bash         \
    build-base   \
    curl         \
    gcompat      \
    git          \
    gnupg        \
    grep         \
    gzip         \
    jq           \
    libc6-compat \
    libcurl      \
    libxslt      \
    libxslt-dev  \
    nodejs       \
    openssl      \
    parallel     \
    pngquant     \
    ruby-dev     \
    tar          \
    xz           \
    xz-dev       \
    yarn         \
    && echo 'gem: --no-document' >> /etc/gemrc \
    && gem update --silent --system \
    && printf "\n\e[32mINFO: Dependency versions:\e[39m\n" \
    && echo "Ruby: $(ruby --version)" \
    && echo "RubyGems: $(gem --version)" \
    && echo "Bundler: $(bundle --version)" \
    && echo "Node.js: $(node --version)" \
    && echo "Yarn: $(yarn --version)" \
    && printf "\n"
