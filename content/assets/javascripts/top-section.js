---
version: 1
---

document.addEventListener('DOMContentLoaded', function() {
  const headerTop = document.getElementById('top-section')
  const yield = document.getElementsByClassName('js-article-content')[0] //change this to be with an ID/data attribute to be more clear
  const noID = Array.from(yield.children).filter(child => (child.id === '' && !child.classList.length))
  yield.insertBefore(headerTop, noID[0])
})
