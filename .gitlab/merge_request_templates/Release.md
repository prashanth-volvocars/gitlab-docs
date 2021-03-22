[> How to](https://docs.gitlab.com/ee/development/documentation/site_architecture/release_process.html)

## During release

1. [ ] Push the new version which will create a Docker image with the stable version:
   ```sh
   bundle exec rake "release:single[X.Y]"
   ```
1. [ ] Edit `content/_data/versions.yaml` and rotate the versions.
1. [ ] Edit `dockerfiles/Dockerfile.archives` and add the new version.
1. [ ] Edit `Dockerfile.master` and rotate the versions.

## Before merge

On the 22nd, before merging this MR:

1. [ ] Bump the dropdown versions for all online versions:
   ```sh
   bundle exec rake release:dropdowns
   ```
   This will create all the [needed merge requests](https://gitlab.com/gitlab-org/gitlab-docs/-/merge_requests?label_name[]=release) and will set them to MWPS.
1. [ ] Once all above MRs are merged, check the newly-created pipelines of the
       respective versions https://gitlab.com/gitlab-org/gitlab-docs/pipelines.
       Once they are green, it's time to merge this MR.
1. [ ] Manually run the ["Build docker images weekly" scheduled pipeline](https://gitlab.com/gitlab-org/gitlab-docs/pipeline_schedules).
       This is needed so that the `image:docs-latest` image is built that will
       contain all the updated versions.

/label ~release
