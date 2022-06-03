# Base image for other Docker images
FROM ruby:2.7.5-alpine3.15

# Install dependencies
RUN printf "\n\e[32mINFO: Installing dependencies..\e[39m\n" && apk add --no-cache -U \
    bash        \
    build-base  \
    curl        \
    gcompat     \
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
