/**
 * @jest-environment jsdom
 */

import { shallowMount } from '@vue/test-utils';
import CollapsibleContainer from '../../../../content/frontend/default/components/collapsible_container.vue';
import * as dom from '../../../../content/frontend/shared/dom';

const TEST_COLLAPSING_CLASS = 'test-collapsing';
const TEST_COLLAPSED_CLASS = 'test-collapsed';
const TEST_SLOT = 'Lorem ipsum dolar sit amit';
const TEST_OUTER_HEIGHT = 400;
const KICKOFF_DELAY = 50;
const FINISH_DELAY = 400;

describe('frontend/default/components/collapsible_container', () => {
  let wrapper;

  beforeEach(() => {
    // jquery is not available in Jest yet so we need to mock this method
    jest.spyOn(dom, 'getOuterHeight').mockImplementation((x) => Number(x.dataset.testOuterHeight));
    jest.useFakeTimers();
  });

  afterEach(() => {
    wrapper.destroy();
    wrapper = null;

    jest.useRealTimers();
  });

  const createComponent = (props = {}) => {
    wrapper = shallowMount(CollapsibleContainer, {
      propsData: {
        collapsingClass: TEST_COLLAPSING_CLASS,
        collapsedClass: TEST_COLLAPSED_CLASS,
        ...props,
      },
      slots: {
        default: TEST_SLOT,
      },
      attrs: {
        'data-test-outer-height': TEST_OUTER_HEIGHT.toString(),
      },
    });
  };
  const findStyleHeight = () => wrapper.element.style.height;
  const waitForKickoff = () => jest.advanceTimersByTime(KICKOFF_DELAY);
  const waitForTransition = () => jest.advanceTimersByTime(FINISH_DELAY - KICKOFF_DELAY);

  describe.each`
    isCollapsed | startHeight          | endHeight            | startClasses              | endClasses
    ${true}     | ${0}                 | ${TEST_OUTER_HEIGHT} | ${[TEST_COLLAPSED_CLASS]} | ${[]}
    ${false}    | ${TEST_OUTER_HEIGHT} | ${0}                 | ${[]}                     | ${[TEST_COLLAPSED_CLASS]}
  `(
    'when isCollapsed = $isCollapsed',
    ({ isCollapsed, startHeight, endHeight, startClasses, endClasses }) => {
      beforeEach(() => {
        createComponent({ isCollapsed });

        return wrapper.vm.$nextTick();
      });

      it('renders slot', () => {
        expect(wrapper.text()).toBe(TEST_SLOT);
      });

      it('has starting classes', () => {
        expect(wrapper.classes()).toEqual(startClasses);
      });

      it('has not emitted anything', () => {
        expect(wrapper.emitted()).toEqual({});
      });

      describe('when collapse is triggered', () => {
        beforeEach(() => {
          wrapper.vm.collapse(!isCollapsed);

          // set props because this is what would naturally happen with `v-model`
          wrapper.setProps({ isCollapsed: !isCollapsed });
        });

        it('has collapsing class', () => {
          expect(wrapper.classes()).toEqual([TEST_COLLAPSING_CLASS]);
        });

        it('emits change', () => {
          expect(wrapper.emitted().change).toEqual([[!isCollapsed]]);
        });

        it('sets starting height', () => {
          expect(findStyleHeight()).toEqual(`${startHeight}px`);
        });

        it('triggering collapse again does not do anything', () => {
          wrapper.vm.collapse(isCollapsed);

          expect(wrapper.emitted().change).toEqual([[!isCollapsed]]);
        });

        describe('after animation kickoff delay', () => {
          beforeEach(() => {
            waitForKickoff();
          });

          it('sets ending height', () => {
            expect(findStyleHeight()).toEqual(`${endHeight}px`);
          });

          describe('after transition', () => {
            beforeEach(() => {
              waitForTransition();
            });

            it('does not set height', () => {
              expect(findStyleHeight()).toBe('');
            });

            it('sets ending classes', () => {
              expect(wrapper.classes()).toEqual(endClasses);
            });
          });
        });
      });
    },
  );
});
