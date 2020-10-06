import Vue from 'vue';
import ErrorMessage from './components/error_message.vue';

document.addEventListener('DOMContentLoaded', () => {
  const { environment, offlineVersions, archivesPath } = document.getElementById(
    'offline-versions',
  ).dataset;
  const location = window.location.href;
  const isOffline = offlineVersions.split(',').find((version) => location.includes(version));

  return new Vue({
    el: '#js-error-message',
    components: {
      ErrorMessage,
    },
    render(createElement) {
      return createElement(ErrorMessage, {
        provide: {
          archivesPath,
        },
        props: {
          isOffline: Boolean(isOffline),
          isProduction: environment === 'production',
        },
      });
    },
  });
});
