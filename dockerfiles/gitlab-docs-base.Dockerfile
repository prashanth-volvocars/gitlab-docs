#
# Image that contains all Nanoc dependencies and tools that
# are needed to build the docs site and run the tests.
#
FROM ruby:2.7.5-alpine3.15

# Install dependencies
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
    && gem update --system 3.3.13