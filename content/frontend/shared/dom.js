/* global $ */

/**
 * Returns outerHeight of element **even if it's hidden**
 *
 * NOTE: Uses jQuery because there is no trivial way to do this in
 * vaniall JS, and it's nice that jQuery has a reliable out-of-the-box
 * solution.
 *
 * @param {Element} el
 */
export const getOuterHeight = (el) => $(el).outerHeight();

/**
 * Find the first child of the given element with the given tag name
 *
 * @param {Element} el
 * @param {String} tagName
 * @returns {Element | null} Returns first child that matches the given tagName (or null if not found)
 */
export const findChildByTagName = (el, tagName) =>
  Array.from(el.childNodes).find((x) => x.tagName === tagName.toUpperCase());
