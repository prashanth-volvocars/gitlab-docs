---
version: 1
---

document.addEventListener('DOMContentLoaded', () => {
  const el = document.getElementById('search-input');
  const path = window.location.pathname
    .replace(/^\/((\d+)\.(\d+)?)(\/?(ee|ce)?)\//, '')
    .split(/[-/_]/)
    .join(' ')
    .trim()
    .replace(/\.[a-zA-Z]+$/, '');

  el.value = path;
  el.focus();
  el.dispatchEvent(new Event('input'));
});
