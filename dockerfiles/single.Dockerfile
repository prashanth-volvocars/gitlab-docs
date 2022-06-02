#
# Copy this Dockerfile to the root of each branch you want to create an archive
# and rename it to X.Y.Dockerfile, where X.Y the major.minor GitLab version.
#

#- Start of minifier stage -#

#
# Build minifier utility
# Adapted from https://github.com/docker/docker.github.io/blob/publish-tools/Dockerfile.builder
#
FROM golang:1.13-alpine AS minifier
RUN apk add --no-cache git \
    && export GO111MODULE=on \
    && go get -d github.com/tdewolff/minify/v2@latest \
    && go build -v -o /minify github.com/tdewolff/minify/cmd/minify

#- End of minifier stage -#

#- Start of builder stage -#

FROM ruby:2.7.5-alpine3.15 AS builder

# Copy minifier binary from the minifier stage
COPY --from=minifier /minify /usr/local/bin/minify

#
# Set the following variables as ARGs and pass them with --build-arg when
# building the Docker image.
#
ARG NANOC_ENV=production
ARG VER
ARG CI_COMMIT_REF_NAME

#
# Install Nanoc dependencies and tools that
# are needed to build the docs site and run the tests.
#
RUN apk add --no-cache -U \
    bash        \
    build-base  \
    curl        \
    git         \
    gnupg       \
    go          \
    grep        \
    gzip        \
    jq          \
    libcurl     \
    libxslt     \
    libxslt-dev \
    nodejs      \
    openssl     \
    pngquant    \
    ruby-dev    \
    tar         \
    xz          \
    xz-dev      \
    yarn        \
    && echo 'gem: --no-document' >> /etc/gemrc \
    && gem update --silent --system 3.3.13 \
    && printf "\n\e[32mINFO: Dependency versions:\e[39m\n" \
    && echo "Ruby: $(ruby --version)" \
    && echo "RubyGems: $(gem --version)" \
    && echo "Node.js: $(node --version)" \
    && echo "Yarn: $(yarn --version)" \
    && printf "\n"

# Build the docs from this branch
COPY . /source/
WORKDIR /source

RUN yarn install --frozen-lockfile                              \
    && yarn cache clean                                         \
    && bundle config set --local deployment true                \
    && bundle install --jobs 4                                  \
    && bundle exec rake setup_git default                       \
    && bundle exec nanoc compile -VV

# Move generated HTML to /site
RUN mkdir /site \
    && mv public "/site/${VER}"

# Do some HTML post-processing on the archive, compress images, and minify assets
RUN /source/scripts/normalize-links.sh /site "${VER}"    \
    && /source/scripts/compress_images.sh /site "${VER}" \
    && /source/scripts/minify-assets.sh /site "${VER}" # ATTENTION: This should be the last script to run

# Make an index.html and 404.html which will redirect / to /${VER}/
RUN echo "<html><head><title>Redirect for ${VER}</title><meta http-equiv=\"refresh\" content=\"0;url='/${VER}/'\" /></head><body><p>If you are not redirected automatically, click <a href=\"/${VER}/\">here</a>.</p></body></html>" > /site/index.html \
    && echo "<html><head><title>Redirect for ${VER}</title><meta http-equiv=\"refresh\" content=\"0;url='/${VER}/'\" /></head><body><p>If you are not redirected automatically, click <a href=\"/${VER}/\">here</a>.</p></body></html>" > /site/404.html

#- End of builder build stage -#

#- Start of NGINX stage -#
#
# Copy the ending HTML files from the previous 'builder' stage and copy them
# to an NGINX Docker image.
#
FROM nginx:alpine

# Clean out any existing HTML files, and copy the HTML from the builder stage
# to the default location for Nginx.
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /site /usr/share/nginx/html

# Copy the Nginx config
COPY dockerfiles/nginx-overrides.conf /etc/nginx/conf.d/default.conf

# Start Nginx to serve the archive at / (which will redirect to the version-specific dir)
CMD ["sh", "-c", "echo 'GitLab docs are viewable at: http://0.0.0.0:4000'; exec nginx -g 'daemon off;'"]

#- End of NGINX stage -#
