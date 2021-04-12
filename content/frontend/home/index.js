document.addEventListener('DOMContentLoaded', () => {
  // eslint-disable-next-line no-undef
  docsearch({
    apiKey: 'ce1690e1421303458a1fcbea0cc4a927',
    indexName: 'gitlab',
    inputSelector: '.docsearch-landing',
    algoliaOptions: {
      filters:
        'tags:gitlab<score=4> OR tags:omnibus<score=3> OR tags:runner<score=2> OR tags:charts<score=1>',
      hitsPerPage: 10,
    },
    debug: false,
    autocompleteOptions: {
      autoselect: false,
    },
  });
});
