---
version: 3
---

document.addEventListener('DOMContentLoaded', () => {
  // eslint-disable-next-line no-undef
  docsearch({
    apiKey: '89b85ffae982a7f1adeeed4a90bb0ab1',
    indexName: 'gitlab',
    container: '#docsearch',
    appId: "3PNCFOU757",
    placeholder: 'Search the docs',
    resultsFooterComponent({ state }) {
      return {
        type: "a",
        ref: undefined,
        constructor: undefined,
        key: state.query,
        props: {
          href: `/search/?query=${state.query}`,
          children: `See all results`
        },
        __v: null
      }
    }
  });
});
