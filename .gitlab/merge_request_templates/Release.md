[> How to](https://gitlab.com/gitlab-org/gitlab-docs/blob/master/dockerfiles/README.md)

## During release

1. [ ] Push the new version which will create a Docker image with the stable version:

   ```sh
   bundle exec rake "release:single[X.Y]"
   ```

1. [ ] Make sure the proper milestone is assigned to this MR and:
    1. [ ] Edit `content/_data/versions.yaml` and rotate the versions.
    1. [ ] Edit `content/404.html` and add the old removed version to the list of redirects at the bottom of the file.
    1. [ ] Edit `dockerfiles/Dockerfile.archives` and add the new version.
    1. [ ] Edit `Dockerfile.master` and rotate the versions.
1. [ ] \(Optional) If there are changes in the stable branches of the docs **after** the release version Docker image was created, rerun the release version pipeline.

## Before merge

On the 22nd, a few minutes before merging this and **before the scheduled pipeline runs**:

1. [ ] Bump the versions in `content/_data/versions.yaml` for all online versions by pushing the change to the according stable branches.
1. [ ] Now it's time to merge.

## After merge

1. [ ] Manually run the [scheduled pipeline](https://gitlab.com/gitlab-org/gitlab-docs/pipeline_schedules).

/label ~release
