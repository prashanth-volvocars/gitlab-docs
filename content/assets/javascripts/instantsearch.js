const search = instantsearch({
  appId: 'BH4D9OD16A',
  apiKey: 'ce1690e1421303458a1fcbea0cc4a927',
  indexName: 'gitlab',
  algoliaOptions: {
    // Filter by tags as described in https://github.com/algolia/docsearch-configs/blob/master/configs/gitlab.json
    'filters': "tags:gitlab<score=3> OR tags:omnibus<score=2> OR tags:runner<score=1>",
    // Number of results shown in the search dropdown
    'hitsPerPage': 10,
  },
  loadingIndicator: true,
  urlSync: true,
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

search.addWidget(
  instantsearch.widgets.searchBox({
    container: '#search-input',
    reset: true,
    poweredBy: true
  })
);

search.addWidget(
    instantsearch.widgets.refinementList({
      container: '#refinement-list',
      attributeName: 'tags',
      sortBy: ["name:asc","isRefined"],
      templates: {
        header: 'Refine your search:'
      }
    })
  );

search.addWidget(
  instantsearch.widgets.infiniteHits({
    container: '#hits',
    templates: {
      item: document.getElementById('hit-template').innerHTML,
      empty: "We didn't find any results for the search <em>\"{{query}}\"</em>"
    },
    escapeHits: true,
    showMoreLabel: "Load more results..."
  })
);

search.addWidget(
  instantsearch.widgets.stats({
    container: '#stats',
    templates: {
      body: '<div class="stats">We found {{nbHits}} results, fetched in {{processingTimeMS}}ms.</div>'
    }
  })
);

search.start();
