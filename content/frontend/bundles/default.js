import Vue from 'vue';
import NavigationToggle from '../components/navigation_toggle/navigation_toggle.vue';
import VersionBanner from '../components/version_banner/version_banner.vue';

document.addEventListener(
  'DOMContentLoaded',
  () => {
    const versionBanner = document.querySelector('#js-version-banner');
    const isOutdated = versionBanner.hasAttribute('data-is-outdated');
    const { latestVersionUrl, archivesUrl } = versionBanner.dataset;

    new Vue({
      el: versionBanner,
      components: {
        VersionBanner,
      },
      render(createElement) {
        return createElement(VersionBanner, {
          props: { isOutdated, latestVersionUrl, archivesUrl }
        });
      },
    });

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
    });
  }
);
