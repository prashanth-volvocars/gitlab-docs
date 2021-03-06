FROM nginx:stable-alpine

ENV TARGET=/usr/share/nginx/html

# Get the nginx config from the nginx-onbuild image
# This hardly ever changes so should usually be cached
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:nginx-onbuild /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

# Get all the archive static HTML and put it into place
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:13.10 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:13.9 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:13.8 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:13.7 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:13.6 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:13.5 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:13.4 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:13.3 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:13.2 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:13.1 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:13.0 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:12.10 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:12.9 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:12.8 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:12.7 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:12.6 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:12.5 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:12.4 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:12.3 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:12.2 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:12.1 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:12.0 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:11.11 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:11.10 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:11.9 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:11.8 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:11.7 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:11.6 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:11.5 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:11.4 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:11.3 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:11.2 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:11.1 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:11.0 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:10.8 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:10.7 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:10.6 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:10.5 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:10.4 ${TARGET} ${TARGET}
COPY --from=registry.gitlab.com/gitlab-org/gitlab-docs:10.3 ${TARGET} ${TARGET}

# Serve the site (target), which is now all static HTML
CMD ["sh", "-c", "echo 'GitLab docs are viewable at: http://0.0.0.0:4000'; exec nginx -g 'daemon off;'"]
