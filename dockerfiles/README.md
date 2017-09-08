# Dockerfiles used to build the docs site

This directory contains all needed Dockerfiles to build and deploy the website.
It is heavily inspired by Docker's [publish tools](https://github.com/docker/docker.github.io/tree/publish-tools).

## When to update the Dockerfiles

| Dockerfile | Docker image | Description |
| ---------- | ------------ | ----------- |
| `Dockerfile.bootstrap` | `gitlab-docs:bootstrap` | This image contains all the dependencies that are needed to build the website. If the gems are updated and `Gemfile{,.lock}`  changes, the image must be rebuilt. |

## How to build the images

For each image, there's a manual job under the `images` stage in
[`.gitlab-ci.yml`](../.gitlab-ci.yml).

Build and tag all tooling images:

```sh
docker build -t registry.gitlab.com/gitlab-com/gitlab-docs:bootstrap -f Dockerfile.bootstrap ../
docker build -t registry.gitlab.com/gitlab-com/gitlab-docs:builder-onbuild -f Dockerfile.builder.onbuild ../
docker build -t registry.gitlab.com/gitlab-com/gitlab-docs:nginx-onbuild -f Dockerfile.nginx.onbuild ../
```

For each archive branch, build the archive's image:

```
git checkout 10-4-stable
docker build -t registry.gitlab.com/gitlab-com/gitlab-docs/docs:10.4 .
```
