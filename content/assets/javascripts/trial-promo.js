---
version: 1
---
//moves contents of trial-promo layout to be within js-article-content 
document.addEventListener('DOMContentLoaded', function() {
  const trialPromo = document.getElementById('trial-promo');
  const mainArticleContent = document.querySelector('[data-maincontent]');
  const insertionPoint = document.querySelector('[data-maincontent] > :not([id]):not([class])');
  mainArticleContent.insertBefore(trialPromo, insertionPoint);
});
