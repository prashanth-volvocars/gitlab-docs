# First use the bootstrap image to build master
FROM registry.gitlab.com/gitlab-com/gitlab-docs:bootstrap as builder

# Build the docs from this branch
COPY . /source/
RUN bundle exec rake setup_git default
RUN bundle exec nanoc compile -VV

# Remove tmp dir to save some space
RUN rm -rf /source/tmp

# BUILD OF MASTER DOCS IS NOW DONE!

# Reset to alpine so we don't get any docs source or extra apps
FROM nginx:alpine

ENV TARGET=/usr/share/nginx/html

# Get the nginx config from the nginx-onbuild image
# This hardly ever changes so should usually be cached
COPY --from=registry.gitlab.com/gitlab-com/gitlab-docs:nginx-onbuild /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

RUN rm -rf /usr/share/nginx/html/*

# Get all the archive static HTML and put it into place
# Go oldest-to-newest to take advantage of the fact that we change older
# archives less often than new ones.
COPY --from=registry.gitlab.com/gitlab-com/gitlab-docs:9-0 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-com/gitlab-docs:10-3 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-com/gitlab-docs:10-4 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-com/gitlab-docs:10-5 ${TARGET} ${TARGET}

# Get the built docs output from the previous build stage
# This ordering means all previous layers can come from cache unless an archive
# changes
COPY --from=builder /source/public ${TARGET}

# Serve the site (target), which is now all static HTML
CMD echo -e "GitLab docs are viewable at:\nhttp://0.0.0.0:4000"; exec nginx -g 'daemon off;'
