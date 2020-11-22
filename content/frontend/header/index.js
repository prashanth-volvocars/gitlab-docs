document.addEventListener('DOMContentLoaded', () => {
  const navBar = document.querySelector('.header');
  const navToggle = document.querySelector('.nav-toggle');
  navToggle.addEventListener('click', () => navBar.classList.toggle('active'));
});
