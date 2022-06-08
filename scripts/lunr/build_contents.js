#!/usr/bin/env node

/**
 * Create a JSON string of all content pages.
 * This is used to prebuild the LunrJS search index.
 */

const fs = require('fs');
const cheerio = require('cheerio');
const glob = require('glob');

const outputDir = 'public/';
const results = [];

const getContent = (src, callback) => {
  glob(`${src}/**/*.html`, callback);
};

/**
 * Extracts text from HTML heading elements.
 *
 * When multiple headings of a given type are present,
 * these are appended together and returned as a single string.
 *
 * @param {String} file
 *   Path to an HTML file.
 * @param {String} heading
 *   Heading level (e.g, 'h1').
 * @return {String}
 *   Text from the HTML document that is marked up at this heading level.
 */
const getHeadings = (file, heading) => {
  let headingText = '';
  const $ = cheerio.load(fs.readFileSync(file));

  $(heading).map((_, element) => {
    headingText += $(element).text().replace('\n', '') + ' ';
  });
  return headingText;
};

/**
 * Extracts heading text from a page.
 *
 * @param {string} file
 *   Path to an HTML file.
 * @return {Object}
 *   Page content object, structured for LunrJS indexing.
 */
const getText = (file) => {
  return {
    h1: getHeadings(file, 'h1'),
    h2: getHeadings(file, 'h2'),
    h3: getHeadings(file, 'h3'),
  };
};

/**
 *
 * @param {$} heading
 * @returns {String}
 */
getContent(outputDir, function addPage(err, filenames) {
  if (err) {
    // eslint-disable-next-line no-console
    console.log('Error', err);
  } else {
    Object.keys(filenames).forEach((key) => {
      let content = getText(filenames[key]);
      if (content.h1) {
        results.push({
          id: filenames[key].slice(outputDir.length),
          h1: content.h1,
          h2: content.h2,
          h3: content.h3,
        });
      }
    });
    // eslint-disable-next-line no-console
    console.log(JSON.stringify(results));
  }
});
