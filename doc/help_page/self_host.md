# How to self-host the docs site

The following guide describes how to use a local instance of the docs site with
a self-hosted GitLab instance.

## Run the docs site

The easiest way to run the docs site locally it to pick up one of the existing
Docker images that contain the HTML files.

Pick the version that matches your GitLab version and run it, in the following
examples 14.3.

### Locally with Docker

The Docker images use a built-in webserver listeing to port `4000`, so you need
to expose that.

In the server that you host GitLab, or any other server that your GitLab instance
can talk to, you can use Docker to pull the docs site:

```shell
docker run -it --rm -p 4000:4000 registry.gitlab.com/gitlab-org/gitlab-docs:14.3
```

If you use [Docker compose](https://docs.gitlab.com/ee/install/docker.html#install-gitlab-using-docker-compose)
to host your GitLab instance, add the following to `docker-compose.yaml`:

```yaml
gitlab:
  image: 'gitlab/gitlab-ee:14.3.1-ee.0'
  restart: always
  hostname: 'gitlab.example.com'
  environment:
    GITLAB_OMNIBUS_CONFIG: |
      external_url 'https://gitlab.example.com'
      # Add any other gitlab.rb configuration here, each on its own line
  ports:
    - '80:80'
    - '443:443'
    - '22:22'
  volumes:
    - '$GITLAB_HOME/config:/etc/gitlab'
    - '$GITLAB_HOME/logs:/var/log/gitlab'
    - '$GITLAB_HOME/data:/var/opt/gitlab'

docs:
  image: registry.gitlab.com/gitlab-org/gitlab-docs:14.3
  hostname: 'https://gitlab.example.com'
  ports:
    - '4000:4000'
```

### In GitLab Pages

You can also host the docs site in GitLab Pages (haven't tested, but should work).

Make sure you choose a [user or group page](https://docs.gitlab.com/ee/user/project/pages/getting_started_part_one.html#user-and-group-website-examples),
and add the following job in its `.gitlab-ci.yml`:

```yaml
image: registry.gitlab.com/gitlab-org/gitlab-docs:14.3
pages:
  script:
  - mkdir public
  - cp -a /usr/share/nginx/html/14.3 public/
  artifacts:
    paths:
    - public
```

In the end, the docs would be under `https://pages.example.io/14.3/`.

### On your own webserver

Since the docs site is static, you can grab the directory from the container
(under `/usr/share/nginx/html`) and use your own web server to host
it wherever you want. Replace `<destination>` with the directory where the
docs will be copied to:

```shell
docker create -it --name gitlab-docs registry.gitlab.com/gitlab-org/gitlab-docs:14.3 bash
docker cp gitlab-docs:/usr/share/nginx/html <destination>
docker rm -f gitlab-docs
```

In that case, make sure that the docs live under a relative URL which is the same
as your GitLab version. Read more in the [caveats](#caveats).

## Redirect the `/help` links to the new docs page

The feature was [introduced](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/42702)
in GitLab 13.5. There's an issue to [remove the feature flag](https://gitlab.com/gitlab-org/gitlab/-/issues/255328)
and make this the default.

1. [Enable](https://docs.gitlab.com/ee/user/admin_area/settings/help_page.html#redirect-help-pages)
   the `/help` redirect feature.
1. Use the Fully Qualified Domain Name as the docs URL. For example, if you
   used the Docker method as described in the previous step, enter `http://0.0.0.0:4000`.
   Notice that you don't need to append the version.
1. Test that everything works by selecting the **Learn more** link on the page
   you're on. Your GitLab version is automatically detected and appended to the docs URL
   you set in the admin area. In this example, if your GitLab version is 14.3,
   `https://<instance_url>/` becomes `http://0.0.0.0:4000/14.3/`.
   The link inside GitLab link shows as `<instance_url>/help/user/admin_area/settings/help_page#destination-requirements`,
   but when you select it, you are redirected to `http://0.0.0.0:4000/14.3/ee/user/admin_area/settings/help_page/#destination-requirements`.

## Caveats

- You need to host the docs site under a subdirectory matching your GitLab version,
  in the example of this guide `14.3/`. The
  [Docker images](https://gitlab.com/gitlab-org/gitlab-docs/container_registry/631635)
  hosted by the Docs team provide this by default. We use a
  [script](https://gitlab.com/gitlab-org/gitlab-docs/-/blob/2995d1378175803b22fb8806ba77adf63e79f32c/scripts/normalize-links.sh#L28-82)
  to normalize the links and prefix them with the respective version.
- The version dropdown will show more versions which do not exist and will lead
  to 404 if selected.
- The search results point to `docs.gitlab.com` and not the local, self-hosted docs.
- When you use the Docker images to serve the docs site, the landing page redirects
  by default to the respective version, for example `/14.3/`, so you will never
  see the landing page as seen at <https://docs.gitlab.com>.
