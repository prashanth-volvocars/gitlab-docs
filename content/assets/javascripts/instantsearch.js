---
version: 2
---
const search = instantsearch({
  indexName: 'gitlab',
  searchClient: algoliasearch('BH4D9OD16A', 'ce1690e1421303458a1fcbea0cc4a927'),
  algoliaOptions: {
    // Filter by tags as described in https://github.com/algolia/docsearch-configs/blob/master/configs/gitlab.json
    'filters': "tags:gitlab<score=3> OR tags:omnibus<score=2> OR tags:runner<score=1>",
  },
  routing: {
    stateMapping: instantsearch.stateMappings.singleIndexQ('gitlab')
  },
  searchFunction: function(helper) {
    var searchResults = $('.search-results');
    if (helper.state.query === '') {
      searchResults.hide();
      return;
    }
    helper.search();
    searchResults.show();
  }
});

search.addWidgets([
  instantsearch.widgets.searchBox({
    container: '#searchbox',
    placeholder: 'Search GitLab Documentation',
    showReset: true,
    showLoadingIndicator: true
  }),

  instantsearch.widgets.poweredBy({
    container: '#powered-by',
  }),

  instantsearch.widgets.refinementList({
    container: '#refinement-list',
    attribute: 'tags',
    sortBy: ["name:asc","isRefined"],
    templates: {
      header: 'Refine your search:'
    }
  }),

  instantsearch.widgets.infiniteHits({
    container: '#hits',
    templates: {
      item: document.getElementById('hit-template').innerHTML,
      empty: "We didn't find any results for the search <em>\"{{query}}\"</em>"
    },
    escapeHits: true,
    showMoreLabel: "Load more results..."
  }),

  instantsearch.widgets.stats({
    container: '#stats'
  }),

  instantsearch.widgets.configure({
    // Number of results shown in the search dropdown
    'hitsPerPage': 10,
  })
]);

search.start();
