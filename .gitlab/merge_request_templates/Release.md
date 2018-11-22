**Merge on the 22nd at 14:30 UTC**

[> How to](https://gitlab.com/gitlab-com/gitlab-docs/blob/master/dockerfiles/README.md)

## Before release

- [ ] Create and push a branch with the release name (that will create a Docker image with the stable version).

## During release

- [ ] Make sure the proper milestone is assigned to the MR.
- [ ] \(Optional) If there are changes in the stable branches of the docs **after** the release version Docker image was created, rerun the release version pipeline.
- [ ] Edit `content/_data/versions.yaml` and rotate the versions.
- [ ] Edit `content/404.html` and add the old removed version to the list of redirects at the bottom of the file.
- [ ] Edit `dockerfiles/Dockerfile.archives` and add the new version.
- [ ] Edit `Dockerfile.master` and rotate the versions.
- [ ] Merge and manually run the [scheduled pipeline](https://gitlab.com/gitlab-com/gitlab-docs/pipeline_schedules).

/label ~release
