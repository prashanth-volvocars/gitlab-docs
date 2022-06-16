/**
 * Functions used by both DocSearch and InstantSearch.
 */

export const getDocsVersion = () => {
  let docsVersion = 'main';
  if (document.querySelector('meta[name="docsearch:version"]').content.length > 0) {
    docsVersion = document.querySelector('meta[name="docsearch:version"]').content;
  }
  return docsVersion;
};
