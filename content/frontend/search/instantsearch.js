import Vue from 'vue';
import {
  AisInstantSearch,
  AisStateResults,
  AisSearchBox,
  AisStats,
  AisPoweredBy,
  AisInfiniteHits,
  AisConfigure,
} from 'vue-instantsearch';
import SearchPage from './components/search_page.vue';
import { getDocsVersion } from './search';

Vue.component(AisInstantSearch.name, AisInstantSearch);
Vue.component(AisSearchBox.name, AisSearchBox);
Vue.component(AisStateResults.name, AisStateResults);
Vue.component(AisStats.name, AisStats);
Vue.component(AisPoweredBy.name, AisPoweredBy);
Vue.component(AisInfiniteHits.name, AisInfiniteHits);
Vue.component(AisConfigure.name, AisConfigure);

const docsVersion = getDocsVersion();

document.addEventListener('DOMContentLoaded', () => {
  return new Vue({
    el: '.js-instantsearch',
    render(createElement) {
      return createElement(SearchPage, {
        props: {
          docsVersion,
        },
      });
    },
  });
});
