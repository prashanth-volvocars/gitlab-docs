/**
 * @jest-environment jsdom
 */

import { mount } from '@vue/test-utils';
import NavigationToggle from '../../../../content/frontend/default/components/navigation_toggle.vue';

describe('component: Navigation Toggle', () => {
  let wrapper;
  const className = 'some-selector';

  beforeEach(() => {
    const propsData = { targetSelector: [`.${className}`] };

    document.body.innerHTML = `<div class="${className}"></div>`;
    wrapper = mount(NavigationToggle, { propsData });
  });

  it('renders a toggle button', () => {
    expect(wrapper.exists('.nav-toggle')).toBe(true);
  });

  it('renders a toggle label', () => {
    expect(wrapper.find('.label').text()).toEqual('Collapse sidebar');
  });

  it('renders two arrow icons', () => {
    expect(wrapper.findAll('.arrow').length).toEqual(2);
  });

  it('toggles the navigation when the navigation toggle is clicked', () => {
    const findMenu = () => document.querySelector(`.${className}`);
    jest.spyOn(findMenu().classList, 'toggle');

    wrapper.find('.nav-toggle').trigger('click');
    expect(findMenu().classList.toggle).toHaveBeenCalledWith('active');
  });
});
