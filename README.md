[![build status](https://gitlab.com/gitlab-com/gitlab-docs/badges/master/build.svg)](https://gitlab.com/gitlab-com/gitlab-docs/commits/master)

# GitLab Documentation

This project hosts the repository which is used to generate the GitLab
documentation website and is deployed to https://docs.gitlab.com. It uses the
[Nanoc](http://nanoc.ws) static site generator.

You will not find any GitLab docs content here. All documentation files are
hosted in the respective repository of each product (see the following section).

## Projects we pull from

There are currently 4 products that are pulled and generate the docs website:

- [GitLab Enterprise Edition](https://gitlab.com/gitlab-org/gitlab-ee)
- [GitLab Community Edition](https://gitlab.com/gitlab-org/gitlab-ce)
- [Omnibus GitLab](https://gitlab.com/gitlab-org/omnibus-gitlab)
- [GitLab Runner](https://gitlab.com/gitlab-org/gitlab-runner)

**NOTE:**
Although GitLab Community Edition is generated, it is hidden from the website
as it's a subset of the Enterprise Edition. We generate it for consistency,
until the [GitLab codebase is unified](https://gitlab.com/gitlab-org/gitlab-ee/issues/2952).

## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md) for an overview of the Developer
Certificate of Origin + License.

To contribute to the content of GitLab docs, see:

- [Writing documentation](https://docs.gitlab.com/ce/development/writing_documentation.html)
- [Style guide](https://docs.gitlab.com/ce/development/doc_styleguide.html)
- [Community writers](https://about.gitlab.com/community-writers/)

## License

See [LICENSE](LICENSE).

## Development under GDK

See [how to preview the docs changes locally using GDK](https://gitlab.com/gitlab-org/gitlab-development-kit/blob/master/doc/howto/gitlab_docs.md).

## Development using this repo

You can clone and use this repo to preview the website as seen on
https://docs.gitlab.com.

### Requirements

Here's what you will need to have:

- A Unix/Linux environment
- Ruby 2.4+
- Bundler

**Note:**
On Windows, the process described here would be different, but as most of
contributors use Unix, we'll go over this process for macOS and Linux users.

#### Ruby

The recommended way is to use a Ruby version manager to install Ruby in your
system.

One way is to use RMV:

1. Install [RVM](https://rvm.io/rvm/install)
1. Install the latest Ruby:

    ```sh
    rvm install 2.5.0
    ```

1. Use the newly installed Ruby:

    ```sh
    rvm use 2.5.0
    ```

Check your Ruby version with `ruby --version`.

#### Bundler

[Bundler](https://bundler.io/) is a Ruby dependency manager. Install it with:

```
gem install bundler
```

#### Clone the repositories

Since this process will clone a few repositories, it might be a good idea to
create a separate directory to have them all together. For example, let's say
the directory will be under your user's home directory. Open a terminal and
execute:

```sh
mkdir ~/dev/gitlab
```

Once you do that, navigate to the directory you'd like the repos to be cloned:

```sh
cd ~/dev/gitlab/
```

Then, it's time to clone the needed repositories.

1. First of all, clone the docs website repository:

    ```sh
    ## Using SSH (for members that have Developer access)
    git clone git@gitlab.com:gitlab-com/gitlab-docs.git

    ## Using HTTPS (for external contributors)
    git clone https://gitlab.com/gitlab-com/gitlab-docs.git
    ```

1. Then, clone the repositories you wish to contribute changes to the documentation.
   For **GitLab contributors**, that do not have Developer access to the projects,
   fork the ones you want (see [projects we pull from](#projects-we-pull-from))
   and then clone them by using your forked version (replace `<username>` with
   your own username):

     ```sh
     ## Using HTTPS (for members that do not have Developer access)

     git clone https://gitlab.com/<username>/gitlab-ce.git
     git clone https://gitlab.com/<username>/gitlab-ee.git
     git clone https://gitlab.com/<username>/gitlab-runner.git
     git clone https://gitlab.com/<username>/omnibus-gitlab.git
     ```

     For members that have Developer access (usually the **GitLab Team members**),
     clone the required repos using SSH:

     ```sh
     ## Using SSH (for members that have Developer access)

     git clone git@gitlab.com:gitlab-org/gitlab-ce.git
     git clone git@gitlab.com:gitlab-org/gitlab-ee.git
     git clone git@gitlab.com:gitlab-org/gitlab-runner.git
     git clone git@gitlab.com:gitlab-org/omnibus-gitlab.git
     ```

### Create the content symlinks

Nanoc expects the Markdown files to be under `content/<slug>`, where `<slug>`
is the slug of each product as defined in [`.nanoc.yaml`](/nanoc.yaml).

If you have already cloned the repository (or repositories) you want to
contribute to, you can easily satisfy Nanoc's requirement by symlinking only
the directory that holds the documentation content.

1. Open a terminal and navigate to the directory where gitlab-docs was cloned.
1. For each one of the products, create the symlink:

    ```sh
    ln -s ~/dev/gitlab/gitlab-ce/doc ~/dev/gitlab/gitlab-docs/content/ce
    ln -s ~/dev/gitlab/gitlab-ee/doc ~/dev/gitlab/gitlab-docs/content/ee
    ln -s ~/dev/gitlab/omnibus-gitlab/doc ~/dev/gitlab/gitlab-docs/content/omnibus
    ln -s ~/dev/gitlab/gitlab-runner/docs ~/dev/gitlab/gitlab-docs/content/runner
    ```

1. Check if the symlinks where successfully created:

    ```sh
    ls -la content/
    ```

If they're there, we're good to go!

**Note:** You can use the `pwd` command when in the terminal to check the
directory path you are currently in and use that output to use with the symlinks
commands above.

### Install Nanoc's dependencies

Now let's make Bundler deal with the dependencies defined in the
[`Gemfile`](/Gemfile):

1. Open a terminal and navigate to the GitLab Docs repo
1. Switch to Ruby using RVM:

    ```sh
    rvm use 2.5.0
    ```

1. Run:

    ```sh
    bundle install
    ```

### Preview the Docs website

Run the following command to bring the embedded web server up:

```sh
bundle exec nanoc live
```

This will generate and the site and you will be able to view it in your browser
at <http://localhost:3000>. Any changes you make to either the website or the
content of the docs, will be reloaded automatically.

To preview the site on another port, use:

```sh
bundle exec nanoc live -p 3004
```

This will generate and the site and you will be able to view it in your browser
at <http://localhost:3004>.

#### Preview on mobile

If you want to check how your changes look on mobile devices, you can preview
the Docs site with your own devices, as long as they are connected to the same
network as your computer.

To do that, we need to change the IP address Nanoc is serving on from the
default `http://127.0.0.1` to your computer's
[private IPv4 address](https://www.howtogeek.com/236838/how-to-find-any-devices-ip-address-mac-address-and-other-network-connection-details/).

Once you know what's your computer's private IPv4, use the flag `-o`. For
example, let's say your current IPv4 address is `192.168.0.105`:

```sh
bundle exec nanoc live -o 192.168.0.105
```

Now, open your mobile's browser and type `http://192.168.0.105:3000`, and you should
be able to navigate through the docs site. This process applies to previewing the
docs site on every device connected to your network.

## Contributing to the docs website itself

If you want to just contribute to the docs website, and not the content, you
can use the following command to automatically pull the docs content in order
to have something to preview:

```sh
bundle exec rake pull_repos
```

This will pull all the docs content under the `tmp/` directory and copy it in
`content/`. You can then [preview the website](preview-the-docs-website).

If you want to force-delete the `tmp/` and `content/` folders so the task will
run without manual intervention, run:

```sh
RAKE_FORCE_DELETE=true rake pull_repos
```

## Review Apps for documentation merge requests

If you are contributing to GitLab docs read how to create a Review App with each
merge request: https://docs.gitlab.com/ee/development/writing_documentation.html#previewing-the-changes-live.

## Deployment process

We use [GitLab Pages][pages] to build and host this website. You can see
[`.gitlab-ci.yml`](/.gitlab-ci.yml) for more information.

We also use [scheduled pipelines](https://docs.gitlab.com/ee/user/project/pipelines/schedules.html)
to build the site once an hour.

[job]: https://gitlab.com/gitlab-org/gitlab-ce/blob/2c00d00ec1c39dbea0e0e54265027b5476b78e3c/.gitlab-ci.yml#L308-318
[pages]: https://pages.gitlab.io
[environments page]: https://gitlab.com/gitlab-com/gitlab-docs/environments/folders/review
[env-url-button]: https://docs.gitlab.com/ce/ci/environments.html#making-use-of-the-environment-url
[pipelines page]: https://gitlab.com/gitlab-com/gitlab-docs/pipelines
[new pipeline page]: https://gitlab.com/gitlab-com/gitlab-docs/pipelines/new
