<script>
import algoliasearch from 'algoliasearch/lite';
import 'instantsearch.css/themes/satellite-min.css';
import { history as historyRouter } from 'instantsearch.js/es/lib/routers';
import { singleIndex as singleIndexMapping } from 'instantsearch.js/es/lib/stateMappings';
import { GlIcon } from '@gitlab/ui';

export default {
  components: {
    GlIcon,
  },
  props: {
    docsVersion: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      searchClient: algoliasearch('3PNCFOU757', '89b85ffae982a7f1adeeed4a90bb0ab1'),
      routing: {
        router: historyRouter(),
        stateMapping: singleIndexMapping('gitlab'),
      },
    };
  },
};
</script>

<template>
  <ais-instant-search
    :search-client="searchClient"
    index-name="gitlab"
    :routing="routing"
    :stalled-search-delay="500"
    class="gl-pb-8"
  >
    <h1 class="gl-mt-5!">Search</h1>
    <ais-search-box
      placeholder="Search GitLab Documentation"
      show-loading-indicator
      data-testid="docs-search"
    />

    <ais-state-results>
      <template #default="{ results: { hits, query } }">
        <div class="gl-display-flex gl-align-items-bottom gl-mb-6">
          <ais-stats v-show="query.length > 0" class="gl-font-sm" />
          <ais-powered-by
            :class-names="{
              'ais-PoweredBy': 'gl-absolute gl-right-7 gl-mt-2',
              'ais-PoweredBy-link': 'no-attachment-icon gl-border-bottom-0!',
            }"
          />
        </div>

        <ais-infinite-hits v-if="query.length > 0 && hits.length > 0">
          <template #item="{ item }">
            <div>
              <a :href="item.url" class="gl-font-lg">{{ item.hierarchy.lvl0 }}</a>
              <p v-if="item.hierarchy.lvl2" class="gl-mt-2! gl-font-base!">
                <gl-icon name="chevron-right" :size="12" /> {{ item.hierarchy.lvl2 }}
              </p>
            </div>
          </template>
        </ais-infinite-hits>

        <div v-if="query.length > 0 && hits.length < 0">
          No results found for <em>{{ query }}</em
          >.
        </div>
      </template>
    </ais-state-results>

    <ais-configure :hits-per-page.camel="10" :facet-filters.camel="`version:` + docsVersion" />
  </ais-instant-search>
</template>
