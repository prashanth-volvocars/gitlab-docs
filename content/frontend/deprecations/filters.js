import Vue from 'vue';
import compareVersions from 'compare-versions';
import DeprecationFilters from './components/deprecation_filters.vue';

/**
 * Builds an ordered array of removal milestones from page content.
 * @param {String} showAllText
 * @return {Array}
 */
const buildMilestonesList = (showAllText) => {
  let milestones = [];
  document.querySelectorAll('.removal-milestone').forEach(function addOption(el) {
    if (!milestones.includes(el.innerText)) {
      milestones.push(el.innerText);
    }
  });
  milestones.sort(compareVersions).reverse();
  milestones = milestones.map(function addValues(el) {
    return { value: el.replaceAll('.', ''), text: el };
  });
  milestones.unshift({ value: showAllText, text: showAllText });
  return milestones;
};

document.addEventListener('DOMContentLoaded', () => {
  const showAllText = 'Show all';
  const milestonesList = buildMilestonesList(showAllText);

  return new Vue({
    el: '.js-deprecation-filters',
    components: {
      DeprecationFilters,
    },
    render(createElement) {
      return createElement(DeprecationFilters, {
        props: {
          milestonesList,
          showAllText,
        },
      });
    },
  });
});
