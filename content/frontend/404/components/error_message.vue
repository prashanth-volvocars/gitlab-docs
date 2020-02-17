<script>
export default {
  props: {
    isOffline: {
      type: Boolean,
      required: true,
    },
    isProduction: {
      type: Boolean,
      required: true,
    },
    archivesPath: {
      type: String,
      required: true,
    },
  },
};
</script>

<template>
  <div>
    <h2>There's no page at this address!</h2>

    <p v-if="isProduction && isOffline" class="gray js-error-description">
      You attempted to view an older version of the documentation that is no longer available on
      this site. Please select a newer version from the menu above or access an
      <a :href="archivesPath">archive</a> of the older version.
    </p>
  </div>
</template>
