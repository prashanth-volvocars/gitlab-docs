<script>
export default {
  props: {
    isOutdated: {
      type: Boolean,
      required: true,
    },
    latestVersionUrl: {
      type: String,
      required: true,
    },
    archivesUrl: {
      type: String,
      required: true,
    },
  },
};
</script>

<template>
  <div v-if="isOutdated" class="version-banner position-fixed w-100 text-center">
    This is <a :href="archivesUrl">archived documentation</a> for GitLab. Go to <a :href="latestVersionUrl">the latest</a>.
  </div>
</template>
