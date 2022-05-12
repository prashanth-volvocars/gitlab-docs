# Testing the GitLab docs site

Before any changes to the `gitlab-docs` project are merged, they are tested in a merge request's
CI/CD pipeline. The pipeline configuration is in the [`.gitlab-ci.yml`](../.gitlab-ci.yml) file.

You can [run the same tests locally](#run-tests-locally), before pushing your changes
to the project.

## What do we test?

| Test target  | Tool        | Purpose             |
| ------------ | ----------- | ------------------- |
| CSS          | Stylelint   | Code quality        |
| Dockerfiles  | Hadolint    | Syntax checks       |
| JavaScript   | ESLint      | Syntax checks       |
| JavaScript   | Prettier    | Code formatting     |
| Links        | Nanoc check | Find broken links   |
| Ruby         | RSpec       | Unit tests          |
| Vue          | Jest        | Unit tests          |
| YAML         | yamllint    | Syntax checks       |

## Run tests locally

You must install the dependencies before you can run tests locally:

- node modules: `yarn install`
- Ruby gems: `bundle install`
- hadolint (MacOS: `brew install hadolint`)
- yamllint (MacOS: `brew install yamllint`)

To run the tests:

`make test`

### Lefthook

Optionally, you can use Lefthook to automatically run tests before pushing code.
Install Lefthook with `lefthook install`, then the tests run each time you run a
`git push` command

Lefthook settings are configured in [`lefthook.yml`](../lefthook.yml).
