import Vue from 'vue';
import VersionsDropdown from './components/versions_dropdown.vue';

document.addEventListener('DOMContentLoaded', () => {
  return new Vue({
    el: '#versions-dropdowns',
    components: {
      VersionsDropdown,
    },
    render(createElement) {
      return createElement(VersionsDropdown, {});
    },
  });
});
