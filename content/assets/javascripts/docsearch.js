---
version: 2
---

var search = docsearch({
  apiKey: 'ce1690e1421303458a1fcbea0cc4a927',
  indexName: 'gitlab',
  inputSelector: '.docsearch',
  algoliaOptions: {
    // Filter by tags as described in https://github.com/algolia/docsearch-configs/blob/master/configs/gitlab.json
    'filters': "tags:gitlab<score=4> OR tags:omnibus<score=3> OR tags:runner<score=2> OR tags:charts<score=1>",
    // Number of results shown in the search dropdown
    'hitsPerPage': 10
  },
  debug: false, // Set debug to true if you want to inspect the dropdown
  autocompleteOptions: {
    autoselect: false
  }
});

search.autocomplete.parent()[0].style.display = 'inherit';
