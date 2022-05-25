# Testing the GitLab Docs site

Tests for the GitLab Docs site include tests for code and tests for links in content. For more information, see
[Documentation testing](https://docs.gitlab.com/ee/development/documentation/testing.html).

Tests are run in `gitlab-docs` [CI/CD pipeline](https://gitlab.com/gitlab-org/gitlab-docs/-/pipelines), which is
configured in the project's [`.gitlab-ci.yml`](../.gitlab-ci.yml) file.

## Code tests

These code tests are included in the project:

| Test target | Tool        | Purpose           |
|:------------|:------------|:------------------|
| CSS         | Stylelint   | Code quality      |
| Dockerfiles | Hadolint    | Syntax checks     |
| JavaScript  | ESLint      | Syntax checks     |
| JavaScript  | Prettier    | Code formatting   |
| Ruby        | RSpec       | Unit tests        |
| Vue         | Jest        | Unit tests        |
| YAML        | yamllint    | Syntax checks     |

### Run code tests locally

To run the tests:

```shell
make test
```

### Install Lefthook

If you want to run the tests before pushing changes, use [Lefthook](https://github.com/evilmartians/lefthook#readme).
To install Lefthook, run:

```shell
lefthook install
```

Tests are run whenever you run `git push`.

Lefthook is configured in [`lefthook.yml`](../lefthook.yml).

## Link tests

You can use `gitlab-docs` to test links in content. These tests don't test `gitlab-docs`, but the content in the
projects that comprise the published GitLab Docs site.

### Run link tests locally

To test links between content pages, run:

```shell
make internal-links-check
```

To test anchor links, run:

```shell
make internal-anchors-check
```

To test both links between content pages and anchor links, run:

```shell
make internal-links-and-anchors-check
```

To test external links, run:

```shell
make external-links-check
```
