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
  var nav = document.querySelectorAll('.breadcrumbs +ul');
  var main = document.querySelectorAll('.main.class');

  // if the document has a top level nav
  if(nav[0]) {

    // append to the sidebar
    var sidebar = document.getElementById('doc-nav');

    if(sidebar) {
      // if there is one h1 in the documentation
      if(nav[0].children.length == 1) {

        // if there is a nested ul after the first anchor
        if(nav[0].children[0].children.length > 1) {
          var menu = nav[0].children[0].children[1];
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

          var sidebarHeight = sidebar.querySelector('ul').getBoundingClientRect().height + 55;

          document.addEventListener('scroll', function() {
            if (window.innerWidth < 1099) return;

            if (window.scrollY + sidebarHeight >= main[0].offsetHeight) {
              sidebar.style.position = 'absolute';
              sidebar.style.top = (main[0].offsetHeight - sidebarHeight) + 'px';
            } else {
              sidebar.style.position = '';
              sidebar.style.top = '';
            }
          }, { passive : true });
        }

        // remove what is left of the old navigation
        nav[0].remove()
      }
      else {
        nav[0].remove()
      }
    }

    // main content has-toc
    if (main[0] && main[0].classList) {
      main[0].classList.add('has-toc');
    }
    else {
      main[0].className += ' has-toc';
    }
  }
})();
