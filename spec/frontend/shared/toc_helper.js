export const createItem = (text, items = []) => ({
  text,
  href: `#${text.replace(/[^a-zA-Z-]+/g, '-').toLowerCase()}`,
  id: `${text}-anchor`,
  items,
});

export const buildHTML = (list) =>
  list
    .map(
      ({ text, href, id, items }) =>
        `<li>
${text ? `<a href="${href}" id="${id}">${text}</a>` : ''}
${items?.length ? `<ul>${buildHTML(items)}</ul>` : ''}
</li>`,
    )
    .join('');

export const createTOCElement = (list) => {
  const ul = document.createElement('ul');
  ul.innerHTML = buildHTML(list);
  return ul;
};

export const createExampleToc = () => [
  createItem('Lorem', [createItem('Lorem 2')]),
  createItem('Ipsum', [
    createItem('Dolar', [createItem('Sit'), createItem('Amit'), createItem('Test')]),
  ]),
];
