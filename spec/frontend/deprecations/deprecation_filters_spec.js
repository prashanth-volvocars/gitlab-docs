/**
 * @jest-environment jsdom
 */

import { mount } from '@vue/test-utils';
import DeprecationFilters from '../../../content/frontend/deprecations/components/deprecation_filters.vue';

const propsData = { showAllText: 'Show all', milestonesList: [] };
const removalsFilterSelector = '[data-testid="removal-milestone-filter"]';

describe('component: Deprecations Filter', () => {
  it('Filter is visible', () => {
    const wrapper = mount(DeprecationFilters, { propsData });
    expect(wrapper.find(removalsFilterSelector).isVisible()).toBe(true);
  });
});
