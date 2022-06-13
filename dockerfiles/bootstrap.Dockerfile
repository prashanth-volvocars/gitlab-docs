# DEPRECATED: DO NOT UPDATE

# This is the Nanoc bootstrap Dockerfile which builds an image that contains
# all Nanoc's runtime dependencies and gems.

#
# Build minifier utility
# Adapted from https://github.com/docker/docker.github.io/blob/publish-tools/Dockerfile.builder
#
FROM golang:1.13-alpine AS minifier
RUN apk add --no-cache git
RUN export GO111MODULE=on \
  && go get -d github.com/tdewolff/minify/v2@latest \
  && go build -v -o /minify github.com/tdewolff/minify/cmd/minify

#
# Image that contains all needed dependencies
#
FROM registry.gitlab.com/gitlab-org/gitlab-docs:base

# Copy only the Gemfiles and yarn.lock to install the dependencies
COPY /Gemfile* /source/
COPY /yarn.lock /source/
WORKDIR /source

# Install gems and node libraries
RUN NOKOGIRI_USE_SYSTEM_LIBRARIES=1 bundle install --jobs 4 && \
    yarn install && \
    yarn cache clean

# Copy scripts used for static HTML post-processing
COPY scripts /scripts/
COPY --from=minifier /minify /usr/local/bin/minify

CMD ["echo 'Nothing to do here. This is the bootstrap image that contains all dependencies to build the docs site.'"]
