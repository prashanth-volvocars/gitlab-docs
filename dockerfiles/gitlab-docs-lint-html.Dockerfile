############################
#
# Image that contains the dependencies to run the lints.
# It downloads the gitlab-docs repository based on the
# branch the Docker image is invoked from.
# Based on Alpine.
#
############################

# RUBY_VERSION and ALPINE_VERSION are defined in .gitlab-ci.yml
ARG RUBY_VERSION
ARG ALPINE_VERSION

FROM ruby:${RUBY_VERSION}-alpine${ALPINE_VERSION}

# Install dependencies
RUN apk add --no-cache -U \
    bash        \
    build-base  \
    curl        \
    git         \
    gnupg       \
    grep        \
    gzip        \
    libcurl     \
    libxslt     \
    libxslt-dev \
    nodejs      \
    openssl     \
    parallel    \
    ruby-dev    \
    tar         \
    xz          \
    xz-dev      \
    yarn        \
    && echo 'gem: --no-document' >> /etc/gemrc \
    && gem update --system 3.3.13

# Set up needed environment variables that are called with --build-arg when
# the Docker image is built (see .gitlab-ci.yml).
ARG CI_COMMIT_REF_NAME
# If CI_COMMIT_REF_NAME is not set (local development), set it to main
ENV CI_COMMIT_REF_NAME ${CI_COMMIT_REF_NAME:-main}

WORKDIR /tmp

RUN wget --quiet https://gitlab.com/gitlab-org/gitlab-docs/-/archive/$CI_COMMIT_REF_NAME/gitlab-docs-$CI_COMMIT_REF_NAME.tar.bz2 \
  && tar xvjf gitlab-docs-$CI_COMMIT_REF_NAME.tar.bz2 \
  && mv gitlab-docs-$CI_COMMIT_REF_NAME gitlab-docs \
  && rm gitlab-docs-$CI_COMMIT_REF_NAME.tar.bz2

WORKDIR /tmp/gitlab-docs/

RUN yarn install --frozen-lockfile \
  && yarn cache clean --all \
  && bundle update --bundler \
  && bundle install --jobs 4
