/**
 * @jest-environment jsdom
 */

import { mount } from '@vue/test-utils';
import Banner from '../../../../content/frontend/shared/components/banner.vue';

const propsData = { text: 'Some text', show: true };

describe('component: Banner', () => {
  let wrapper;

  beforeEach(() => {
    wrapper = mount(Banner, { propsData });
  });

  it('renders a banner', () => {
    expect(wrapper.exists('.banner')).toBe(true);
  });

  it('renders the correct banner text', () => {
    const bannerText = wrapper.find('span');
    expect(bannerText.text()).toEqual(propsData.text);
  });

  it('renders a close button', () => {
    expect(wrapper.exists('.btn-close')).toBe(true);
  });

  it('emits a toggle event on mount', () => {
    expect(wrapper.emitted('toggle')[0]).toEqual([true]);
  });

  it('emits a toggle event when the close button is clicked', () => {
    const closeBtn = wrapper.find('.btn-close');
    closeBtn.trigger('click');
    expect(wrapper.emitted('toggle')[1]).toEqual([false]);
  });
});
