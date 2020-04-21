---
version: 1
---

// add a copy button to every code // working
$('pre').append($('<button class="clip-btn" title="Click to copy" data-selector="true"><i class="fa fa-clipboard" aria-hidden="true"></i></button>'));

// Tooltip
$('button').tooltip({
  trigger: 'click',
  placement: 'left'
});

function setTooltip(btn, message) {
  $(btn).tooltip('hide')
    .attr('data-original-title', message)
    .tooltip('show');
}

function hideTooltip(btn) {
  setTimeout(function() {
    $(btn).tooltip('hide');
  }, 1000);
}

// trigger clipboardjs
var clipboard = new ClipboardJS('.clip-btn', {
  target: function(trigger) {
    return trigger.previousElementSibling;
  }
});

clipboard.on('success', function(e) {
  setTooltip(e.trigger, 'Copied!');
  hideTooltip(e.trigger);
  e.clearSelection();
});

clipboard.on('error', function(e) {
  setTooltip(e.trigger, 'Failed!');
  hideTooltip(e.trigger);
});
