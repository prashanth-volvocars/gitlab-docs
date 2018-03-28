# How the versioned website is built

This directory contains all needed Dockerfiles to build and deploy the
versioned website. It is heavily inspired by Docker's
[publish tools](https://github.com/docker/docker.github.io/tree/publish-tools).

The following Dockerfiles are used.

| Dockerfile | Docker image | Description |
| ---------- | ------------ | ----------- |
| [`Dockerfile.bootstrap`](Dockerfile.bootstrap) | `gitlab-docs:bootstrap` | Contains all the dependencies that are needed to build the website. If the gems are updated and `Gemfile{,.lock}` changes, the image must be rebuilt. |
| [`Dockerfile.builder.onbuild`](Dockerfile.builder.onbuild) | `gitlab-docs:builder-onbuild` | Base image to build the docs website. It uses `ONBUILD` to perform all steps and depends on `gitlab-docs:bootstrap`. |
| [`Dockerfile.nginx.onbuild`](Dockerfile.nginx.onbuild) | `gitlab-docs:nginx-onbuild` | Base image to use for building documentation archives. It uses `ONBUILD` to perform all required steps to copy the archive, and relies upon its parent `Dockerfile.builder.onbuild` that is invoked when building single documentation achives (see the `Dockerfile` of each branch. |
| [`Dockerfile.archives`](Dockerfile.archives) | `gitlab-docs:archives` | Contains all the versions of the website in one archive. It copies all generated HTML files from every version in one location. |

## How to build the images

You can build and tag all tooling images locally (while in this directory):

```sh
docker build -t registry.gitlab.com/gitlab-com/gitlab-docs:bootstrap -f Dockerfile.bootstrap ../
docker build -t registry.gitlab.com/gitlab-com/gitlab-docs:builder-onbuild -f Dockerfile.builder.onbuild ../
docker build -t registry.gitlab.com/gitlab-com/gitlab-docs:nginx-onbuild -f Dockerfile.nginx.onbuild ../
```

For each image, there's a manual job under the `images` stage in
[`.gitlab-ci.yml`](../.gitlab-ci.yml) which can be invoked at will.

## When a new version is released

When a new version is released, we need to create the single Docker image,
and update the `latest` and `archives` images to include the new version.

### Create an image for a single version

Now that all required images are created, you can build the archive for each
branch:

1. Make sure you're on the root path of the repo
1. Create the branch if it doesn't exist. Name the branch by using the major
   minor versions:

    ```
    git checkout -b 10.5
    ```

1. Copy `Dockerfile.single` to `Dockerfile.$version` in the root path:

    ```
    cp dockerfiles/Dockerfile.single Dockerfile.10.5
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

1. Test locally by building the image and running it:

    ```
    docker build -t docs:10.5 -f Dockerfile.10.5 .
    docker run -it --rm -p 4000:4000 docs:10.5
    ```

1. Visit <http://localhost:4000/10.5/> and make sure everything works correctly
1. Commit your changes and push (don't create a merge request)

Once you push, the `image:docker-singe` job will create a new Docker image
tagged with the branch name.

Rerun the pipeline for the branch if there are upstream changes not included
in the image.

## Updating the `latest` and `archives` images

**Note:** Make sure the single image is built first.

With every new release on the 22nd, we need to update the `latest` and `archives`
Docker images.

For the `archives`, edit the following files and add the new version:

- `content/archives/index.md`
- [`Dockerfile.archives`](Dockerfile.archives)

For the `latest`, edit the following file and add the new version:

- [`Dockerfile.master`](../Dockerfile.master)

Once you push, the new `latest` image will be built and it will contain the new
version. You may need to run the pipeline on master one more for the website
to have all the versions. The `archives` runs on a schedule, usually once an hour.

## Porting new website changes to old versions

The website will keep changing and being improved. In order to consolidate
those changes to the stable branches, we'd need to merge master into them
from time to time.

```sh
git branch 10.5
git fetch origin master
git merge origin/master
```
