# GitLab docs site

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

## Development when contributing to GitLab documentation

This section is about contributing to one of the GitLab
[projects' documentation](#projects-we-pull-from), and preview your changes at
the same time.

Before diving into writing, here are two handy links:

- [Writing documentation](https://docs.gitlab.com/ee/development/documentation/index.html)
- [Style guide](https://docs.gitlab.com/ee/development/documentation/styleguide/index.html)

There are multiple ways to preview GitLab documentation changes, you can:

- You can [build and run the docs site locally](setup.md).
- You can [create a Review App with each merge request](https://docs.gitlab.com/ee/development/documentation/index.html#previewing-the-changes-live),
  if you are a GitLab team member.
- You can [use GDK for documentation development](https://gitlab.com/gitlab-org/gitlab-development-kit/-/blob/main/doc/howto/gitlab_docs.md).
