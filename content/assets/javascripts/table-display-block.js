---
version: 2
---

var tableList = document.querySelectorAll('.js-article-content table');
tableList.forEach(
  function(table) {
    table.classList.add('display-block');
  }
);
