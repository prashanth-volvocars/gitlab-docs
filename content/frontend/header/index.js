document.addEventListener('DOMContentLoaded', () => {
  const navBar = document.querySelector('.header');
  const navToggle = document.querySelector('.nav-toggle');
  const mobileToggle = document.querySelector('.mobile-nav-toggle');
  const classes = [document.querySelector('.main'), document.querySelector('.nav-wrapper')];
  navToggle.addEventListener('click', () => navBar.classList.toggle('active'));
  if (!mobileToggle) {
    return;
  }
  mobileToggle.addEventListener('click', () =>
    classes.forEach((el) => {
      el.classList.toggle('active');
    }),
  );
});
