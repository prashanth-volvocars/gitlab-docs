---
version: 2
---

function loadMermaidJsIfNeeded() {
    if (document.querySelector('.mermaid') === null) {
        return;
    }

    var element = document.createElement("script");
    element.src = "https://cdnjs.cloudflare.com/ajax/libs/mermaid/8.9.2/mermaid.min.js";
    element.onload = function(){mermaid.init();};
    document.body.appendChild(element);
}

if (window.addEventListener)
    window.addEventListener("load", loadMermaidJsIfNeeded, false);
else if (window.attachEvent)
    window.attachEvent("onload", loadMermaidJsIfNeeded);
else window.onload = loadMermaidJsIfNeeded;
