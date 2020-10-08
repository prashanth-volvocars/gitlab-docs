# GitLab documentation

[![build status](https://gitlab.com/gitlab-org/gitlab-docs/badges/master/pipeline.svg)](https://gitlab.com/gitlab-org/gitlab-docs/commits/master)

This project hosts the repository used to generate the GitLab documentation
website and deployed to [https://docs.gitlab.com](https://docs.gitlab.com). It
uses the [Nanoc](http://nanoc.ws) static site generator.

You will not find any GitLab docs content here. All documentation files are
hosted in the respective repository of [each product](#projects-we-pull-from).

The [deployment process](#deployment-process) happens automatically every four hours.

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

- Environment: Unix/Linux or macOS.
- Ruby, at version specified in:
  - [`.ruby-version`](.ruby-version)
  - [`.tool-versions`](.tool-versions)
- Node.js, at the version specified in [`.tool-versions`](.tool-versions).
- Yarn, at the version specified in [`.tool-versions`](.tool-versions).
- Xcode *(macOS only)*:
  - Run `xcode-select --install` to install the command line tools only.
  - Or download and install the entire package using the macOS's App Store.

**Note:**
On Windows, the process described here would be different, but as most of
contributors use Unix, we'll go over this process for macOS and Linux users.

## Install dependencies

There are a couple of options for installing dependencies for `gitlab-docs`:

- Using [separate dependency managers](#use-separate-dependency-managers) for Ruby, Node.js, and
  Yarn.
- The [unified dependency manager](#use-asdf) `asdf` for Ruby, Node.js, and Yarn.

The choice of which to use will depend on what you currently use. If you don't yet have Ruby,
Node.js, and Yarn set up, use [`asdf`](https://asdf-vm.com/#/).

### Use separate dependency managers

In the instructions below, you:

- Install Ruby using `rbenv`.
- Install Node.js using `nvm`.
- Install Yarn using your preferred method in their installation instructions.

#### Ruby

To install Ruby using [rbenv](https://github.com/rbenv/rbenv):

1. [Install rbenv](https://github.com/rbenv/rbenv#installation).
1. Install the supported version of Ruby:

   ```shell
   rbenv install <supported-version>
   ```

1. Use the newly installed Ruby:

   ```shell
   rbenv global <supported-version>
   ```

Check your:

- Ruby version with `ruby --version`.
- Bundler version with `bundle --version`. You need version 1.17.3.

#### Node.js

To install Node.js using [nvm](https://github.com/nvm-sh/nvm):

1. [Install nvm](https://github.com/nvm-sh/nvm#installation-and-update).
1. Install the latest Node.js:

   ```shell
   nvm install --lts
   ```

1. Use the newly installed Node.js:

   ```shell
   nvm use --lts --default
   ```

Check your Node.js version with `node -v`.

#### Yarn

Install [yarn](https://yarnpkg.com/en/docs/install), a package manager for the
Node.js ecosystem.

Check your Yarn version with `yarn -v`.

### Use `asdf`

To install Ruby, Node.js, and Yarn using `asdf`:

1. [Install `asdf`](https://asdf-vm.com/#/core-manage-asdf-vm?id=install).
1. Add the Ruby, Node.js, and Yarn [`asdf` plugins](https://asdf-vm.com/#/core-manage-plugins)
   required to install versions of these dependencies:

   ```shell
   asdf plugin add ruby
   asdf plugin add nodejs
   asdf plugin add yarn
   ```

1. [Install](https://asdf-vm.com/#/core-manage-versions) the dependencies listed in the project's
   `.tool-versions` file:

   ```shell
   asdf install
   ```

1. Set the installed versions of Ruby, Node.js, and Yarn to be global for projects that don't use
   `.tool-versions` files. For example to set Ruby 2.7.2 as the global default, run:

   ```shell
   asdf global ruby 2.7.2
   ```

Check your:

- Ruby version with `ruby --version`.
- Bundler version with `bundle --version`. You need version 1.17.3.
- Node.js version with `node -v`.
- Yarn version with `yarn -v`

## Install Nanoc's dependencies

The project depends on many Ruby and Node.js libraries. To install these:

1. Open a terminal and navigate to your local checkout of this project.
1. Run:

   ```shell
   bundle install && yarn install --frozen-lockfile
   ```

## Development when contributing to GitLab documentation

This section is about contributing to one of GitLab's
[projects' documentation](#projects-we-pull-from), and preview your changes at
the same time. To contribute to the appearance of the documentation site, see
[contributing to the docs site](#contributing-to-the-docs-website-itself).

Before diving into writing, here's a few links that will come in handy:

- [Writing documentation](https://docs.gitlab.com/ee/development/documentation/index.html)
- [Style guide](https://docs.gitlab.com/ee/development/documentation/styleguide.html)

### Clone the repositories

Since this process will clone a few repositories, it might be a good idea to
create a separate directory to have them all together. For example, to store all
local checkouts in a `dev` directory:

1. Open a terminal and run:

   ```shell
   mkdir -p ~/dev/
   ```

1. Navigate to the directory you'd like the repositories to be cloned:

   ```shell
   cd ~/dev
   ```

1. Clone the documentation's website repository:

   ```shell
   ## Using SSH (for GitLab Team members)
   git clone git@gitlab.com:gitlab-org/gitlab-docs.git

   ## Using HTTPS (for external contributors)
   git clone https://gitlab.com/gitlab-org/gitlab-docs.git
   ```

1. Clone the repositories you wish to contribute documentation changes to. For:
   - **GitLab contributors** that don't have Developer access to the projects,
     fork the ones you want and then clone them by using your forked version:

     ```shell
     ## Using HTTPS (for members that do not have Developer access)
     git clone https://gitlab.com/<username>/gitlab.git
     git clone https://gitlab.com/<username>/gitlab-runner.git
     git clone https://gitlab.com/<username>/omnibus-gitlab.git
     git clone https://gitlab.com/<username>/gitlab.git charts
     ```

   - For members that have Developer access (usually the
     **GitLab Team members**), clone the required repos using SSH:

     ```shell
     ## Using SSH (for members that have Developer access)
     git clone git@gitlab.com:gitlab-org/gitlab.git
     git clone git@gitlab.com:gitlab-org/gitlab-runner.git
     git clone git@gitlab.com:gitlab-org/omnibus-gitlab.git
     git clone git@gitlab.com:gitlab-org/charts/gitlab.git charts
     ```

### Create the content symlinks

Nanoc expects the Markdown files to be under `content/<slug>`, where `<slug>`
is the slug of each product as defined in [`.nanoc.yaml`](nanoc.yaml).

If you have already cloned the repository (or repositories) you want to
contribute to, you can easily satisfy Nanoc's requirement by symlinking only
the directory that holds the documentation content.

1. Open a terminal and navigate to the directory where `gitlab-docs` was cloned.
1. For each one of the products, create the symlink:

   ```shell
   ln -s ~/dev/gitlab/doc ~/dev/gitlab-docs/content/ee
   ln -s ~/dev/omnibus-gitlab/doc ~/dev/gitlab-docs/content/omnibus
   ln -s ~/dev/gitlab-runner/docs ~/dev/gitlab-docs/content/runner
   ln -s ~/dev/charts/doc ~/dev/gitlab-docs/content/charts
   ```

1. Check if the symlinks were successfully created:

   ```shell
   cd dev/gitlab-docs
   ls -la content/
   ```

If they're there, we're almost good to go!

**Note:** You can use the `pwd` command when in the terminal to check the
directory path you are currently in and use that output to use with the symlinks
commands above.

## Preview the documentation website

Run the following command to build the documentation site and bring the embedded
web server up:

```shell
bundle exec nanoc && bundle exec nanoc live
```

This will generate and the site and you will be able to view it in your browser
at <http://localhost:3000>.

To preview the site on another port, use:

```shell
bundle exec nanoc live -p 3004
```

This will generate and the site and you will be able to view it in your browser
at <http://localhost:3004>.

### Recompile documentation changes

Due to a [bug on **macOS**](https://gitlab.com/gitlab-org/gitlab-docs/-/issues/81),
every time you change a file in the documentation (in one
of the repos: GitLab, Omnibus, Runner, or Charts), you'll need to recompile the site
to preview your changes:

```shell
bundle exec nanoc && bundle exec nanoc live
```

It recompiles incrementally, only updating the recently changed files.

### Preview on mobile

If you want to check how your changes look on mobile devices, you can use:

- [Responsive Design Mode](https://support.apple.com/en-au/guide/safari-developer/dev84bd42758/mac)
  on Safari.
- [Responsive Design Mode](https://developer.mozilla.org/en-US/docs/Tools/Responsive_Design_Mode)
  on Firefox.
- [Device Mode](https://developers.google.com/web/tools/chrome-devtools/device-mode)
  on Chrome.

An alternative is to preview the documentation site with your own devices, as
long as they are connected to the same network as your computer.

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

Alternatively, you can preview changes using the GitLab Development Kit (GDK).
For more information, see [Setting up GitLab Docs](https://gitlab.com/gitlab-org/gitlab-development-kit/blob/master/doc/howto/gitlab_docs.md)
in the GDK repository.

## Contributing to the docs website itself

If you want to just contribute to the docs website, and not the content, you
can use the following command to automatically pull the documentation content
to have something to preview:

```shell
bundle exec rake pull_repos
```

This will download all the documentation content under the `tmp/` directory and
copy it in `content/`. You can then [preview the website](#preview-the-docs-website).

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

A lot of the JavaScript can be found in [content/assets/javascripts/](/content/assets/javascripts).
The files in this directory are handcrafted `ES5` JavaScript files.

We've [recently introduced](https://gitlab.com/gitlab-org/gitlab-docs/merge_requests/577)
the ability to write modern JavaScript. All modern JavaScript should be added to
the [content/frontend/](/content/frontend) directory.

### Adding a new bundle

When adding a new bundle, the layout name (`html`) and bundle name (`js`) should
match to make it easier to find:

1. Add the new bundle to `content/frontend/<bundle-name>/<bundle-name>.js`.
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

- Default editor:
  `<a href="<%= edit_on_gitlab(@item, editor: :simple) %>">Simple editor</a>`
- Web IDE: `<a href="<%= edit_on_gitlab(@item, editor: :webide) %>">Web IDE</a>`

If you don't specify `editor:`, the simple one is used by default.

## Review Apps for documentation merge requests

If you are contributing to GitLab docs read how to [create a Review App with each
merge request](https://docs.gitlab.com/ee/development/documentation/index.html#previewing-the-changes-live).

## Deployment process

We use [GitLab Pages](https://about.gitlab.com/features/pages/) to build and
host this website. See [`.gitlab-ci.yml`](.gitlab-ci.yml) for more information.

We also use [scheduled pipelines](https://docs.gitlab.com/ee/user/project/pipelines/schedules.html)
to build the site once every four hours.

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
   is present on pretty much every page except <https://docs.gitlab.com/search/>,
   which uses its [own layout](/layouts/instantsearch.html). In those layouts,
   there's a Javascript snippet which initiates docsearch by using an API key
   and an index name (`gitlab`) that are needed for Algolia to show the results.

**For GitLab employees:**
The credentials to access the Algolia dashboard are stored in 1Password. If you
want to receive weekly reports of the search usage, search the Google doc with
title "Email, Slack, and GitLab Groups and Aliases", search for `docsearch`,
and add a comment with your email to be added to the alias that gets the weekly
reports.

## CSP header

The GitLab docs site uses a [Content Security Policy (CSP) header](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)
as an added layer of security that helps to detect and mitigate certain types of
attacks, including Cross Site Scripting (XSS) and data injection attacks.
Although it is a static site, and the potential for injection of scripts is very
low, there are customer concerns around not having this header applied.

It's enabled by default on <https://docs.gitlab.com>, but if you want to build the
site on your own and disable the inclusion of the CSP header, you can do so with
the `DISABLE_CSP` environment variable:

```shell
DISABLE_CSP=1 bundle exec nanoc compile
```

### Adding or updating domains in the CSP header

The CSP header and the allowed domains can be found in the [`csp.html`](/layouts/csp.html)
layout. Every time a new font or Javascript file is added, or maybe updated in
case of a versioned file, you need to update the `csp.html` layout, otherwise
it can cause the site to misbehave and be broken.

### No inline scripts allowed

To avoid allowing `'unsafe-line'` in the CSP, we cannot use any inline scripts.
For example, this is prohibited:

```html
<script>
$(function () {
  $('[data-toggle="popover"]').popover();
  $('.popover-dismiss').popover({
    trigger: 'focus'
  })
})
</script>
```

Instead, this should be extracted to its own files in the
[`/content/assets/javascripts/`](/content/assets/javascripts/) directory,
and then be included in the HTML file that you want. The example above lives
under `/content/assets/javascripts/toggle_popover.js`, and you would call
it with:

```html
<script src="<%= @items['/assets/javascripts/toggle_popover.*'].path %>"></script>
```

### Testing the CSP header for conformity

To test that the CSP header works as expected, you can visit
<https://cspvalidator.org/> and paste the URL that you want tested.
