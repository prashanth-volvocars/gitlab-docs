---
version: 1
---

(() => {
  const tableList = document.querySelectorAll('.js-article-content table');

  for (let i = 0; i < tableList.length; i++) {
    const tableWidth = tableList[i].offsetWidth;
    const parentWidth = tableList[i].parentNode.offsetWidth;

    if(tableWidth > parentWidth) {
      tableList[i].classList.add('fixed-table');
    }
  }
})();
