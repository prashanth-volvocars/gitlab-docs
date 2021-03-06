#
# This Dockerfile is mainly used to create the docs:latest image which includes
# the latest 3 stable versions plus the most recent one built from main.
#

# First use the bootstrap image to build main
FROM registry.gitlab.com/gitlab-org/gitlab-docs/base:alpine-3.16-ruby-2.7.6-0bc327a4 as builder

# Set up needed environment variables that are called with --build-arg when
# the Docker image is built (see .gitlab-ci.yml).
ARG NANOC_ENV
ARG CI_COMMIT_REF_NAME
# If CI_COMMIT_REF_NAME is not set (local development), set it to main
ENV CI_COMMIT_REF_NAME ${CI_COMMIT_REF_NAME:-main}

# Build the docs from this branch
COPY . /source/
# Copy only the Gemfiles and yarn.lock to install the dependencies
COPY /Gemfile* /source/
COPY /yarn.lock /source/
WORKDIR /source

RUN yarn install && \
    bundle install && \
    bundle exec rake setup_git default && \
    bundle exec nanoc compile -VV && \
    scripts/compress_images.sh public ee # compress images

# Symlink EE to CE
# https://gitlab.com/gitlab-org/gitlab-docs/issues/418
WORKDIR /source/public/
RUN rm -rf ce && ln -s ee ce

# BUILD OF 'main' DOCS IS NOW DONE!

# Reset to alpine so we don't get any docs source or extra apps
FROM nginx:1.12-alpine

ENV TARGET=/usr/share/nginx/html

# Get the nginx config from the nginx-onbuild image
# This hardly ever changes so should usually be cached
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:nginx-onbuild /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

# Remove default Nginx HTML files
RUN rm -rf /usr/share/nginx/html/*

# Get all the archive static HTML and put it into place
# Copy the versions found in 'content/_data/versions.yaml' under online
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:15.1 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:15.0 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:14.10 ${TARGET} ${TARGET}

# List the two last major versions
# Copy the versions found in 'content/_data/versions.yaml' under previous_majors
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:14.10 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:13.12 ${TARGET} ${TARGET}

# Get the built docs output from the previous build stage
# This ordering means all previous layers can come from cache unless an archive
# changes
COPY --from=builder /source/public ${TARGET}

# Build minifier utility
# Adapted from https://github.com/docker/docker.github.io/blob/publish-tools/Dockerfile.builder
#
FROM golang:1.13-alpine AS minifier
RUN apk add --no-cache git
RUN export GO111MODULE=on \
  && go get -d github.com/tdewolff/minify/v2@latest \
  && go build -v -o /minify github.com/tdewolff/minify/cmd/minify
WORKDIR /source
COPY /scripts/minify* scripts/

# Serve the site (target), which is now all static HTML
CMD ["sh", "-c", "echo 'GitLab docs are viewable at: http://0.0.0.0:4000'; exec nginx -g 'daemon off;'"]
