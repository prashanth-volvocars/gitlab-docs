<script>
import { GlFormSelect } from '@gitlab/ui';

export default {
  components: {
    GlFormSelect,
  },
  props: {
    milestonesList: {
      type: Array,
      required: true,
    },
    showAllText: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      selected: this.showAllText,
    };
  },
  methods: {
    filterDeprecationList(option) {
      const hiddenClass = 'd-none';

      // Reset the list and show all deprecations and headers.
      document.querySelectorAll('.deprecation, h2').forEach(function showAllSections(el) {
        el.classList.remove(hiddenClass);
      });

      if (option !== this.showAllText) {
        // If a removal version was selected, hide deprecations with different versions.
        document
          .querySelectorAll(`.deprecation:not(.removal-${option})`)
          .forEach(function hideDeprecationsAndHeader(el) {
            el.classList.add(hiddenClass);
            // Hide the "announcement version" section header.
            el.parentElement.children[0].classList.add(hiddenClass);
          });

        // Show the "announcement version" header if we have deprecations in this section.
        document
          .querySelectorAll(`.deprecation.removal-${option}`)
          .forEach(function showHeader(el) {
            el.parentElement.children[0].classList.remove(hiddenClass);
          });
      }
    },
  },
};
</script>

<template>
  <div class="mt-3 row">
    <div class="col-4">
      <label for="milestone" class="d-block col-form-label">Filter by removal version:</label>
      <gl-form-select
        v-model="selected"
        name="milestone"
        :options="milestonesList"
        data-testid="removal-milestone-filter"
        @change="filterDeprecationList(selected)"
      />
    </div>
  </div>
</template>
