document.addEventListener('DOMContentLoaded', () => {
  const navBar = document.getElementById('landing-header-bar');
  const navToggle = document.getElementById('docs-nav-toggle');
  navToggle.addEventListener('click', () => navBar.classList.toggle('active'));
});
