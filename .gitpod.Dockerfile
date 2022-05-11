FROM gitpod/workspace-full:2022-05-08-14-31-53
USER gitpod

# Install Ruby version 2.7.5 and set it as default.
# Required when the base Gitpod Docker image doesn't provide the version of Ruby we want.
# For more information, see: https://www.gitpod.io/docs/languages/ruby.

RUN echo "rvm_gems_path=/home/gitpod/.rvm" > ~/.rvmrc \
  && bash -lc "rvm install ruby-2.7.5 && rvm use ruby-2.7.5 --default" \
  && echo "rvm_gems_path=/workspace/.rvm" > ~/.rvmrc
