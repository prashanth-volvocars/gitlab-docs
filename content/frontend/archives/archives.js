import Vue from 'vue';
import Banner from '../shared/components/banner.vue';

document.addEventListener('DOMContentLoaded', () => {
  const urlParams = window.location.search;
  const isOffline = urlParams.includes('?offline');

  // eslint-disable-next-line no-new
  new Vue({
    el: '#js-banner',
    components: {
      Banner,
    },
    render(createElement) {
      return createElement(Banner, {
        props: {
          text:
            'You attempted to view an older version of the documentation that is no longer available on this site. Please select a newer version from the menu above or access an archive listed below.',
          show: isOffline,
        },
        on: {
          toggle(isVisible) {
            const wrapper = document.querySelector('.wrapper');
            wrapper.classList.toggle('show-banner', isVisible);
          },
        },
      });
    },
  });
});
