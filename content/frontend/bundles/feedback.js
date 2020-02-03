document.addEventListener('DOMContentLoaded', () => {
  const hasCommentAnchor = window.location.hash.includes('#comment-');

  if (hasCommentAnchor) {
    window.loadDisqus();
  }
});
