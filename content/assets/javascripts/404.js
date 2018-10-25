document.addEventListener('DOMContentLoaded', function() {
  var el = document.getElementById('search-input');
  var path = window.location.pathname
    .split(/[-/_]/)
    .join(' ')
    .trim()
    .replace(/\.[a-zA-Z]+$/, '');

  el.value = path;
  el.focus();
  el.dispatchEvent(new Event('input'));
});
