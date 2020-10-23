---
version: 1
---

$(function () {
  $('[data-toggle="popover"]').popover();
  $('.popover-dismiss').popover({
    trigger: 'focus'
  })
})
