const NAV_INLINE_BREAKPOINT = 1100;
const NAV_TOP_MARGIN = 55;

const isTouchingBottom = (height, offsetHeight) => {
  if (window.innerWidth < NAV_INLINE_BREAKPOINT) {
    return false;
  }

  return offsetHeight <= window.scrollY + height;
};

const getTopOffset = (height, offsetHeight) => {
  if (isTouchingBottom(height, offsetHeight)) {
    return offsetHeight - (window.scrollY + height);
  }

  return 0;
};

export default {
  bind(el, { value }) {
    let contentHeight;
    const mainEl = document.querySelector(value);

    el.$_stickToFooter_listener = () => {
      if (!contentHeight) {
        contentHeight = el.getBoundingClientRect().height + NAV_TOP_MARGIN;
      }
      const { offsetHeight } = mainEl;
      const topOffset = getTopOffset(contentHeight, offsetHeight);

      el.style.top = topOffset < 0 ? `${topOffset}px` : '';
    };

    // When we scroll down to the bottom, we don't want the footer covering
    // the TOC list (sticky behavior)
    document.addEventListener('scroll', el.$_stickToFooter_listener, { passive: true });
  },
  unbind(el) {
    el.style.top = '';
    document.removeEventListener('scroll', el.$_stickToFooter_listener);
  },
};
