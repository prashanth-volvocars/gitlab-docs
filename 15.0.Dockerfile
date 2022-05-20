#
# Copy this Dockerfile to the root of each branch you want to create an archive
#

# Set to the version for this archive (must match the branch name)
ARG VER=15.0

# Replace the versions to march the stable branches of the upstream projects
ARG BRANCH_EE=15-0-stable-ee
ARG BRANCH_OMNIBUS=15-0-stable
ARG BRANCH_RUNNER=15-0-stable
ARG BRANCH_CHARTS=6-0-stable

# This image comes from the builder.onbuild.Dockerfile file
# https://gitlab.com/gitlab-org/gitlab-docs/blob/main/dockerfiles/Dockerfile.builder.onbuild
# Build the website
FROM registry.gitlab.com/gitlab-org/gitlab-docs:builder-onbuild AS builder

# This image comes from the nginx.onbuild.Dockerfile file
# https://gitlab.com/gitlab-org/gitlab-docs/blob/main/dockerfiles/Dockerfile.nginx.onbuild
# Copy the generated HTML files to a smaller image
FROM registry.gitlab.com/gitlab-org/gitlab-docs:nginx-onbuild
