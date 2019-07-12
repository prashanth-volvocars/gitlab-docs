[> How to](https://gitlab.com/gitlab-org/gitlab-docs/blob/master/dockerfiles/README.md)

- [ ] Make sure the proper milestone and ~release label are assigned to the MR
- [ ] Create and push a branch with the release name (that will create a Docker image with the stable version)
- [ ] Edit `content/_data/versions.yaml` and rotate the versions
- [ ] Edit `Dockerfile.master` and rotate the versions
- [ ] Edit `dockerfiles/Dockerfile.archives` and add the new version
- [ ] \(Optional) Rerun the stable version pipeline if there are changes in the docs after the Docker image was created
- [ ] Merge and manually run the [scheduled pipeline](https://gitlab.com/gitlab-org/gitlab-docs/pipeline_schedules).

/label ~release
