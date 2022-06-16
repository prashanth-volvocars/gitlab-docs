import instantsearch from 'instantsearch.js';
import { singleIndex } from 'instantsearch.js/es/lib/stateMappings';
import { searchBox, infiniteHits, stats, poweredBy, configure } from 'instantsearch.js/es/widgets';
import algoliasearch from 'algoliasearch';

document.addEventListener('DOMContentLoaded', () => {
  const search = instantsearch({
    indexName: 'gitlab',
    searchClient: algoliasearch('3PNCFOU757', '89b85ffae982a7f1adeeed4a90bb0ab1'),
    routing: {
      stateMapping: singleIndex('gitlab'),
    },
    searchFunction: (helper) => {
      if (helper.state.query === '') {
        return;
      }
      helper.search();
    },
  });

  search.addWidgets([
    searchBox({
      container: '#searchbox',
      placeholder: 'Search GitLab Documentation',
      showReset: true,
      showLoadingIndicator: true,
    }),

    poweredBy({
      container: '#powered-by',
    }),

    infiniteHits({
      container: '#hits',
      templates: {
        item: document.getElementById('hit-template').innerHTML,
        empty: 'We didn\'t find any results for the search <em>"{{query}}"</em>',
      },
      escapeHits: true,
      showMoreLabel: 'Load more results...',
    }),

    stats({
      container: '#stats',
    }),

    configure({
      // Number of results shown in the search dropdown
      hitsPerPage: 10,
      facetFilters: [`version:14.10`],
    }),
  ]);

  search.start();
});
