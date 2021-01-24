import Vue from 'vue';
import Breadcrumbs from './components/breadcrumbs.vue';

document.addEventListener('DOMContentLoaded', () => {
  const el = document.querySelector('#js-breadcrumbs');
  const { items } = el.dataset;

  // eslint-disable-next-line no-new
  new Vue({
    el,
    components: {
      Breadcrumbs,
    },
    render(createElement) {
      return createElement(Breadcrumbs, {
        props: {
          items,
        },
      });
    },
  });
});


// <% if @config[:breadcrumbs] %>
//   <% ancestor_array = ancestor_path_array(@item) unless ancestor_path_array(@item).empty? %>
//     <% if ancestor_array %>
//     <ul class="breadcrumbs" id="breadcrumbs">
//       <% ancestor_array.reverse_each do |item| %>
//       <li class="breadcrumb"><%= link_to item.key?(:title) ? "#{item[:title]}" : "Breadcrumb", item %></li>
//       <% end %>
//       <li class="breadcrumb"><%= @item.key?(:title) ? "#{@item[:title]}" : "Current page" %></li>
//     </ul>
//     <% else %>
//     <div class="pt-5"></div>
//   <% end %>
// <% end %>