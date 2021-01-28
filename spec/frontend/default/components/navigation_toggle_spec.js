import { mount } from '@vue/test-utils';
import NavigationToggle from '../../../../content/frontend/default/components/navigation_toggle.vue';

describe('component: Navigation Toggle', () => {
  let wrapper;

  beforeEach(() => {
    const propsData = { targetSelector: ['.some-selector'] };
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
    wrapper.setMethods({ toggle: jest.fn() });
    wrapper.find('.nav-toggle').trigger('click');
    expect(wrapper.vm.toggle).toHaveBeenCalled();
  });
});
