# GitLab documentation

[![build status](https://gitlab.com/gitlab-org/gitlab-docs/badges/main/pipeline.svg)](https://gitlab.com/gitlab-org/gitlab-docs/commits/main)

This project hosts the repository used to generate the GitLab documentation
website and deployed to [https://docs.gitlab.com](https://docs.gitlab.com). It
uses the [Nanoc](http://nanoc.ws) static site generator.

There is no GitLab docs content here. All documentation files are hosted in the respective
repository of [each product](#projects-we-pull-from).

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

NOTE:
Although GitLab Community Edition is generated, it is hidden from the website
as it's the same as the Enterprise Edition. We generate it for consistency,
until [better redirects](https://gitlab.com/gitlab-org/gitlab-pages/issues/24)
are implemented.

## Requirements

To preview any changes you make to GitLab documentation, you need:

- Environment: Unix/Linux or macOS.
- Ruby, at version specified in:
  - [`.ruby-version`](.ruby-version)
  - [`.tool-versions`](.tool-versions)
- Node.js, at the version specified in [`.tool-versions`](.tool-versions).
- Yarn, at the version specified in [`.tool-versions`](.tool-versions).
- Xcode *(macOS only)*:
  - Run `xcode-select --install` to install the command line tools only.
  - Or download and install the entire package using the macOS's App Store.

NOTE:
On Windows, the process described here would be different, but as most
contributors use Unix, we go over this process for macOS and Linux users.

Alternatively, you can use [Gitpod](#gitpod-integration) to access a
cloud-based, pre-configured GitLab documentation site.

## Install dependencies

There are a couple of options for installing dependencies for `gitlab-docs`:

- Using [separate dependency managers](#use-separate-dependency-managers) for Ruby, Node.js, and
  Yarn.
- The [unified dependency manager](#use-asdf) `asdf` for Ruby, Node.js, and Yarn.

The choice of which to use might depend on what you currently use. For example, you may have already
[set up a dependency manager for GDK](https://gitlab.com/gitlab-org/gitlab-development-kit/-/blob/main/doc/index.md#install-dependencies).

If you don't yet have Ruby, Node.js, and Yarn set up, use [`asdf`](https://asdf-vm.com/#/).

### Use separate dependency managers

In the instructions below, you:

- Install Ruby using `rbenv`.
- Install Node.js using `nvm`.
- Install Yarn using your preferred method in their installation instructions.

#### Ruby

To install Ruby using [`rbenv`](https://github.com/rbenv/rbenv):

1. [Install `rbenv`](https://github.com/rbenv/rbenv#installation).
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
- Bundler version with `bundle --version`.

#### Node.js

To install Node.js using [`nvm`](https://github.com/nvm-sh/nvm):

1. [Install `nvm`](https://github.com/nvm-sh/nvm#installation-and-update).
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
- Bundler version with `bundle --version`.
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

This section is about contributing to one of the GitLab
[projects' documentation](#projects-we-pull-from), and preview your changes at
the same time.

Before diving into writing, here are two handy links:

- [Writing documentation](https://docs.gitlab.com/ee/development/documentation/index.html)
- [Style guide](https://docs.gitlab.com/ee/development/documentation/styleguide/index.html)

As an alternative to the instructions below, you can
[use GDK for documentation development](https://gitlab.com/gitlab-org/gitlab-development-kit/-/blob/main/doc/howto/gitlab_docs.md).

### Clone the repositories

Since this process clones a few repositories, it might be a good idea to
create a separate directory to have them all together. For example, to store all
local checkouts in a `dev` directory:

1. Open a terminal and run:

   ```shell
   mkdir -p ~/dev
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

1. Clone the repositories you wish to contribute documentation changes to. Clone these projects
   **in the same directory** as the `gitlab-docs` project. For example, `~/dev`:

   - **GitLab contributors** that don't have Developer access to the projects,
     fork the ones you want and then clone them by using your forked version:

     ```shell
     ## Using HTTPS (for members that do not have Developer access)
     git clone https://gitlab.com/<username>/gitlab.git
     git clone https://gitlab.com/<username>/gitlab-runner.git
     git clone https://gitlab.com/<username>/omnibus-gitlab.git
     git clone https://gitlab.com/<username>/charts/gitlab.git charts-gitlab
     ```

   - For members that have Developer access (usually the
     **GitLab Team members**), clone the required repositories using SSH:

     ```shell
     ## Using SSH (for members that have Developer access)
     git clone git@gitlab.com:gitlab-org/gitlab.git
     git clone git@gitlab.com:gitlab-org/gitlab-runner.git
     git clone git@gitlab.com:gitlab-org/omnibus-gitlab.git
     git clone git@gitlab.com:gitlab-org/charts/gitlab.git charts-gitlab
     ```

If you cloned the projects into `~/dev`, you should now have the following projects:

- `~/dev/gitlab-docs`
- `~/dev/gitlab`
- `~/dev/gitlab-runner`
- `~/dev/omnibus-gitlab`
- `~/dev/charts-gitlab`

## Preview the documentation website

Run the following command to build the documentation site and bring the embedded
web server up:

```shell
bundle exec nanoc && bundle exec nanoc live
```

This generates the site and you can view it in your browser at <http://localhost:3000>.

To preview the site on another port, use:

```shell
bundle exec nanoc live -p 3004
```

This generates the site and you can view it in your browser at <http://localhost:3004>.

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

## Gitpod integration

To avoid having to build and maintain a local environment for running the GitLab
documentation site, use [Gitpod](https://www.gitpod.io) to deploy a
pre-configured documentation site for your development use.

For additional information, see the
[GDK Gitpod docs](https://gitlab.com/gitlab-org/gitlab-development-kit/-/blob/main/doc/howto/gitpod.md).

### Get started with Gitpod

To start developing with Gitpod:

1. Create a [Gitpod](https://www.gitpod.io) account and connect it to your
   GitLab account.
1. Enable the integration in your GitLab [profile preferences](https://gitlab.com/-/profile/preferences).
1. Open the GitLab documentation site in Gitpod:

   - If you're a GitLab team member, open the
     [GitLab documentation site environment](https://gitpod.io/#https://gitlab.com/gitlab-org/gitlab-docs/).

   - If you're a community contributor:

     1. Fork the [GitLab Docs repository](https://gitlab.com/gitlab-org/gitlab-docs/-/forks/new).
     1. Select **Gitpod** in the repository view of your fork. If you don't see
        **Gitpod**, open the **Web IDE** dropdown.

### Check out branches in Gitpod

To switch to another branch:

1. In the bottom blue bar, select the current branch name. GitLab displays a
   context menu with a list of branches.
1. Enter the name of the branch you want to switch to, and then select it from
   the list.
1. To create a new branch, select **Create new branch**, provide a name for the
   branch, and then press <kbd>Enter</kbd>.

### Commit and push changes in Gitpod

To commit and push changes:

1. In the left sidebar, select the **Source Control: Git** tab.
1. Review the displayed changes you want to add to the commit. To add all files,
   select the **Plus** icon next to the **Changes** section.
1. Enter a commit message in the text area.
1. Select the checkmark icon at the top of the **Source Control** section to
   commit your changes.
1. Push your changes by selecting the **Synchronize changes** action in the
   bottom blue toolbar. If Gitpod asks you how you want to synchronize your
   changes, select **Push and pull**.

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

### Add a new bundle

When adding a new bundle, the layout name (`html`) and bundle name (`js`) should
match to make it easier to find:

1. Add the new bundle to `content/frontend/<bundle-name>/<bundle-name>.js`.
1. Import the bundle in the HTML file `layouts/<bundle-name>.html`:

   ```html
   <script src="<%= @items['/frontend/<bundle-name>/<bundle-name>.*'].path %>"></script>
   ```

You should replace `<bundle-name>` with whatever you'd like to call your
bundle.

## Bumping versions of CSS and JavaScript

Whenever the custom CSS and JavaScript files under `content/assets/` change,
make sure to bump their version in the front matter. This method guarantees that
your changes take effect by clearing the cache of previous files.

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

Nanoc then builds and renders those links correctly according with what's
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

By default, we pull from the default branch of [all the projects](#projects-we-pull-from).

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

## Survey banner

In case there's a survey that needs to reach a big audience, the docs site has
the ability to host a banner for that purpose. When it is enabled, it's shown
at the top of every page of the docs site.

To publish a survey:

1. Edit [`layouts/banner.html`](/layouts/banner.html) and fill in the required
   information like the description text and the survey link.
1. Edit [`nanoc.yaml`](nanoc.yaml) and set `show_banner` to `true`.

To unpublish a survey:

1. Edit [`nanoc.yaml`](nanoc.yaml) and set `show_banner` to `false`.
1. Edit [`layouts/banner.html`](/layouts/banner.html) remove the survey link.
   This step is optional, but it's good to have the link removed so that it's
   not exposed when no new survey answers are needed.

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

### Add or update domains in the CSP header

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

### Test the CSP header for conformity

To test that the CSP header works as expected, you can visit
<https://cspvalidator.org/> and paste the URL that you want tested.

## Generate the feature flag tables

The [feature flag tables](https://docs.gitlab.com/ee/user/feature_flags.html) are generated
dynamically when GitLab Docs are published.

To generate these tables locally, generate `content/_data/feature_flags.yaml`:

```shell
bundle exec rake generate_feature_flags
```

Do this any time you want fresh data from your GitLab checkout.

Any time you rebuild the site using `nanoc`, the feature flags tables are populated with data.

## Troubleshooting

If you see a `Nanoc::Core::Site::DuplicateIdentifierError` error, confirm you have no symlinks
in the `content` directory.

This is usually caused in local instances of GitLab Docs where symlinks were used to link
to documentation projects for content.
