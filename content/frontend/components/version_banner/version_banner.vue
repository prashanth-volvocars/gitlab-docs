<script>
import Banner from '../banner/banner.vue';

export default {
  components: {
    Banner,
  },
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
  methods: {
    toggleVersionBanner(isVisible) {
      this.$emit('toggleVersionBanner', isVisible);
    }
  },
};
</script>

<template>
  <banner :show="isOutdated" @toggle="toggleVersionBanner">
    This is <a :href="archivesUrl">archived documentation</a> for GitLab. Go to <a :href="latestVersionUrl">the latest</a>.
  </banner>
</template>
