/* eslint-disable no-underscore-dangle */
import instantsearch from '@tnir/instantsearch.js';
import { singleIndexQ } from '@tnir/instantsearch.js/es/lib/stateMappings';
import {
  searchBox,
  refinementList,
  infiniteHits,
  stats,
  poweredBy,
  configure,
} from '@tnir/instantsearch.js/es/widgets';
import algoliasearch from 'algoliasearch';

document.addEventListener('DOMContentLoaded', () => {
  const search = instantsearch({
    indexName: 'gitlab',
    searchClient: algoliasearch('BH4D9OD16A', 'ce1690e1421303458a1fcbea0cc4a927'),
    algoliaOptions: {
      // Filter by tags as described in https://github.com/algolia/docsearch-configs/blob/master/configs/gitlab.json
      filters: 'tags:gitlab<score=3> OR tags:omnibus<score=2> OR tags:runner<score=1>',
    },
    routing: {
      stateMapping: singleIndexQ('gitlab'),
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

    refinementList({
      container: '#refinement-list',
      attribute: 'tags',
      sortBy: ['name:asc', 'isRefined'],
      templates: {
        header: 'Refine your search:',
      },
    }),

    infiniteHits({
      container: '#hits',
      templates: {
        item(hit) {
          const content = hit._highlightResult.content.value.replaceAll('&amp;quot;', '"');
          return `
           <a href="${hit.url}" class="hit">
              <div class="hit-content">
                <h3 class="hit-name lvl0">${hit._highlightResult.hierarchy.lvl0.value}</h3>
                <h4 class="hit-description lvl1">${hit._highlightResult.hierarchy.lvl1.value}</h4>
                <h5 class="hit-description lvl2">${hit._highlightResult.hierarchy.lvl2.value}</h5>
                <div class="hit-text">${content}</div>
                <div class="hit-tag">${hit.tags}</div>
              </div>
            </a>
        `;
        },
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
    }),
  ]);

  search.start();
});
