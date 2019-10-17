import Vue from 'vue';
import NavigationToggle from '../components/nav-toggle/NavigationToggle.vue';

document.addEventListener(
  'DOMContentLoaded',
  () => {
    new Vue({
      el: '#js-nav-toggle',
      components: {
        NavigationToggle,
      },
      render(createElement) {
        return createElement(NavigationToggle, {
          props: {
            targetSelector: '.nav-wrapper',
          }
        });
      },
    })
  }
);
