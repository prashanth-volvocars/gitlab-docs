import { findChildByTagName } from '../../../content/frontend/shared/dom';

describe('frontend/shared/dom', () => {
  const createElementWithChildren = children => {
    const el = document.createElement('div');

    children.forEach(tag => {
      const child = document.createElement(tag);
      el.appendChild(child);
    });

    return el;
  };

  describe('findChildByTagName', () => {
    it.each`
      children                   | tagName | expectedIndex
      ${['div', 'p', 'ul', 'p']} | ${'p'}  | ${1}
      ${['div', 'ul']}           | ${'p'}  | ${-1}
      ${['li', 'li', 'li']}      | ${'li'} | ${0}
      ${[]}                      | ${'li'} | ${-1}
    `(
      'with children $children and $tagName, returns $expectedIndex child',
      ({ children, tagName, expectedIndex }) => {
        const el = createElementWithChildren(children);
        const expectedChild = el.childNodes[expectedIndex];

        expect(findChildByTagName(el, tagName)).toBe(expectedChild);
      },
    );
  });
});
