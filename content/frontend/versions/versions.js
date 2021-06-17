import Vue from 'vue';
import VersionsDropdown from './components/versions_dropdown.vue';

document.addEventListener('DOMContentLoaded', () => {
  const { identifier } =
    document.getElementById('versions-dropdowns').dataset;


  return new Vue({
    el: '#versions-dropdowns',
    components: {
      VersionsDropdown,
    },
    render(createElement) {
      return createElement(VersionsDropdown, {
        provide: {
          identifier,
        }
      });
    },
  });
});
