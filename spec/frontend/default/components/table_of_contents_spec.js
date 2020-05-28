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
  const findCollapseIcon = () => findCollapseButton().find('i');
  const findCollapsibleContainer = () => wrapper.find('[data-testid="container"]');
  const findMainList = () => wrapper.find('[data-testid="main-list"]');
  const findMainListItems = () => findMainList().props('items');
  const clickCollapseButton = () => findCollapseButton().trigger('click');

  const expectCollapsed = (isCollapsed = true) => {
    expect(findCollapseButton().attributes('aria-expanded')).toBe(isCollapsed ? undefined : 'true');
    expect(findCollapsibleContainer().props('isCollapsed')).toBe(isCollapsed);
    expect(findCollapseIcon().classes(isCollapsed ? 'fa-angle-right' : 'fa-angle-down')).toBe(true);
  };

  it('matches snapshot', () => {
    createComponent({ hasHelpAndFeedback: true }, mount);
    expect(wrapper.element).toMatchSnapshot();
  });

  describe('with hasHelpAndFeedback', () => {
    beforeEach(() => {
      createComponent({ hasHelpAndFeedback: true });
    });

    it('appends help and feedback item', () => {
      expect(findMainListItems()).toEqual(
        TEST_ITEMS.concat([
          {
            href: `#${TEST_HELP_AND_FEEDBACK_ID}`,
            id: null,
            items: [],
            text: 'Help and feedback',
            withSeparator: true,
          },
        ]),
      );
    });
  });

  describe('default', () => {
    beforeEach(() => {
      createComponent({}, mount);
    });

    it('renders toc list', () => {
      expect(findMainListItems()).toEqual(TEST_ITEMS);
    });

    it('is initially uncollapsed', () => {
      expectCollapsed(false);
    });

    describe('when collapse button is pressed', () => {
      beforeEach(() => {
        clickCollapseButton();
      });

      it('starts expanding', () => {
        expect(findCollapsibleContainer().classes('sm-collapsing')).toBe(true);
      });

      it('immediately updates collapse status', () => {
        expectCollapsed(true);
      });

      it('when button pressed again, nothing happens because in the middle of collapsing', () => {
        clickCollapseButton();

        return wrapper.vm.$nextTick(() => {
          expect(findCollapsibleContainer().classes('sm-collapsing')).toBe(true);
          expectCollapsed(true);
        });
      });
    });
  });
});
