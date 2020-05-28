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
  const findLinks = () => wrapper.findAll('a');
  const findListItems = () => wrapper.findAll('li');

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

    it('starts at level 0', () => {
      expect(
        findLinks()
          .at(0)
          .classes('toc-level-0'),
      ).toBe(true);
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

  describe('with level', () => {
    beforeEach(() => {
      createComponent({
        items: [
          {
            text: 'A',
            items: [{ text: 'A_1' }, { text: 'A_2' }],
          },
          {
            text: 'B',
            items: [{ text: 'B_1', items: [{ text: 'B_1_1' }] }],
          },
        ],
        level: 1,
      });
    });

    it('increments levels for nested lists', () => {
      // Order isn't important. We just want to find the link + level class mapping
      const data = findLinks().wrappers.reduce(
        (acc, link) =>
          Object.assign(acc, {
            [link.text()]: link.classes().find(x => x.startsWith('toc-level')),
          }),
        {},
      );

      expect(data).toEqual({
        A: 'toc-level-1',
        A_1: 'toc-level-2',
        A_2: 'toc-level-2',
        B: 'toc-level-1',
        B_1: 'toc-level-2',
        B_1_1: 'toc-level-3',
      });
    });
  });

  describe('with separator', () => {
    beforeEach(() => {
      createComponent({
        items: [
          {
            text: 'Lorem',
          },
          {
            text: 'Ipsum',
            withSeparator: true,
          },
        ],
      });
    });

    it('has separator class for separator item', () => {
      const data = findListItems().wrappers.map(x => ({
        text: x.text(),
        hasSeparator: x.classes('toc-separator'),
      }));

      expect(data).toEqual([
        { text: 'Lorem', hasSeparator: false },
        { text: 'Ipsum', hasSeparator: true },
      ]);
    });
  });
});
