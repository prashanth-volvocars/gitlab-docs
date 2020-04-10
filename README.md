# GitLab Documentation

[![build status](https://gitlab.com/gitlab-org/gitlab-docs/badges/master/pipeline.svg)](https://gitlab.com/gitlab-org/gitlab-docs/commits/master)

This project hosts the repository used to generate the GitLab
documentation website and deployed to https://docs.gitlab.com. It uses the
[Nanoc](http://nanoc.ws) static site generator.

You will not find any GitLab docs content here. All documentation files are
hosted in the respective repository of [each product](#projects-we-pull-from).

The [deployment process](#deployment-process) happens automatically every hour.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Contributing agreement](#contributing-agreement)
- [License](#license)
- [Projects we pull from](#projects-we-pull-from)
- [Requirements](#requirements)
    - [Ruby](#ruby)
- [Install Nanoc's dependencies](#install-nanocs-dependencies)
- [Development under GDK](#development-under-gdk)
- [Development when contributing to GitLab documentation](#development-when-contributing-to-gitlab-documentation)
    - [Clone the repositories](#clone-the-repositories)
    - [Create the content symlinks](#create-the-content-symlinks)
- [Preview the Docs website](#preview-the-docs-website)
    - [Preview on mobile](#preview-on-mobile)
- [Contributing to the docs website itself](#contributing-to-the-docs-website-itself)
- [Using YAML data files](#using-yaml-data-files)
- [Review Apps for documentation merge requests](#review-apps-for-documentation-merge-requests)
- [Deployment process](#deployment-process)
- [Algolia search](#algolia-search)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Contributing agreement

Read [CONTRIBUTING.md](CONTRIBUTING.md) for an overview of the Developer
Certificate of Origin + License.

## License

See [LICENSE](LICENSE).

## Projects we pull from

There are currently 4 products that are pulled and generate the docs website:

- [GitLab](https://gitlab.com/gitlab-org/gitlab)
- [Omnibus GitLab](https://gitlab.com/gitlab-org/omnibus-gitlab)
- [GitLab Runner](https://gitlab.com/gitlab-org/gitlab-runner)
- [GitLab Chart](https://gitlab.com/gitlab-org/charts/gitlab)

**Note:**
Although GitLab Community Edition is generated, it is hidden from the website
as it's the same as the Enterprise Edition. We generate it for consistency,
until [better redirects](https://gitlab.com/gitlab-org/gitlab-pages/issues/24)
are implemented.

## Requirements

In order to be able to preview any changes you make to GitLab's documentation,
here's what you will need to have:

- Environment: Unix/Linux or macOS
- Ruby 2.6 or greater
- Node
- Yarn
- Xcode _(macOS only)_: Download and install using the App Store

**Note:**
On Windows, the process described here would be different, but as most of
contributors use Unix, we'll go over this process for macOS and Linux users.

### Ruby

The recommended way is to use a Ruby version manager to install Ruby in your
system.

One way is to use RVM:

1. [Install RVM](https://rvm.io/rvm/install)
1. Install the latest Ruby:

   ```shell
   rvm install 2.6.5
   ```

1. Use the newly installed Ruby:

   ```shell
   rvm use 2.6.5
   ```

Check your Ruby version with `ruby --version`.
Also check the bundled Bundler version with `bundle --version`. You will see `Bundler version 1.17.3`.

### Node

The recommended way is to use a Node version manager to install Node in your
system.

One way is to use NVM:

1. [Install NVM](https://github.com/nvm-sh/nvm#installation-and-update)
1. Install the latest Node:

   ```shell
   nvm install node
   ```

1. Use the newly installed Node:

   ```shell
   nvm use node
   ```

Check your Node version with `node -v`.

### Yarn

Install [yarn](https://yarnpkg.com/en/docs/install), a package manager for the Node ecosystem.

Check your Yarn version with `yarn -v`.

## Install Nanoc's dependencies

Now let's make Bundler deal with the dependencies defined in the
[`Gemfile`](/Gemfile):

1. Open a terminal and navigate to the GitLab Docs repo
1. Switch to Ruby using RVM:

   ```shell
   rvm use 2.6.5
   ```

1. Run:

   ```shell
   bundle install
   ```

## Development when contributing to GitLab documentation

This section is about contributing to one of GitLab's
[projects' documentation](#projects-we-pull-from), and preview your changes at
the same time. To contribute how the docs website looks like, see
[contributing to the docs site](#contributing-to-the-docs-website-itself).

Before diving into writing, here's a few links that will come in handy:

- [Writing documentation](https://docs.gitlab.com/ee/development/documentation/index.html)
- [Style guide](https://docs.gitlab.com/ee/development/documentation/styleguide.html)
- [Community writers](https://about.gitlab.com/community-writers/)

### Clone the repositories

Since this process will clone a few repositories, it might be a good idea to
create a separate directory to have them all together. For example, let's say
the directory will be under your user's home directory. Open a terminal and
execute:

```shell
mkdir -p ~/dev/gitlab
```

Once you do that, navigate to the directory you'd like the repos to be cloned:

```shell
cd ~/dev/gitlab/
```

Then, it's time to clone the needed repositories.

1. First of all, clone the docs website repository:

   ```shell
   ## Using SSH (for members that have Developer access)
   git clone git@gitlab.com:gitlab-org/gitlab-docs.git

   ## Using HTTPS (for external contributors)
   git clone https://gitlab.com/gitlab-org/gitlab-docs.git
   ```

1. Then, clone the repositories you wish to contribute changes to the documentation.
   For **GitLab contributors**, that do not have Developer access to the projects,
   fork the ones you want (see [projects we pull from](#projects-we-pull-from))
   and then clone them by using your forked version (replace `<username>` with
   your own username):

   ```shell
   ## Using HTTPS (for members that do not have Developer access)

   git clone https://gitlab.com/<username>/gitlab.git
   git clone https://gitlab.com/<username>/gitlab-runner.git
   git clone https://gitlab.com/<username>/omnibus-gitlab.git
   git clone https://gitlab.com/<username>/gitlab.git charts
   ```

   For members that have Developer access (usually the **GitLab Team members**),
   clone the required repos using SSH:

   ```shell
   ## Using SSH (for members that have Developer access)

   git clone git@gitlab.com:gitlab-org/gitlab.git
   git clone git@gitlab.com:gitlab-org/gitlab-runner.git
   git clone git@gitlab.com:gitlab-org/omnibus-gitlab.git
   git clone git@gitlab.com:gitlab-org/charts/gitlab.git charts
   ```

### Create the content symlinks

Nanoc expects the Markdown files to be under `content/<slug>`, where `<slug>`
is the slug of each product as defined in [`.nanoc.yaml`](/nanoc.yaml).

If you have already cloned the repository (or repositories) you want to
contribute to, you can easily satisfy Nanoc's requirement by symlinking only
the directory that holds the documentation content.

1. Open a terminal and navigate to the directory where gitlab-docs was cloned.
1. For each one of the products, create the symlink:

   ```shell
   ln -s ~/dev/gitlab/gitlab/doc ~/dev/gitlab/gitlab-docs/content/ee
   ln -s ~/dev/gitlab/omnibus-gitlab/doc ~/dev/gitlab/gitlab-docs/content/omnibus
   ln -s ~/dev/gitlab/gitlab-runner/docs ~/dev/gitlab/gitlab-docs/content/runner
   ln -s ~/dev/gitlab/charts/doc ~/dev/gitlab/gitlab-docs/content/charts
   ```

1. Check if the symlinks were successfully created:

   ```shell
   cd dev/gitlab/gitlab-docs
   ls -la content/
   ```

If they're there, we're almost good to go!

**Note:** You can use the `pwd` command when in the terminal to check the
directory path you are currently in and use that output to use with the symlinks
commands above.

### Install node dependencies

1. Install node dependences in the `gitlab-docs/node_modules` folder:

   ```shell
   yarn install
   ```

## Preview the Docs website

Run the following command to bring the embedded web server up:

```shell
bundle exec nanoc live
```

This will generate and the site and you will be able to view it in your browser
at <http://localhost:3000>. Any changes you make to either the website or the
content of the docs, will be reloaded automatically.

To preview the site on another port, use:

```shell
bundle exec nanoc live -p 3004
```

This will generate and the site and you will be able to view it in your browser
at <http://localhost:3004>.

### Preview on mobile

If you want to check how your changes look on mobile devices, you can preview
the Docs site with your own devices, as long as they are connected to the same
network as your computer.

To do that, we need to change the IP address Nanoc is serving on from the
default `http://127.0.0.1` to your computer's
[private IPv4 address](https://www.howtogeek.com/236838/how-to-find-any-devices-ip-address-mac-address-and-other-network-connection-details/).

Once you know what's your computer's private IPv4, use the flag `-o`. For
example, let's say your current IPv4 address is `192.168.0.105`:

```shell
bundle exec nanoc live -o 192.168.0.105
```

Now, open your mobile's browser and type `http://192.168.0.105:3000`, and you should
be able to navigate through the docs site. This process applies to previewing the
docs site on every device connected to your network.

### Preview on the GitLab Development Kit

Alternatively, you can preview changes using the GitLab Development Kit (GDK). For more information, see [Setting up GitLab Docs](https://gitlab.com/gitlab-org/gitlab-development-kit/blob/master/doc/howto/gitlab_docs.md) in the GDK repository.

## Contributing to the docs website itself

If you want to just contribute to the docs website, and not the content, you
can use the following command to automatically pull the docs content in order
to have something to preview:

```shell
bundle exec rake pull_repos
```

This will download all the docs content under the `tmp/` directory and copy it
in `content/`. You can then [preview the website](#preview-the-docs-website).

If you want to force-delete the `tmp/` and `content/` folders so the task will
run without manual intervention, run:

```shell
RAKE_FORCE_DELETE=true rake pull_repos
```

## Using YAML data files

The easiest way to achieve something similar to
[Jekyll's data files](https://jekyllrb.com/docs/datafiles/) in Nanoc is by
using the [`@items`](https://nanoc.ws/doc/reference/variables/#items-and-layouts)
variable.

The data file must be placed inside the `content/` directory and then it can
be referenced in an ERB template.

Suppose we have the `content/_data/versions.yaml` file with the content:

```yaml
versions:
- 10.6
- 10.5
- 10.4
```

We can then loop over the `versions` array with something like:

```erb
<% @items['/_data/versions.yaml'][:versions].each do | version | %>

<h3><%= version %></h3>

<% end &>
```

Note that the data file must have the `yaml` extension (not `yml`) and that
we reference the array with a symbol (`:versions`).

## Modern JavaScript

Currently a lot of the JavaScript can be found in [content/assets/javascripts/](/content/assets/javascripts). The files in
 this directory are handcrafted `ES5` JavaScript files.

We've [recently introduced](https://gitlab.com/gitlab-org/gitlab-docs/merge_requests/577) the ability to write modern
JavaScript. All modern JavaScript should be added to the [content/frontend/](/content/frontend) directory.

### Adding a new bundle

When adding a new bundle, the layout name (html) and bundle name (js) should
match to make it easier to find:

1. Add the new bundle to `content/frontend/<bundle-name>/<bundle-name>.js`
1. Import the bundle in the html file `layouts/<bundle-name>.html`:

   ```html
   <script src="<%= @items['/frontend/<bundle-name>/<bundle-name>.*'].path %>"></script>
   ```

You should replace `<bundle-name>` with whatever you'd like to call your
bundle.

## Bumping versions of CSS and JavaScript

Whenever the custom CSS and JavaScript files under `content/assets/` change,
make sure to bump their version in the frontmatter. This method guarantees that
your changes will take effect by clearing the cache of previous files.

Always use Nanoc's way of including those files, do not hardcode them in the
layouts. For example use:

```erb
<script async type="application/javascript" src="<%= @items['/assets/javascripts/badges.*'].path %>"></script>

<link rel="stylesheet" href="<%= @items['/assets/stylesheets/toc.*'].path %>">
```

The links pointing to the files should be similar to:

```erb
<%= @items['/path/to/assets/file.*'].path %>
```

Nanoc will then build and render those links correctly according with what's
defined in [`Rules`](/Rules).

## Linking to source files

A helper called [`edit_on_gitlab`](/lib/helpers/edit_on_gitlab.rb) can be used
to link to a page's source file. We can link to both the simple editor and the
web IDE. Here's how you can use it in a Nanoc layout:

- Default editor: `<a href="<%= edit_on_gitlab(@item, editor: :simple) %>">Simple editor</a>`
- Web IDE: `<a href="<%= edit_on_gitlab(@item, editor: :webide) %>">Web IDE</a>`

If you don't specify `editor:`, the simple one is used by default.

## Review Apps for documentation merge requests

If you are contributing to GitLab docs read how to [create a Review App with each
merge request](https://docs.gitlab.com/ee/development/documentation/index.html#previewing-the-changes-live).

## Deployment process

We use [GitLab Pages][pages] to build and host this website, see
[`.gitlab-ci.yml`](/.gitlab-ci.yml) for more information.

We also use [scheduled pipelines](https://docs.gitlab.com/ee/user/project/pipelines/schedules.html)
to build the site once an hour.

By default, we pull from the master branch of [all the projects](#projects-we-pull-from).

## Algolia search

The docs site uses [Algolia docsearch](https://community.algolia.com/docsearch/)
for its search function. This is how it works:

1. GitLab is a member of the [docsearch program](https://community.algolia.com/docsearch/#join-docsearch-program),
   which is the free tier of [Algolia](https://www.algolia.com/).
1. Algolia hosts a [doscsearch config](https://github.com/algolia/docsearch-configs/blob/master/configs/gitlab.json)
   for the GitLab docs site, and we've worked together to refine it.
1. That [config](https://community.algolia.com/docsearch/config-file.html) is
   parsed by their [crawler](https://community.algolia.com/docsearch/crawler-overview.html)
   every 24h and [stores](https://community.algolia.com/docsearch/inside-the-engine.html)
   the [docsearch index](https://community.algolia.com/docsearch/how-do-we-build-an-index.html)
   on [Algolia's servers](https://community.algolia.com/docsearch/faq.html#where-is-my-data-hosted%3F).
1. On the docs side, we use a [docsearch layout](/layouts/docsearch.html) which
   is present on pretty much every page except https://docs.gitlab.com/search/,
   which uses its [own layout](/layouts/instantsearch.html). In those layouts,
   there's a Javascript snippet which initiates docsearch by using an API key
   and an index name (`gitlab`) that are needed for Algolia to show the results.

**For GitLab employees:**
The credentials to access the Algolia dashboard are stored in 1Password. If you
want to receive weekly reports of the search usage, search the Google doc with
title "Email, Slack, and GitLab Groups and Aliases", search for `docsearch`,
and add a comment with your email to be added to the alias that gets the weekly
reports.

[pages]: https://about.gitlab.com/features/pages/
[environments page]: https://gitlab.com/gitlab-org/gitlab-docs/environments/folders/review
[env-url-button]: https://docs.gitlab.com/ce/ci/environments.html#making-use-of-the-environment-url
[pipelines page]: https://gitlab.com/gitlab-org/gitlab-docs/pipelines
[new pipeline page]: https://gitlab.com/gitlab-org/gitlab-docs/pipelines/new
