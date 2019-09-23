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

On the 22nd, before merging this and **right after a scheduled pipeline has run**:

1. [ ] Bump the dropdown versions for all online versions:

   ```sh
   bundle exec rake release:dropdowns
   ```

1. [ ] Merge all merge requests created from the above command.
1. [ ] Once all above pipelines are green, it's time to merge this MR.
1. [ ] \(Optional) Manually run the [scheduled pipeline](https://gitlab.com/gitlab-org/gitlab-docs/pipeline_schedules).

/label ~release
