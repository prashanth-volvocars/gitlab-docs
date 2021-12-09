# GitLab docs site development

## Linking to source files

A helper called [`edit_on_gitlab`](/lib/helpers/edit_on_gitlab.rb) can be used
to link to a page's source file. We can link to both the simple editor and the
web IDE. Here's how you can use it in a Nanoc layout:

- Default editor:
  `<a href="<%= edit_on_gitlab(@item, editor: :simple) %>">Simple editor</a>`
- Web IDE: `<a href="<%= edit_on_gitlab(@item, editor: :webide) %>">Web IDE</a>`

If you don't specify `editor:`, the simple one is used by default.

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

A lot of the JavaScript can be found in [`content/assets/javascripts/`](https://gitlab.com/gitlab-org/gitlab-docs/-/tree/main/content/assets/javascripts/content/assets/javascripts).
The files in this directory are handcrafted `ES5` JavaScript files.

We've [recently introduced](https://gitlab.com/gitlab-org/gitlab-docs/merge_requests/577)
the ability to write modern JavaScript. All modern JavaScript should be added to
the [content/frontend/](https://gitlab.com/gitlab-org/gitlab-docs/-/tree/main/content/frontend) directory.

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

## Bump versions of CSS and JavaScript

Whenever the custom CSS and JavaScript files under `content/assets/` change,
make sure to bump their version in the front matter. This method guarantees that
your changes take effect by clearing the cache of previous files.

Always use Nanoc's way of including those files, do not hardcode them in the
layouts. For example use:

```js
<script async type="application/javascript" src="<%= @items['/assets/javascripts/badges.*'].path %>"></script>

<link rel="stylesheet" href="<%= @items['/assets/stylesheets/toc.*'].path %>">
```

The links pointing to the files should be similar to:

```js
<%= @items['/path/to/assets/file.*'].path %>
```

Nanoc then builds and renders those links correctly according with what's
defined in [`Rules`](https://gitlab.com/gitlab-org/gitlab-docs/-/blob/main/Rules).

##  Adding query strings to CTAs headed to about.gitlab.com/pricing

We've created [a Sisense dashboard that can only be seen by full-time team members](https://app.periscopedata.com/app/gitlab/950797/GitLab.com-SaaS-trials---no-SAFE-data)
to track the number of SaaS free trials that start from a documentation page.

If you would like to track that information, add the following parameters to the URL:

- `glm_source` is `docs.gitlab.com`
- `glm_content` set to anything that ends with `-docs`

### Example: 

`https://about.gitlab.com/pricing?=glm_source=docs.gitlab.com&glm_content=name-of-item-docs`

## Add a new product

To add a new product other than the main 4 (GitLab, Omnibus, Runner, Charts):

1. Clone the repository at the same root level as the `gitlab-docs` repository:

   ```shell
   git clone https://gitlab.com/<repo>.git <product_name>
   ```

1. In [`nanoc.yaml`](./nanoc.yaml):

   - Add an entry under `data_sources` similar to the other ones. For example:

     ```yaml
     -  # Documentation from https://gitlab.com/<repo>
       type: filesystem
       items_root: /<slug>/
       content_dir: ../<product_name>/<doc_dir>
       layouts_dir: null
       encoding: utf-8
       identifier_type: full
     ```

     Where:

     - `items_root`: the subdirectory where the docs will be hosted. This will
       end up being `https://docs.gitlab.com/<slug>`.
     - `content_dir`: the relative path where the docs reside. Normally, this is
       points to the repository you cloned in the first step.

   - Add the product's details under the `products` key:

     ```yaml
     <product_name>:
       slug: '<product_name_slug>'
       repo: 'https://gitlab.com/<repo>.git'
       project_dir: '../product_name'
       content_dir: '../product_name/<doc_dir>'
     ```

     Where:

     - `<product_name>`: this is used by other parts of code, for example
       `lib/task_helpers.rb`.
     - `slug`: used in the Rakefile. Usually the same as the product name.
     - `project_dir`: the repository of the product, relative to the `gitlab-docs`
        repo.
     - `content_dir`: the product's documentation directory. This is the same
       as the `content_dir` defined in `data_sources`.

1. In [`lib/task_helpers.rb`](./lib/task_helpers.rb):

   - Add the `<product_name>` under the `PRODUCTS` variable. For example:

     ```ruby
     PRODUCTS = %w[ee omnibus runner charts <product_name>].freeze
     ```

   - If the product has a different stable branch naming scheme than what is
     already in this file, you need to add another
     [when statement](https://gitlab.com/gitlab-org/gitlab-docs/-/blob/68814c875e322b1871d6368135af49794041ddd1/lib/task_helpers.rb#L20-44)
     that takes care of that.

     Otherwise, if the product doesn't have a stable branch at all, you can omit
     this and the default branch will be always pulled.

1. In [`.gitlab-ci.yml`](https://gitlab.com/gitlab-org/gitlab-docs/-/blob/68814c875e322b1871d6368135af49794041ddd1/.gitlab-ci.yml#L30-34),
   set the default branch variable for the new product. For example:

   ```yaml
   variables:
     BRANCH_PRODUCT: main
   ```

1. In [`Rakefile`](https://gitlab.com/gitlab-org/gitlab-docs/-/blob/68814c875e322b1871d6368135af49794041ddd1/Rakefile#L107-113),
   add a line to replace the product's branch variable. If the product doesn't
   follow a stable branch process yet, you can omit this step and the product's
   default branch will be used.
