---
version: 1
---

var disqus_config = function () {
  this.page.url = '<%= @config[:base_url] %><%= @item.identifier.without_ext + '.html' %>';
  this.page.title = '<%= @item.key?(:title) ? "#{item[:title]} - GitLab Documentation" : "GitLab Documentation" %>';
<% if @item[:disqus_identifier] %>
  this.page.identifier = '<%= @item[:disqus_identifier] %>';
<% else %>
  this.page.identifier = '<%= @config[:base_url] %><%= @item.identifier.without_ext + '.html' %>';
<% end %>
};

var is_disqus_loaded = false;
window.loadDisqus = function() {
  if (!is_disqus_loaded){
    is_disqus_loaded = true;
    var disqusThread = document.getElementById('disqus_thread');
    var d = document, s = d.createElement('script');
    disqusThread.innerHTML = '';
    s.src = 'https://gitlab-docs.disqus.com/embed.js';
    s.setAttribute('data-timestamp', +new Date());
    (d.head || d.body).appendChild(s);
  }
};
