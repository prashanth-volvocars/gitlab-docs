[> How to](https://about.gitlab.com/handbook/engineering/ux/technical-writing/workflow/#monthly-documentation-releases)

## During release

1. [ ] Push the new version which will create a Docker image with the stable version:
   ```sh
   bundle exec rake "release:single[X.Y]"
   ```
1. [ ] Edit `content/_data/versions.yaml` and `Dockerfile.master` and rotate the versions.

## Before merge

On the 22nd, before merging this MR:

1. [ ] Bump the dropdown versions for all online versions:
   ```sh
   bundle exec rake release:dropdowns
   ```

   This creates all the [needed merge requests](https://gitlab.com/gitlab-org/gitlab-docs/-/merge_requests?label_name[]=release).
1. [ ] Check that all of the above MRs' pipelines pass and merge them.
       Once all above MRs are merged, check the newly-created pipelines of the
       respective versions https://gitlab.com/gitlab-org/gitlab-docs/pipelines.
       Once they are green, it's time to merge this MR.
1. [ ] Manually run the ["Build docker images weekly" scheduled pipeline](https://gitlab.com/gitlab-org/gitlab-docs/pipeline_schedules).
       This is needed so that the `image:docs-latest` image is built that will
       contain all the updated versions.

/label ~release
