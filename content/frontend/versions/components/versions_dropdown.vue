<script>
import GlDropdown from '@gitlab/ui/dist/components/base/dropdown/dropdown';
import GlDropdownItem from '@gitlab/ui/dist/components/base/dropdown/dropdown_item';
import GlLink from '@gitlab/ui/dist/components/base/link/link';

const URI = 'https://gitlab.com/api/v4/projects/278964/releases';

export default {
  components: {
    GlDropdown,
    GlDropdownItem,
    GlLink
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
    <gl-dropdown text="Some dropdown">
      <gl-dropdown-item v-for="version in versions" :key="version"><gl-link :href="version">{{ version }}</gl-link></gl-dropdown-item>
    </gl-dropdown>
  </div>
</template>
