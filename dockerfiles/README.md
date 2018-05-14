# How the website versions are built

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [How to build the images](#how-to-build-the-images)
- [When a new version is released](#when-a-new-version-is-released)
    - [1. Create an image for a single version](#1-create-an-image-for-a-single-version)
    - [2. Update the `latest` and `archives` images](#2-update-the-latest-and-archives-images)
    - [3. Rotate the versions](#3-rotate-the-versions)
- [Update an old image with new upstream content](#update-an-old-image-with-new-upstream-content)
- [Porting new website changes to old versions](#porting-new-website-changes-to-old-versions)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

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

### 1. Create an image for a single version

1. Make sure you're on the root path of the repo
1. Create the branch if it doesn't exist. Name the branch by using the major
   minor versions:

    ```
    git checkout -b 10.5
    ```

1. Run the raketask to create the single version:

    ```
    bundle exec rake "release:single[10.5]"
    ```

    A new `Dockerfile.10.5` should have been created.

1. Test locally by building the image and running it:

    ```
    docker build -t docs:10.5 -f Dockerfile.10.5 .
    docker run -it --rm -p 4000:4000 docs:10.5
    ```

1. Visit <http://localhost:4000/10.5/> and make sure everything works correctly
1. Commit your changes and push, but **don't create a merge request**

Once you push, the `image:docker-singe` job will create a new Docker image
tagged with the branch name you created in the first step.

### 2. Update the `latest` and `archives` images

**Note:**
Make sure the mentioned [single images](#create-an-image-for-a-single-version)
are built first.

With every new release on the 22nd, we need to update the `latest` and `archives`
Docker images.

There are 2 things to change:

1. [`Dockerfile.archives`](Dockerfile.archives)
1. [`Dockerfile.master`](../Dockerfile.master)

Once you push, you may need to [run the scheduled pipeline](https://gitlab.com/gitlab-com/gitlab-docs/pipeline_schedules)
(press the play button), since both of those images are built on a schedule,
once an hour.

Once done, the new `latest` image will be built and it will contain the new
version.

### 3. Rotate the versions

**Note:**
Make sure the `latest` image is already updated to reflect the new versions

At any given time, there are 4 browsable online versions: one pulled from
the upstream master branches and the three latest stable versions.

Edit [`content/_data/versions.yaml`](../content/_data/versions.yaml) and rotate
the versions to reflect the new changes:

- `current`: the latest stable
- `previous`: the 2 versions before stable that are available online
- `offline`: all the previous versions not available online

Create a merge request with the changes and check if the links in the `/archives`
page work as expected. If not, the `latest` image is possibly not yet updated.

## Update an old image with new upstream content

If there are upstream changes not included in the single Docker image, just
[rerun the pipeline](https://gitlab.com/gitlab-com/gitlab-docs/pipelines/new)
for the branch in question.

## Porting new website changes to old versions

The website will keep changing and being improved. In order to consolidate
those changes to the stable branches, we'd need to merge master into them
from time to time.

```sh
git branch 10.5
git fetch origin master
git merge origin/master
```

Note that can have unintended effects as we're constantly changing the backend
of the website. Use only when you know what you're doing.
