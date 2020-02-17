import { mount } from '@vue/test-utils';
import ErrorMessage from '../../../../content/frontend/404/components/error_message.vue';

const propsData = { isProduction: true, isOffline: false, archivesPath: '/archives/' };

describe('component: Error Message', () => {
  let wrapper;

  beforeEach(() => {
    wrapper = mount(ErrorMessage, { propsData });
  });

  it('renders a heading with correct text', () => {
    expect(wrapper.find('h2').exists()).toBe(true);
    expect(wrapper.find('h2').text()).toEqual("There's no page at this address!");
  });

  it('does not render an error description if not offline', () => {
    expect(wrapper.find('.js-error-description').exists()).toBe(false);
  });

  it('renders an error description if isOffline is true', () => {
    wrapper = mount(ErrorMessage, { propsData: { ...propsData, isOffline: true } });
    expect(wrapper.find('.js-error-description').exists()).toBe(true);
    expect(wrapper.find('.js-error-description a').exists()).toBe(true);
  });
});
