import { shallowMount, mount } from '@vue/test-utils';
import TableOfContents from '../../../../content/frontend/default/components/table_of_contents.vue';
import * as dom from '../../../../content/frontend/shared/dom';
import { createExampleToc } from '../../shared/toc_helper';

const TEST_ITEMS = createExampleToc();
const TEST_HELP_AND_FEEDBACK_ID = 'test-help-and-feedback';

describe('frontend/default/components/table_of_contents', () => {
  let wrapper;

  afterEach(() => {
    wrapper.destroy();
    wrapper = null;
  });

  beforeEach(() => {
    // jquery is not available in Jest yet so we need to mock this method
    jest.spyOn(dom, 'getOuterHeight').mockReturnValue(100);
  });

  const createComponent = (props = {}, mountFn = shallowMount) => {
    wrapper = mountFn(TableOfContents, {
      propsData: {
        items: TEST_ITEMS,
        helpAndFeedbackId: TEST_HELP_AND_FEEDBACK_ID,
        ...props,
      },
    });
  };

  const findCollapseButton = () => wrapper.find('[data-testid="collapse"]');
  const findCollapsibleContainer = () => wrapper.find('[data-testid="container"]');
  const findMainList = () => wrapper.find('[data-testid="main-list"]');
  const findHelpAndFeedback = () => wrapper.find('[data-testid="help-and-feedback"]');
  const clickCollapseButton = () => findCollapseButton().trigger('click');

  it('matches snapshot', () => {
    createComponent({ hasHelpAndFeedback: true }, mount);
    expect(wrapper.element).toMatchSnapshot();
  });

  describe('with hasHelpAndFeedback', () => {
    beforeEach(() => {
      createComponent({ hasHelpAndFeedback: true });
    });

    it('shows help and feedback', () => {
      expect(findHelpAndFeedback().exists()).toBe(true);
      expect(findHelpAndFeedback().props('items')).toEqual([
        {
          href: `#${TEST_HELP_AND_FEEDBACK_ID}`,
          id: null,
          items: [],
          text: 'Help and feedback',
        },
      ]);
    });
  });

  describe('default', () => {
    beforeEach(() => {
      createComponent({}, mount);
    });

    it('does not show help and feedback', () => {
      expect(findHelpAndFeedback().exists()).toBe(false);
    });

    it('renders toc list', () => {
      expect(findMainList().props('items')).toEqual(TEST_ITEMS);
    });

    it('is initially collapsed', () => {
      expect(findCollapseButton().classes('collapsed')).toBe(true);
      expect(findCollapsibleContainer().classes('sm-collapsed')).toBe(true);
    });

    describe('when collapse button is pressed', () => {
      beforeEach(() => {
        clickCollapseButton();
      });

      it('starts expanding', () => {
        expect(findCollapsibleContainer().classes('sm-collapsing')).toBe(true);
      });

      it('updates button class', () => {
        expect(findCollapseButton().classes('collapsed')).toBe(false);
      });

      it('when button pressed again, nothing happens because in the middle of collapsing', () => {
        clickCollapseButton();

        return wrapper.vm.$nextTick(() => {
          expect(findCollapsibleContainer().classes('sm-collapsing')).toBe(true);
          expect(findCollapseButton().classes('collapsed')).toBe(false);
        });
      });
    });
  });
});
