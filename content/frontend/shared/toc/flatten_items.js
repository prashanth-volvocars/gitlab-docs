// eslint-disable-next-line import/prefer-default-export
export const flattenItems = (items = [], level = 0) => {
  if (!items || !items.length) {
    return items;
  }

  return items.reduce(
    (acc, { items: children, ...item }) =>
      acc.concat([{ ...item, level }]).concat(flattenItems(children, level + 1)),
    [],
  );
};
