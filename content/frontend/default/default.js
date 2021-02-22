import Vue from 'vue';
import NavigationToggle from './components/navigation_toggle.vue';
import VersionBanner from './components/version_banner.vue';
import { setupTableOfContents } from './setup_table_of_contents';

document.addEventListener('DOMContentLoaded', () => {
  const versionBanner = document.querySelector('#js-version-banner');
  const isOutdated = versionBanner.hasAttribute('data-is-outdated');
  const { latestVersionUrl, archivesUrl } = versionBanner.dataset;

  // eslint-disable-next-line no-new
  new Vue({
    el: versionBanner,
    components: {
      VersionBanner,
    },
    render(createElement) {
      return createElement(VersionBanner, {
        props: { isOutdated, latestVersionUrl, archivesUrl },
        on: {
          toggleVersionBanner(isVisible) {
            const wrapper = document.querySelector('.wrapper');
            wrapper.classList.toggle('show-banner', isVisible);
          },
        },
      });
    },
  });

  // eslint-disable-next-line no-new
  new Vue({
    el: '#js-nav-toggle',
    components: {
      NavigationToggle,
    },
    render(createElement) {
      return createElement(NavigationToggle, {
        props: {
          targetSelector: ['.nav-wrapper', '.main'],
        },
      });
    },
  });

  setupTableOfContents();
});
