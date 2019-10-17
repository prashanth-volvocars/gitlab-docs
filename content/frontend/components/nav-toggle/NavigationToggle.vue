<script>
export default {
  props: {
    targetSelector: {
      type: String,
      required: true,
    },
  },
  methods: {
    toggle() {
      const target = document.querySelector(this.targetSelector);

      if(!target) {
        console.warn('No target found for selector > ', this.targetSelector);
        return;
      }

      target.classList.toggle('active');
    }
  },
};
</script>

<template>
  <button type="button" class="btn nav-toggle" @click="toggle">
    <!--
    TODO: Replace arrows with 'angle-double-right' icon using the icon component from gitlab-ui
          We'll do this once https://gitlab.com/gitlab-org/gitlab-ui/issues/98 is complete.
          Issue to add gitlab-ui to this project: https://gitlab.com/gitlab-org/gitlab-docs/issues/443
    -->
    <span class="arrow"></span>
    <span class="arrow"></span>
    <div class="label">Collapse sidebar</div>
  </button>
</template>
