---
version: 2
---

var NAV_INLINE_BREAKPOINT = 1100;

var landingHeaderBar = document.getElementById('landing-header-bar');
var headerLinks = document.getElementsByClassName('header-link');

if (landingHeaderBar) {
  window.addEventListener('scroll', function() {
    if (window.scrollY >= 100) {
      landingHeaderBar.classList.add('scrolling-header');
      for (var i = 0; i < headerLinks.length; i++) {
        headerLinks[i].classList.add('scrolling-header-links');
      }
    } else {
      landingHeaderBar.classList.remove('scrolling-header');
      for (var i = 0; i < headerLinks.length; i++) {
        headerLinks[i].classList.remove('scrolling-header-links');
      }
    }
  });
}

var navtoggle = document.getElementById('docs-nav-toggle');
if (navtoggle) {
  navtoggle.addEventListener('click', toggleNavigation);
}

function toggleNavigation() {
  nav = document.getElementsByClassName('header')[0];
  nav.classList.toggle('active');
}

// move document nav to sidebar
(function() {
  var timeofday = document.getElementById('timeofday');
  var main = document.querySelector('.js-main-wrapper');

  // Set timeofday var depending on the time //

  if (timeofday) {
    var date = new Date();
    var hour = date.getHours();

    if (hour < 11) {
      timeofday.innerHTML = 'morning';
    }

    if (hour >= 11 && hour < 16) {
      timeofday.innerHTML = 'afternoon';
    }

    if (hour >= 16) {
      timeofday.innerHTML = 'evening';
    }
  }

  document.addEventListener('DOMContentLoaded', function() {
    var globalNav = document.getElementById('global-nav');
    var media = window.matchMedia('(max-width: 1099px)');

    window.addEventListener('scroll', function(e) {
      var isTouchingBottom = false;

      if (!media.matches) {
        isTouchingBottom =
          window.scrollY + window.innerHeight >=
          document.querySelector('.footer').offsetTop;
      }

      if (isTouchingBottom) {
        globalNav.style.top =
          main.offsetHeight -
          (window.scrollY + globalNav.offsetHeight) +
          80 +
          'px';
      } else {
        globalNav.style.top = '';
      }
    });

    // Adds the ability to auto-scroll to the active item in the TOC
    $(window).on('activate.bs.scrollspy', function() {
      const isMobile = window.matchMedia('(max-width: 1099px)').matches;

      if(isMobile) {
        return;
      }

      const activeAnchors = document.querySelectorAll('#markdown-toc .nav-link.active');

      if(activeAnchors.length) {
        const sidebarAnchorOffset = 45;
        const lastActiveAnchor = activeAnchors[activeAnchors.length -1];
        const sidebar = document.getElementById('doc-nav');
        // Takes the last active anchor in the tree and scrolls it into view.
        lastActiveAnchor.scrollIntoView();
        sidebar.scrollTop -= sidebarAnchorOffset;
      }
    });
  });
})();
