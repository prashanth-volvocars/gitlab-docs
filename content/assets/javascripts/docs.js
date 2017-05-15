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

  // if the document has a top level nav
  if(nav[0]) {

    // append to the sidebar
    var sidebar = document.getElementById('doc-nav');

    if(sidebar) {
      sidebar.appendChild(nav[0]);
    }


    // float the main content
    var main = document.querySelectorAll('.main.class');

    if (main[0] && main[0].classList) {
      main[0].classList.add('float-left');
    }
    else {
      main[0].className += ' float-left';
    }


    // fix the wrapper width and center
    var wrapper = document.querySelectorAll('.wrapper');

    if (wrapper[0] && wrapper[0].classList) {
      wrapper[0].classList.add('has-nav');
    }
    else {
      wrapper[0].className += ' has-nav';
    }
  }
})();
