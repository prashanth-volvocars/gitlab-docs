<script>
import { GlDropdown, GlDropdownItem, GlDropdownDivider } from '@gitlab/ui';
import versionsData from '../../../versions.json';

export default {
  components: {
    GlDropdown,
    GlDropdownItem,
    GlDropdownDivider,
  },
  data() {
    return {
      versions: versionsData[0],
    };
  },
};
</script>

<template>
  <gl-dropdown text="Versions" size="medium">
    <gl-dropdown-item>GitLab.com ({{ versions.latest }})</gl-dropdown-item>
    <gl-dropdown-divider />
    <gl-dropdown-item v-for="v in versions.online" :key="v">{{ v }}</gl-dropdown-item>
    <gl-dropdown-divider />
    <gl-dropdown-item v-for="v in versions.last_major" :key="v">{{ v }}</gl-dropdown-item>
    <gl-dropdown-divider />
    <gl-dropdown-item>Archives</gl-dropdown-item>
  </gl-dropdown>
</template>
