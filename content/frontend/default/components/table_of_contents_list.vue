<script>
export default {
  name: 'TableOfContentsList',
  props: {
    items: {
      type: Array,
      required: true,
    },
  },
};
</script>
<template>
  <ul class="nav nav-pills flex-column">
    <li v-for="(item, index) in items" :key="`${item.text}_${index}`">
      <a :id="item.id" class="nav-link" :href="item.href">{{ item.text }}</a>
      <table-of-contents-list v-if="item.items && item.items.length" :items="item.items" />
    </li>
  </ul>
</template>
