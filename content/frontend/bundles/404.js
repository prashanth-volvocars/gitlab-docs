document.addEventListener(
  'DOMContentLoaded',
  () => {
      const { environment, offlineVersions, archivesPath } = document.getElementById('offline-versions').dataset;
      const location = window.location.href;
      const isOffline = offlineVersions.split(',').find(version => location.includes(version));

      if(environment === 'production' && isOffline) {
         window.location.replace(archivesPath);
      }
  }
);
