FROM gitpod/workspace-full

RUN rvm install 2.7.2 \
    && brew install vale \
    && bundle exec rake \
    && bundle exec nanoc compile