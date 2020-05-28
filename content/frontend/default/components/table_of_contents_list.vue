<script>
export default {
  name: 'TableOfContentsList',
  props: {
    items: {
      type: Array,
      required: true,
    },
    level: {
      type: Number,
      required: false,
      default: 0,
    },
  },
  computed: {
    levelClass() {
      return `toc-level-${this.level}`;
    },
  },
};
</script>
<template>
  <ul class="nav nav-pills flex-column">
    <li
      v-for="(item, index) in items"
      :key="`${item.text}_${index}`"
      :class="{ 'toc-separator': item.withSeparator }"
    >
      <a :id="item.id" class="nav-link d-block" :href="item.href" :class="levelClass">{{
        item.text
      }}</a>
      <table-of-contents-list
        v-if="item.items && item.items.length"
        :items="item.items"
        :level="level + 1"
      />
    </li>
  </ul>
</template>
