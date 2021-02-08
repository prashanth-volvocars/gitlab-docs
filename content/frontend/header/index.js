document.addEventListener('DOMContentLoaded', () => {
  const mobileToggle = document.querySelector('.mobile-nav-toggle');
  const classes = [document.querySelector('.main'), document.querySelector('.nav-wrapper')];
  if (!mobileToggle) {
    return;
  }
  mobileToggle.addEventListener('click', () =>
    classes.forEach((el) => {
      el.classList.toggle('active');
    }),
  );
});
