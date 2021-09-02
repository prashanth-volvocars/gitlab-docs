# GitLab docs site maintenance

Some of the issues that the GitLab technical writing team handles to maintain
<https://docs.gitlab.com> include:

- The [deployment process](#deployment-process).
- [Algolia search](#algolia-search).
- Temporary [event or survey banners](#survey-banner).
- [CSP headers](#csp-header)

## Deployment process

We use [GitLab Pages](https://about.gitlab.com/features/pages/) to build and
host this website.

The site is built and deployed automatically in GitLab CI/CD jobs.
See [`.gitlab-ci.yml`](https://gitlab.com/gitlab-org/gitlab-docs/-/blob/main/.gitlab-ci.yml)
for the current configuration. The project has [scheduled pipelines](https://docs.gitlab.com/ee/user/project/pipelines/schedules.html)
that build and deploy the site once every four hours.

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
1. On the docs side, we use a [docsearch layout](https://gitlab.com/gitlab-org/gitlab-docs/-/blob/main/layouts/docsearch.html) which
   is present on pretty much every page except <https://docs.gitlab.com/search/>,
   which uses its [own layout](https://gitlab.com/gitlab-org/gitlab-docs/-/blob/main/layouts/instantsearch.html). In those layouts,
   there's a Javascript snippet which initiates docsearch by using an API key
   and an index name (`gitlab`) that are needed for Algolia to show the results.

**For GitLab team members:**
The credentials to access the Algolia dashboard are stored in 1Password. If you
want to receive weekly reports of the search usage, search the Google doc with
title "Email, Slack, and GitLab Groups and Aliases", search for `docsearch`,
and add a comment with your email to be added to the alias that gets the weekly
reports.

## Survey banner

In case there's a survey that needs to reach a big audience, the docs site has
the ability to host a banner for that purpose. When it is enabled, it's shown
at the top of every page of the docs site.

To publish a survey, edit [`banner.yaml`](/content/_data/banner.yaml) and:

1. Set `show_banner` to `true`.
1. Under `description`, add what information you want to appear in the banner.
   Markdown is supported.

To unpublish a survey, edit [`banner.yaml`](/content/_data/banner.yaml) and
set `show_banner` to `false`.

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

The CSP header and the allowed domains can be found in the [`csp.html`](https://gitlab.com/gitlab-org/gitlab-docs/-/blob/main/layouts/csp.html)
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
[`/content/assets/javascripts/`](https://gitlab.com/gitlab-org/gitlab-docs/-/tree/main/content/assets/javascripts) directory,
and then be included in the HTML file that you want. The example above lives
under `/content/assets/javascripts/toggle_popover.js`, and you would call
it with:

```html
<script src="<%= @items['/assets/javascripts/toggle_popover.*'].path %>"></script>
```

### Test the CSP header for conformity

To test that the CSP header works as expected, you can visit
<https://cspvalidator.org/> and paste the URL that you want tested.

## Project tokens

The `gitlab-docs` project has two access tokens used for review apps. If you change
or delete these tokens, review apps will stop working:

- `DOCS_TRIGGER_TOKEN` is a [trigger token](https://docs.gitlab.com/ee/ci/triggers/index.html#trigger-token).
  This token is used by other projects to authenticate with the `gitlab-docs` project
  and trigger a review app deployment pipeline.
- `DOCS_PROJECT_API_TOKEN` is a [project access token](https://docs.gitlab.com/ee/user/project/settings/project_access_tokens.html).
  This token is used by other projects to poll the review app deployment pipeline
  and determine if the pipeline has completed successfully.

All projects that have documentation review apps use these tokens when running the
[`trigger-build` script](https://gitlab.com/gitlab-org/gitlab/-/blob/b09be454102f4d53ec7963aef8a625daf8ef6acc/scripts/trigger-build#L207)
to deploy a review app.
