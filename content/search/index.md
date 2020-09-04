---
title: Search through GitLab Documentation
layout: instantsearch
feedback: nil
---
<header>
  <div id="searchbox"></div>
  <div id="powered-by"></div>
</header>
<main class="search-results">
  <div id="stats"></div>
  <div id="refinement-list"></div>
  <div id="hits"></div>

  <script type="text/html" id="hit-template">
    <a href="{{ url }}" class="hit">
      <div class="hit-content">
        <h3 class="hit-name lvl0">{{{_highlightResult.hierarchy.lvl0.value}}}</h3>
        <h4 class="hit-description lvl1">{{{_highlightResult.hierarchy.lvl1.value}}}</h4>
        <h5 class="hit-description lvl2">{{{_highlightResult.hierarchy.lvl2.value}}}</h5>
        <div class="hit-text">{{{_highlightResult.content.value}}}</div>
        <div class="hit-tag">{{ tags }}</div>
      </div>
    </a>
  </script>
</main>
