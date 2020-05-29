/* eslint-disable import/prefer-default-export */
import { findChildByTagName } from '../dom';

const TAG_LI = 'LI';
const TAG_A = 'A';
const TAG_UL = 'UL';

/**
 * Parses the given HTML Table of Contents into a data structure
 *
 * ```
 * type Item = { text: String, href: String, id: String, items: Item[] }
 *
 * parseTOC: Element => Item[]
 * ```
 *
 * @param {Element} menu Parent <ul> element
 */
export const parseTOC = menu => {
  const items = [];

  if (!menu) {
    return items;
  }

  menu.childNodes.forEach(li => {
    if (li.tagName !== TAG_LI) {
      return;
    }

    const link = findChildByTagName(li, TAG_A);
    const subMenu = findChildByTagName(li, TAG_UL);

    if (!link) {
      return;
    }

    const item = {
      text: link.textContent,
      href: link.getAttribute('href'),
      id: link.id,
      items: parseTOC(subMenu),
    };

    items.push(item);
  });

  return items;
};
