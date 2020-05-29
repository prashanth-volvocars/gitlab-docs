import { flattenItems } from '../../../../content/frontend/shared/toc/flatten_items';

describe('shared/toc/flatten_items', () => {
  const createItem = (text, ...items) => Object.assign({ text }, items ? { items } : {});
  const createItemWithLevel = (text, level) => ({ text, level });

  it.each`
    desc                        | items                                  | expected
    ${'empty'}                  | ${[]}                                  | ${[]}
    ${'single item'}            | ${[createItem('a')]}                   | ${[createItemWithLevel('a', 0)]}
    ${'single item with child'} | ${[createItem('a', createItem('a1'))]} | ${[createItemWithLevel('a', 0), createItemWithLevel('a1', 1)]}
  `('with items is $desc and level=$level', ({ items, expected }) => {
    expect(flattenItems(items)).toEqual(expected);
  });

  it('with multiple items', () => {
    const items = [
      createItem('a', createItem('a1')),
      createItem('b'),
      createItem('c', createItem('c1'), createItem('c2', createItem('c21')), createItem('c3')),
    ];

    const expectedItems = [
      createItemWithLevel('a', 1),
      createItemWithLevel('a1', 2),
      createItemWithLevel('b', 1),
      createItemWithLevel('c', 1),
      createItemWithLevel('c1', 2),
      createItemWithLevel('c2', 2),
      createItemWithLevel('c21', 3),
      createItemWithLevel('c3', 2),
    ];

    expect(flattenItems(items, 1)).toEqual(expectedItems);
  });
});
