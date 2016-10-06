# GitLab Documentation

This site is generated using [Nanoc](http://nanoc.ws).

## Development

To set this up:

- `bundle install`
- `bundle exec nanoc live`

Changes will be reloaded automatically using [Guard Nanoc](https://github.com/guard/guard-nanoc).

## Examples and Resources

### Open Source Nanoc Sites

**NOTE**: We use Nanoc 4.0 which has some significant differences from 3.0, be aware that not all example sites use 4.0.

- [Nanoc's Website](https://github.com/nanoc/nanoc.ws)
- [GitHub Developer Site](https://github.com/github-archive/developer.github.com)
- [Spree Guides](https://github.com/spree/spree/tree/master/guides)
- [Atom Flight Manual](https://github.com/atom/flight-manual.atom.io)

### Good Documentation

- [SendGrid](https://sendgrid.com/docs)
- [Stripe](https://stripe.com/docs)
- [Stripe API](https://stripe.com/docs/api)
- [CircleCI](https://circleci.com/docs)
- [Heroku](https://devcenter.heroku.com/)
- [Slack](https://get.slack.help/hc/en-us)
- [Slack API](https://api.slack.com/)

## Requirements/Goals

- Feature parity with the existing [docs.gitlab.com](https://docs.gitlab.com/)
- Use GitLab CI / GitLab Pages for compilation, deployment, and hosting of the Documentation site.
- Sections for Community Edition, Enterprise Edition, GitLab CI, and Omnibus.
- Pull documentation from the repositories mentioned above.
- Versioned documentation (e.g. switch between documentation for 9.0, 9.1, 9.2, 9.3, "latest", etc.)
- Automatically generated API documentation.
- Search the documentation, can probably use existing Documentation search functionality.
- Link to "Edit on GitLab.com" for every page to encourage contribution.
- Auto-generated documentation structure based on YML frontmatter.
- Responsive design.

### Nice-to-haves

- Some way to embed/package the site inside the Rails app so the documentation can be included with the application itself. This would be nice for users behind firewalls, etc. This _should not_ be handled by Rails itself, as that causes all kinds of problems. It should just be a set of static pages.
- Some way to export the documentation as PDF/ePub for use offline.
- Future-proofing for internationalization.
- Tests for working internal links and such. (Nanoc includes this by default!)
- Automated screenshots! (Not really directly related, but I still want it.)
- A blog post explaining how we do all this using GitLab, GitLab CI, and GitLab Pages, as well as all open source tools.
- Auto-generated Table of Contents for every page.
- Anchor links for every page section.
- Syntax highlighting with Rouge.
- Version dropdown that links to the current page for that version (if it exists).

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

**Pull in repositories dynamically**:

Pull down the repositories during the build process and splice the docs directories together in the right places for use with the nanoc site.

**Include the built site in the repository itself**:

This is almost definitely out of the question due to how bloated the repository would become and how much of a pain it'd be to maintain this, but it is an option and would make the build process quite a bit faster.

### Performance

- Use artifacts to store previous versions of the site so they don't have to be regenerated constantly.
- Nanoc is supposedly quite fast.
