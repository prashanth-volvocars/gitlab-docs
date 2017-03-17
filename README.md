[![build status](https://gitlab.com/gitlab-com/gitlab-docs/badges/master/build.svg)](https://gitlab.com/gitlab-com/gitlab-docs/commits/master)

# GitLab Documentation

This site is generated using [Nanoc](http://nanoc.ws).

## Development

To set up the site locally:

- `bundle install`
- `bundle exec nanoc live`

This will host the site at `localhost:3000`. Changes will be reloaded automatically using [Guard Nanoc](https://github.com/guard/guard-nanoc).

To pull down the documentation content, run `rake pull_repos`. If you want to force-delete the `tmp/` and `content/` folders so the task will run without manual intervention, run `RAKE_FORCE_DELETE=true rake pull_repos`.

## Projects we pull from

We pull from the following projects:

- [GitLab Community Edition](https://gitlab.com/gitlab-org/gitlab-ce)
- [GitLab Enterprise Edition](https://gitlab.com/gitlab-org/gitlab-ee)
- [Omnibus GitLab](https://gitlab.com/gitlab-org/omnibus-gitlab)
- [GitLab Runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner)

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

If you are working on [one of the projects we pull from](#projects-we-pull-from)
and updating the documentation, there is a way to preview it using Review Apps
in the gitlab-docs project:

1. Make sure you have Developer (push) access to this project.
1. Clone the docs site:

    ```
    git clone git@gitlab.com:gitlab-com/gitlab-docs.git
    ```

1. Create a branch.
1. Edit `.gitlab-ci.yml` and change the branch variable of the project you
   wish to preview. For example, if you work on documentation changes for
   GitLab CE and the branch is named `1234-docs-for-foo`, change the respective
   CI variable:

     ```yaml
     VARIABLES:
       BRANCH_CE: '1234-docs-for-foo'
     ```

1. Commit your changes and push the branch.
1. Optionally create an MR marked as `WIP` in order to
   avoid accidental merge, we'll use this only as a Review App.
1. Wait a few minutes and if the build finishes successfully, you'll be able to
   see the link to the preview docs in the [environments page] using the
   [environment URL button][env-url-button].

If new changes are pushed to the upstream docs, just retry the Review Apps
pipeline for the new changes to be pulled and deployed. The simplest way is to
go to the [environments page], and choose **Re-deploy** for your environment.

Once the docs are eventually merged upstream, don't forget to close the
Review Apps MR (if you created one), delete the branch and stop the environment.

## Deployment process

We use [GitLab Pages][pages] to build and host this website. You can see
`.gitlab-ci.yml` for more information.

A [job] is used to trigger a new build whenever tests run and pass on master
branch of CE, EE, Omnibus.

To add a new trigger for another project:

1. Go to https://gitlab.com/gitlab-com/gitlab-docs/triggers (you need Master
   access) and copy the trigger value.
1. Go to the project you will be triggering from and add a secret variable
   named `DOCS_TRIGGER_TOKEN` with the value of the trigger you copied from the
   previous step.
1. Add the following job to the project's `.gitlab-ci.yml`, where you should
   replace the `PROJECT` variable's value with the name of the project the
   trigger is running from, for example `ce`, `ee`, `omnibus`, `runner`, etc.:

    ```yaml
    # Trigger docs build
    # https://gitlab.com/gitlab-com/gitlab-docs/blob/master/README.md#deployment-process
    trigger_docs:
      variables:
        GIT_STRATEGY: none
      before_script: []
      cache: {}
      artifacts: {}
      script:
        - "curl -X POST -F token=${DOCS_TRIGGER_TOKEN} -F ref=master -F variables[PROJECT]=ce https://gitlab.com/api/v3/projects/1794617/trigger/builds"
      only:
        - master@gitlab-org/gitlab-ce
    ```

      >**Note:**
      Every project might have different stages, make sure to add it to one that
      makes sense, for example after all builds successfully pass.

[job]: https://gitlab.com/gitlab-org/gitlab-ce/blob/2c00d00ec1c39dbea0e0e54265027b5476b78e3c/.gitlab-ci.yml#L308-318
[pages]: https://pages.gitlab.io
[environments page]: https://gitlab.com/gitlab-com/gitlab-docs/environments/folders/review
[env-url-button]: https://docs.gitlab.com/ce/ci/environments.html#making-use-of-the-environment-url
