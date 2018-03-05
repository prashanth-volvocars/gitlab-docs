---
title: Search through GitLab Documentation
layout: instantsearch
---
<header>
  <div>
    <input id="search-input" placeholder="Search GitLab Documentation">
     <!-- We use a specific placeholder in the input to guides users in their search. -->
  </div>
</header>
<main>
  <div id="stats"></div>
  <div id="hits"></div>
  <div id="pagination"></div>

  <script type="text/html" id="hit-template">
    <a href="{{ url }}" class="hit">
        <div class="hit-content">
          <h3 class="hit-name">{{{_highlightResult.hierarchy.lvl1.value}}}</h3>
            <h4 class="hit-description">{{{_highlightResult.hierarchy.lvl2.value}}}</h4>
          <p class="hit-text">{{{_highlightResult.content.value}}}</p>
        </div>
      </a>
  </script>
</main>