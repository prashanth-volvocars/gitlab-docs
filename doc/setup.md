# Set up and preview the documentation site locally

You can set up and compile the docs site on your own computer, and use it to
preview changes you make to GitLab documentation.

## Requirements

To preview any changes you make to GitLab documentation, you need:

- Environment: Unix/Linux or macOS.
- Ruby, at version specified in:
  - [`.ruby-version`](https://gitlab.com/gitlab-org/gitlab-docs/-/blob/main/.ruby-version)
  - [`.tool-versions`](https://gitlab.com/gitlab-org/gitlab-docs/-/blob/main/.tool-versions)
- Node.js, at the version specified in [`.tool-versions`](https://gitlab.com/gitlab-org/gitlab-docs/-/blob/main/.tool-versions).
- Yarn, at the version specified in [`.tool-versions`](https://gitlab.com/gitlab-org/gitlab-docs/-/blob/main/.tool-versions).
- [jq](https://stedolan.github.io/jq/), needed by some [Rake tasks](raketasks.md).
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
   `.tool-versions` files. For example to set Ruby 2.7.4 as the global default, run:

   ```shell
   asdf global ruby 2.7.4
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

## Nanoc data sources

GitLab Docs uses Nanoc's [data sources](https://nanoc.app/doc/data-sources/) to import
and compile the content from the projects we source docs from. The locations of the
four projects are relative to the location of `gitlab-docs` (defined in
[`nanoc.yaml`](https://gitlab.com/gitlab-org/gitlab-docs/-/blob/8d9e30f14623c907f29f73883fefcae034092b39/nanoc.yaml#L48-75)).
Each of the four projects must be at the same root level as `gitlab-docs` and named:

- GitLab: `gitlab`
- Runner: `gitlab-runner`
- Omnibus: `omnibus-gitlab`
- Charts: `charts-gitlab`

If any of the four projects is missing or is misnamed, `nanoc live` will throw an
error, but you'll still be able to preview the site. However, live reloading
will not work, so you'll need to manually recompile Nanoc with `nanoc compile`
when you make changes.

For more information, see the [troubleshooting section](#troubleshooting).

## Clone the repositories

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
   **in the same directory** as the `gitlab-docs` project
   (see [data sources](#nanoc-data-sources)). For example, `~/dev`:

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

Run the following command from the root directory of the `gitlab-docs` project to build the documentation site and bring the embedded
web server up:

```shell
bundle exec nanoc live
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

Once you know your computer's private IPv4, use the flag `-o`. For
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

## Troubleshooting

If you see a `Nanoc::Core::Site::DuplicateIdentifierError` error, confirm you have no symlinks
in the `content` directory.

This is usually caused in local instances of GitLab Docs where symlinks were used to link
to documentation projects for content.

### `ftype: No such file or directory @ rb_file_s_ftype`

If you run into this error, it means you're probably still using symlinks
under the `content/` directory. In June 2021, we
[switched](https://gitlab.com/gitlab-org/gitlab-docs/-/merge_requests/1742)
to [Nanoc's data sources](#nanoc-data-sources) to build the site instead of
using symlinks.

Make sure no symlinks exist, and rebuild the site like you would normally do:

```shell
rm -f content/{ee,runner,omnibus,charts}
```

### `realpath: No such file or directory @ rb_check_realpath_internal`

If you run into this error, it means you're missing one of the four projects
`gitlab-docs` relies on to build the content of the docs site.

See [Nanoc data sources](#nanoc-data-sources) to learn where the four projects
should be placed and what names they should have.
