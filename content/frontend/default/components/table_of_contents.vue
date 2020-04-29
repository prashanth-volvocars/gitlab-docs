<script>
import TableOfContentsList from './table_of_contents_list.vue';
import CollapsibleContainer from './collapsible_container.vue';

export default {
  name: 'TableOfContents',
  components: {
    CollapsibleContainer,
    TableOfContentsList,
  },
  props: {
    items: {
      type: Array,
      required: true,
    },
    helpAndFeedbackId: {
      type: String,
      required: false,
      default: '',
    },
    hasHelpAndFeedback: {
      type: Boolean,
      required: false,
      default: false,
    },
  },
  data() {
    return {
      isCollapsed: true,
    };
  },
  computed: {
    helpAndFeedbackItems() {
      return [
        {
          text: 'Help and feedback',
          href: `#${this.helpAndFeedbackId}`,
          id: null,
          items: [],
        },
      ];
    },
  },
  methods: {
    toggleCollapse() {
      this.$refs.container.collapse(!this.isCollapsed);
    },
  },
};
</script>
<template>
  <div id="markdown-toc" class="table-of-contents-container position-relative">
    <a
      class="toc-collapse"
      :class="{ collapsed: isCollapsed }"
      role="button"
      href="#"
      :aria-expanded="!isCollapsed"
      aria-controls="markdown-toc"
      data-testid="collapse"
      @click.prevent="toggleCollapse"
    ></a>
    <collapsible-container
      ref="container"
      v-model="isCollapsed"
      class="table-of-contents"
      data-testid="container"
    >
      <h4>On this page:</h4>
      <table-of-contents-list :items="items" class="my-0" data-testid="main-list" />
      <div v-if="hasHelpAndFeedback" class="border-top mt-3 pt-3">
        <table-of-contents-list
          :items="helpAndFeedbackItems"
          class="my-0"
          data-testid="help-and-feedback"
        />
      </div>
    </collapsible-container>
  </div>
</template>
