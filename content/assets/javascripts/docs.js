var NAV_INLINE_BREAKPOINT = 1100;

var navtoggle = document.getElementById("docs-nav-toggle");
if (navtoggle) {
  navtoggle.addEventListener("click", toggleNavigation);
}

function toggleNavigation() {
  nav = document.getElementsByClassName('header')[0];
  nav.classList.toggle("active");
}

// move document nav to sidebar
(function() {
  var timeofday = document.getElementById('timeofday')
  var tocList = document.querySelector('.js-article-content > ul:first-child');
  var main = document.querySelector('.js-main-wrapper');

  // Set timeofday var depending on the time //

  var date = new Date()
  var hour = date.getHours()

  if (hour < 11) {
    timeofday.innerHTML = "morning"
  }

  if (hour >= 11 && hour < 16) {
    timeofday.innerHTML = "afternoon"
  }

  if (hour >= 16) {
    timeofday.innerHTML = "evening"
  }

  // if the document has a top level nav
  if(tocList) {

    // append to the sidebar
    var sidebar = document.getElementById('doc-nav');

    if(sidebar) {
      // if there is one h1 in the documentation
      if(tocList.children.length == 1) {

        // if there is a nested ul after the first anchor
        if(tocList.children[0].children.length > 1) {
          var menu = tocList.children[0].children[1];
          var footnotes = menu.querySelector('.footnotes');

          if (footnotes) {
            footnotes.remove();
          }

          // grab the h1's li anchor text
          var title = document.createElement('h4');
          title.innerHTML = "On this page:";

          // add the text as a title
          menu.insertBefore(title, menu.children[0]);

          sidebar.appendChild(menu);

          var sidebarContent = sidebar.querySelector('ul');
          var sidebarContentHeight = 0;

          // When we scroll down to the bottom, we don't want the footer covering
          // the TOC list (sticky behavior)
          document.addEventListener('scroll', function() {
            // Wait a cycle for the dimensions to kick in
            if(!sidebarContentHeight) {
              sidebarContentHeight = sidebarContent.getBoundingClientRect().height + 55;
            }

            var isTouchingBottom = false;
            if (window.innerWidth >= NAV_INLINE_BREAKPOINT) {
              isTouchingBottom  = window.scrollY + sidebarContentHeight >= main.offsetHeight;
            }

            if (isTouchingBottom) {
              sidebarContent.style.top = (main.offsetHeight - (window.scrollY + sidebarContentHeight)) + 'px';
            } else {
              sidebarContent.style.top = '';
            }
          }, { passive : true });
        }

        // remove what is left of the old navigation
        tocList.remove()
      }
      else {
        tocList.remove()
      }
    }

    // main content has-toc
    if (main && main.classList) {
      main.classList.add('has-toc');
    }
    else {
      main.className += ' has-toc';
    }
  }
})();
