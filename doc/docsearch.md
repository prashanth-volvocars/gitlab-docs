# Algolia DocSearch

GitLab is a member of the [Algolia's DocSearch program](https://docsearch.algolia.com/),
which is a free tier of [Algolia](https://www.algolia.com/). We use
[DocSearch](https://github.com/algolia/docsearch) for the docs site's search function.

Algolia [crawls](#configure-the-algolia-crawler) our documentation, pushes the content to an
[index](https://www.algolia.com/doc/guides/sending-and-managing-data/manage-your-indices/),
and DocSearch provides a dropdown search experience on our website.

## DocSearch implementation details

DocSearch layouts are defined in various places:

- Home page: [`content/index.erb`](../content/index.erb)
- Dedicated search page under `/search`: [`layouts/instantsearch.html`](../layouts/instantsearch.html)
- Every other page: [`layouts/docsearch.html`](../layouts/docsearch.html)

A Javascript snippet initiates docsearch by using an API key, app ID,
and an index name that are needed for Algolia to show the results:

- Dedicated search page under `/search`: [`content/frontend/search/index.js`](../content/frontend/search/index.js)
- Every other page: [`content/assets/javascripts/docsearch.js`](../content/assets/javascripts/docsearch.js)

## Override DocSearch CSS

DocSearch defines its various classes starting with `DocSearch-`. To override those,
there's one file to edit:

- [`content/assets/stylesheets/_docsearch.scss`](../content/assets/stylesheets/_docsearch.scss)

## Navigate Algolia as a GitLab member

GitLab members can access Algolia's dashboard with the credentials that are
stored in 1Password (search for Algolia). After you log in, you can visit:

- The index dashboard
- The Algolia crawler

### Browse the index dashboard

The [index dashboard](https://www.algolia.com/apps/3PNCFOU757/analytics/overview/gitlab)
provides information about the data that Algolia has extracted from the docs site.

Useful information:

- [Sorting](https://www.algolia.com/doc/guides/managing-results/refine-results/sorting/)
- [Custom ranking](https://www.algolia.com/doc/guides/managing-results/must-do/custom-ranking/)

### Configure the Algolia crawler

An Algolia crawler does three things:

- Browses your website
- Extracts key information
- Sends the data to Algolia

You can change the way Algolia crawls our website to extract the search results:

1. Visit the
   [crawler editor](https://crawler.algolia.com/admin/crawlers/d46abdc0-bb41-4d50-95b7-a3e1fe6469a4/configuration/edit).
1. Make your changes.
   Algolia keeps a record of the previous edits in the **Configuration History** tab,
   so you can easily roll back in case something doesn't work as expected.
1. Select **Save**.
1. Go to the [overview page](https://crawler.algolia.com/admin/crawlers/d46abdc0-bb41-4d50-95b7-a3e1fe6469a4/overview)
   and select **Restart crawling**. Crawling takes about 50 minutes, our index
   data is about 2GB.

Read more about the crawler:

- [DocSearch crawler documentation](https://docsearch.algolia.com/docs/record-extractor)
- [Algolia crawler documentation](https://www.algolia.com/doc/tools/crawler/getting-started/overview/)
  - Watch this [short video](https://www.youtube.com/watch?v=w84K1cbUbmY) that
    explains what a crawler is and how it works.

### Analytics and weekly reports of the search usage

You can view the search usage in the
[analytics dashboard](https://www.algolia.com/apps/3PNCFOU757/analytics/overview/gitlab).

If you want to receive weekly reports of the search usage, open a new
[access request](https://about.gitlab.com/handbook/engineering/#access-requests)
issue and ask that your email is added to the DocSearch alias (the same email as found in 1Password).
