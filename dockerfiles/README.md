# Dockerfiles used to build the docs site

This directory contains all needed Dockerfiles to build and deploy the website.
It is heavily inspired by Docker's [publish tools](https://github.com/docker/docker.github.io/tree/publish-tools).

The following Dockerfiles are used.

| Dockerfile | Docker image | Description |
| ---------- | ------------ | ----------- |
| [`Dockerfile.bootstrap`](Dockerfile.bootstrap) | `gitlab-docs:bootstrap` | Contains all the dependencies that are needed to build the website. If the gems are updated and `Gemfile{,.lock}` changes, the image must be rebuilt. |
| [`Dockerfile.builder.onbuild`](Dockerfile.builder.onbuild) | `gitlab-docs:builder-onbuild` | Base image to build the docs website. It uses `ONBUILD` to perform all steps and depends on `gitlab-docs:bootstrap`. |
| [`Dockerfile.nginx.onbuild`](Dockerfile.nginx.onbuild) | `gitlab-docs:nginx-onbuild` | Base image to use for building documentation archives. It uses `ONBUILD` to perform all required steps to copy the archive, and relies upon its parent `Dockerfile.builder.onbuild` that is invoked when building single documentation achives (see the `Dockerfile` of each branch. |
| [`Dockerfile.archives`](Dockerfile.archives) | `gitlab-docs:archives` | Contains all the versions of the website in one archive. It copies all generated HTML files from every version in one location. |

## How to build the images

Build and tag all tooling images:

```sh
docker build -t registry.gitlab.com/gitlab-com/gitlab-docs:bootstrap -f Dockerfile.bootstrap ../
docker build -t registry.gitlab.com/gitlab-com/gitlab-docs:builder-onbuild -f Dockerfile.builder.onbuild ../
docker build -t registry.gitlab.com/gitlab-com/gitlab-docs:nginx-onbuild -f Dockerfile.nginx.onbuild ../
```

For each image, there's a manual job under the `images` stage in
[`.gitlab-ci.yml`](../.gitlab-ci.yml) which can be invoked at will.

## Create an archive image for a single version

Now that all required images are created, you can build the archive for each
branch:

1. Create the branch if it doesn't exist. Name the branch by using the major
   minor versions:

    ```
    git checkout -b 10.5
    ```

1. Copy the Dockerfile.archive to Dockerfile:

    ```
    cp Dockerfile{.archive,}
    ```

1. Edit the Dockerfile and add the correct version:

    ```
    # The branch of the docs repo from step 1
    ARG VER=10.5

    # Replace the versions to match the stable branches of the upstream projects
    ARG BRANCH_EE=10-5-stable-ee
    ARG BRANCH_CE=10-5-stable
    ARG BRANCH_OMNIBUS=10-5-stable
    ARG BRANCH_RUNNER=10-5-stable

    FROM registry.gitlab.com/gitlab-com/gitlab-docs:builder-onbuild AS builder
    FROM registry.gitlab.com/gitlab-com/gitlab-docs:nginx-onbuild
    ```

Once you push, the `image:docker-stable` job will create a new Docker image
tagged with the branch name.

## Update the multiple archives image

With every new release on the 22nd, the archives Docker image should be updated.
Edit the following files and add the new version:

- `content/archives/index.md`
- [`Dockerfile.archives`](/Dockerfile.archives)
