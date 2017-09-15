[![build status](https://gitlab.com/gitlab-com/gitlab-docs/badges/master/build.svg)](https://gitlab.com/gitlab-com/gitlab-docs/commits/master)

# GitLab Documentation

- The [GitLab Documentation](https://docs.gitlab.com) website is generated using [Nanoc](http://nanoc.ws).
- [Writing Documentation](https://docs.gitlab.com/ce/development/writing_documentation.html)
- [Style Guide](https://docs.gitlab.com/ce/development/doc_styleguide.html)
- [Community Writers](https://about.gitlab.com/handbook/product/technical-writing/community-writers/)

## Contributing

Read more in [CONTRIBUTING.md](CONTRIBUTING.md).

## Development

### Requirements

To preview `docs.gitlab.com` locally, you'll need:

- Unix
- Ruby 2.4.0
- Bundler
- Repositories
  - GitLab CE
  - GitLab EE
  - GitLab Multi Runner
  - GitLab Omnibus
  - GitLab Docs

> Note: On Windows, the process described here would be different, but as most of contributors use Unix, we'll go over this process for MacOs and Linux users only.

### Installing dependencies

#### Ruby 2.4.0

If you don't have Ruby installed in your computer, [install Ruby 2.4.0](https://www.ruby-lang.org/en/documentation/installation/) directly.

If you already have other Ruby versions installed, you can use a Ruby version manager to install Ruby 2.4.0 in your system.

Check your Ruby version with `ruby --version`.

To install multiple Ruby versions on MacOS or Linux, we recommend you use RMV:

- Install [RVM](https://rvm.io/rvm/install)
- Install Ruby 2.4.0 with `rvm install 2.4.0`

#### Bundler

[Bundler](https://bundler.io/) is an incredible dependency manager. Install it by running `gem install bundler`.

#### Repositories

**GitLab Team members:** clone the required repos to your machine. Navigate to the directory you'd like to have them, then clone with SSH:

- GitLab CE: `git clone git@gitlab.com:gitlab-org/gitlab-ce.git`
- GitLab EE: `git clone git@gitlab.com:gitlab-org/gitlab-ee.git`
- GitLab Runner: `git clone git@gitlab.com:gitlab-org/gitlab-runner.git`
- GitLab Omnibus: `git clone git@gitlab.com:gitlab-org/omnibus-gitlab.git`
- GitLab Docs: `git clone git@gitlab.com:gitlab-com/gitlab-docs.git`

**GitLab Contributors:** fork each of these projects and clone them to your local computer:

- GitLab CE: https://gitlab.com/gitlab-org/gitlab-ce/
- GitLab EE: https://gitlab.com/gitlab-org/gitlab-ee/
- GitLab Runner: https://gitlab.com/gitlab-org/gitlab-runner
- GitLab Omnibus: https://gitlab.com/gitlab-org/omnibus-gitlab
- GitLab Docs: https://gitlab.com/gitlab-com/gitlab-docs

### Bring Everything Together

Now that we have everything required, we need to add symlinks, so GitLab Docs can talk to the remaining repos.

#### Symlinks

- In a terminal window, navigate to your local path to where you just cloned GitLab Docs
- Output the path by running `pwd`:

    ```
    $ pwd
    /Users/username/dir/gitlab-docs
    ```

- In a terminal window, navigate to your local path to where you just cloned GitLab CE
- Output the path by running `pwd`:

    ```
    $ pwd
    /Users/username/dir/gitlab-ce
    ```

- Copy the output and create a symlink between GitLab Docs (`content/`) and GitLab CE (`/doc/`), by running `ln -s /Users/username/dir/gitlab-ce/doc /Users/username/dir/gitlab-docs/content/ce`. Of course, adjust the paths according to the output of `pwd`.

- Repeat the process to the other three repos:
  - GitLab EE: `ln -s /Users/username/dir/gitlab-ee/doc /Users/username/dir/gitlab-docs/content/ee`
  - Runner: `ln -s /Users/username/dir/gitlab-runner/docs /Users/username/dir/gitlab-docs/content/runner`
  - Omnibus: `ln -s /Users/username/dir/omnibus-gitlab/doc /Users/username/dir/gitlab-docs/content/omnibus`
- Open GitLab Docs in a terminal window and check if you have all the foour there (`ee`, `ce`, `runner`, `omnibus`): `ls content`

If they're there, we're good to go!

### Install Docs dependencies

Now let's make Bundler deal with the dependencies defined in the `Gemfile`:

- Open GitLab Docs in a terminal window
- Switch to Ruby 2.4.0: `rmv 2.4.0`
- Run `bundle install`

### Preview the Docs Website

- `bundle exec nanoc live`

This will host the site at `localhost:3000`. Changes will be reloaded automatically using [Guard Nanoc](https://github.com/guard/guard-nanoc).

### Extra Step

To pull down the documentation content, run `rake pull_repos`. If you want to force-delete the `tmp/` and `content/` folders so the task will run without manual intervention, run `RAKE_FORCE_DELETE=true rake pull_repos`.

## Projects we pull from

We pull from the following projects:

- [GitLab Community Edition](https://gitlab.com/gitlab-org/gitlab-ce)
- [GitLab Enterprise Edition](https://gitlab.com/gitlab-org/gitlab-ee)
- [Omnibus GitLab](https://gitlab.com/gitlab-org/omnibus-gitlab)
- [GitLab Runner](https://gitlab.com/gitlab-org/gitlab-runner)

## Examples and Resources

### Open Source Nanoc Sites

**NOTE**: We use Nanoc 4.0 which has some significant differences from 3.0, be aware that not all example sites use 4.0.

- [Nanoc's Website](https://github.com/nanoc/nanoc.ws)
- [GitHub Developer Site](https://github.com/github-archive/developer.github.com)
- [Spree Guides](https://github.com/spree/spree/tree/master/guides)
- [Atom Flight Manual](https://github.com/atom/flight-manual.atom.io)
- [Prometheus Docs](https://github.com/prometheus/docs)

### Good Documentation

- [SendGrid](https://sendgrid.com/docs)
- [Stripe](https://stripe.com/docs)
- [Stripe API](https://stripe.com/docs/api)
- [CircleCI](https://circleci.com/docs)
- [Heroku](https://devcenter.heroku.com/)
- [Slack](https://get.slack.help/hc/en-us)
- [Slack API](https://api.slack.com/)
- [Kong](https://getkong.org/docs/)

## Requirements/Goals

- [x] Feature parity with the existing [docs.gitlab.com](https://docs.gitlab.com/)
- [x] Use GitLab CI / GitLab Pages for compilation, deployment, and hosting of the Documentation site.
- [x] Sections for Community Edition, Enterprise Edition, GitLab CI, and Omnibus.
- [x] Pull documentation from the repositories mentioned above.
- [ ] Versioned documentation (e.g. switch between documentation for 9.0, 9.1, 9.2, 9.3, "latest", etc.)
- [x] Search the documentation (Can either re-use existing Documentation search functionality or implement search using Algolia or something else? Ideally simple and open source, but it doesn't really matter too much.)
- [x] Link to "Edit on GitLab.com" for every page to encourage contribution.
- [x] Responsive design.

### Nice-to-haves

- [ ] Some way to embed/package the site inside the Rails app so the documentation can be included with the application itself. This would be nice for users behind firewalls, etc. This _should not_ be handled by Rails itself, as that causes all kinds of problems. It should just be a set of static pages.
- [ ] Some way to export the documentation as PDF/ePub for use offline.
- [ ] Future-proofing for internationalization.
- [x] Tests for working internal links and such. (Nanoc includes this by default!)
- [x] A blog post explaining how we do all this using GitLab, GitLab CI, and GitLab Pages, as well as (almost all?) open source tools.
- [x] Breadcrumbs for navigating between pages.
- [x] Auto-generated Table of Contents for every page.
- [x] Anchor links for every page section.
- [x] Syntax highlighting with Rouge.
- [ ] Auto-generated documentation structure based on YML frontmatter.
- [ ] Version dropdown that links to the current page for that version (if it exists).
- [ ] Automatically generated API documentation.

## Implementation details

### URLs

URLs should be in the form of `https://docs.gitlab.com/PRODUCT/LANGUAGE/VERSION/documentation-file-name.html`.

Examples:

- `https://docs.gitlab.com/ce/en/9-0/documentation-file-name.html`
- `https://docs.gitlab.com/ee/en/9-1/documentation-file-name.html`
- `https://docs.gitlab.com/omnibus/en/9-5/documentation-file-name.html`

Relative paths between documentation pages would need to automatically correct to the right product, language, and version.

### Pulling `docs` directories from the CE, EE, and Omnibus repositories

#### Requirements

- Needs to be able to use Git tags to pull in versions.
- Needs to be performant, can't take a huge amount of time to generate the documentation site. Goal is 15 minutes maximum.
- Fully runnable locally so we can easily test changes locally.

#### Possible options

**Submodules**:

Include the `docs` directories for each repo in the gitlab-docs repo using submodules.

- Not well-supported by GitLab
- Not sure if submodules can be used to pull down just a directory?

**Artifacts**:

Have the build process for the Docs site pull artifacts down from each repository.

- Artifacts would need to be hosted long-term by CI.
- Can't generate artifacts exclusively for tags, would be generated for every commit.

**Pull in repositories dynamically** (this is what we went with):

Pull down the repositories during the build process and splice the docs directories together in the right places for use with the nanoc site.

**Include the built site in the repository itself**:

This is almost definitely out of the question due to how bloated the repository would become and how much of a pain it'd be to maintain this, but it is an option and would make the build process quite a bit faster.

### Performance

- Use artifacts to store previous versions of the site so they don't have to be regenerated constantly.
- Nanoc is supposedly quite fast.

### Differentiating between CE and EE features

One potential problem with having separate docs for CE vs. EE is the inability to easily track differences between the two. Their documentation won't necessarily be kept in-sync and pages that differ between CE and EE may cause conflicts when merging the CE repository into EE.

One potential solution to this problem is to include the EE docs inside the CE repository and then label pages as either Universal or EE-only (using frontmatter). The same could be done for specific sections on the page. This has the potential downside of complicating the documentation-writing process for contributors, but arguably the complexity of the CE/EE repositories already exists, so we're not really adding complexity so much as switching its form.

The Atom Flight Manual has [the ability to switch between platforms for given pages](http://flight-manual.atom.io/using-atom/sections/atom-selections/), this code could be repurposed for including/excluding features based on whether the documentation is CE or EE ([Source](https://raw.githubusercontent.com/atom/flight-manual.atom.io/4c8f8d14e13b84584fe206e914ea06c6dc2b7a96/content/using-atom/sections/atom-selections.md)).

## Review Apps for documentation merge requests

If you are contributing to GitLab docs read how to create a Review App with each
merge request: https://docs.gitlab.com/ee/development/writing_documentation.html#previewing-the-changes-live.

## Deployment process

We use [GitLab Pages][pages] to build and host this website. You can see
`.gitlab-ci.yml` for more information.

We also use [scheduled pipelines](https://docs.gitlab.com/ee/user/project/pipelines/schedules.html)
to build the site once an hour.

[job]: https://gitlab.com/gitlab-org/gitlab-ce/blob/2c00d00ec1c39dbea0e0e54265027b5476b78e3c/.gitlab-ci.yml#L308-318
[pages]: https://pages.gitlab.io
[environments page]: https://gitlab.com/gitlab-com/gitlab-docs/environments/folders/review
[env-url-button]: https://docs.gitlab.com/ce/ci/environments.html#making-use-of-the-environment-url
[pipelines page]: https://gitlab.com/gitlab-com/gitlab-docs/pipelines
[new pipeline page]: https://gitlab.com/gitlab-com/gitlab-docs/pipelines/new
