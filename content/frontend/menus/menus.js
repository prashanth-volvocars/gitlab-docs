import Vue from 'vue';
import VersionsMenu from './components/versions_menu.vue';

document.addEventListener('DOMContentLoaded', () => {
  return new Vue({
    el: '.js-versions-menu',
    components: {
      VersionsMenu,
    },
    render(createElement) {
      return createElement(VersionsMenu);
    },
  });
});
