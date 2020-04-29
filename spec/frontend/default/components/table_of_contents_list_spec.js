import { mount } from '@vue/test-utils';
import { parseTOC } from '../../../../content/frontend/shared/dom_parse_toc';
import TableOfContentsList from '../../../../content/frontend/default/components/table_of_contents_list.vue';
import { createExampleToc } from '../../shared/toc_helper';

describe('frontend/default/components/table_of_contents_list', () => {
  let wrapper;

  const createComponent = (props = {}) => {
    wrapper = mount(TableOfContentsList, {
      propsData: {
        ...props,
      },
    });
  };

  const findItemsData = () => parseTOC(wrapper.element);

  afterEach(() => {
    wrapper.destroy();
    wrapper = null;
  });

  describe('with items', () => {
    let items;

    beforeEach(() => {
      items = createExampleToc();
      createComponent({ items });
    });

    it('renders all items', () => {
      expect(findItemsData()).toEqual(items);
    });
  });

  describe('with empty items', () => {
    beforeEach(() => {
      createComponent({ items: [] });
    });

    it('shows empty ul', () => {
      expect(wrapper.element).toMatchSnapshot();
    });
  });
});
