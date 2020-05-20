import { parseTOC } from '../../../content/frontend/shared/dom_parse_toc';
import { createItem, createTOCElement, createExampleToc } from './toc_helper';

describe('frontend/shared/dom_parse_toc', () => {
  it('parses nested HTML list', () => {
    const list = createExampleToc();
    const el = createTOCElement(list);

    expect(parseTOC(el)).toEqual(list);
  });

  it('skips items that do not have links', () => {
    const list = [createItem('Lorem'), { items: [createItem('no link')] }, createItem('Ipsum')];
    const el = createTOCElement(list);

    expect(parseTOC(el)).toEqual([createItem('Lorem'), createItem('Ipsum')]);
  });
});
