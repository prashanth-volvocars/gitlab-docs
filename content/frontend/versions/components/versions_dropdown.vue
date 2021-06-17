<script>
import GlDropdown from '@gitlab/ui/dist/components/base/dropdown/dropdown';
import GlDropdownDivider from '@gitlab/ui/dist/components/base/dropdown/dropdown_divider';
import GlDropdownItem from '@gitlab/ui/dist/components/base/dropdown/dropdown_item';
import GlLink from '@gitlab/ui/dist/components/base/link/link';

const URI = 'https://gitlab.com/api/v4/projects/278964/releases';

export default {
  components: {
    GlDropdown,
    GlDropdownItem,
    GlDropdownDivider,
    GlLink
  },
  inject: {
    identifier: {
      type: String,
      default: '',
    },
  },
  data() {
    return {
      versions: [],
    };
  },
  mounted() {
    this.fetchVersions();
  },
  methods: {
    fetchVersions() {
      fetch(URI, {})
      .then(response => response.json())
       // eslint-disable-next-line no-return-assign
      .then(data => this.versions = data.map(({ name }) => name.split(' ')[1]))
      .catch((error) => {
        console.error('Error:', error);
      });
    },
  }
};
</script>

<template>
  <div class="d-flex justify-content-center">
    <gl-dropdown text="Versions" toggle-class="text-white">
      <gl-dropdown-item v-for="version in versions.slice(0,5)" :key="version"><gl-link :href="version">{{ version }}</gl-link></gl-dropdown-item>
      <gl-dropdown-divider />
      <gl-dropdown-item><gl-link href="/archives/">Archives</gl-link></gl-dropdown-item>
    </gl-dropdown>
  </div>
</template>
