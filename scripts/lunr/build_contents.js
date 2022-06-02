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

const getFiles = (src, callback) => {
  glob(`${src}/**/*.html`, callback);
};

const getPageTitle = (file) => {
  const $ = cheerio.load(fs.readFileSync(file));
  return $('h1').text().replace('\n', '');
};

getFiles(outputDir, function addPage(err, filenames) {
  if (err) {
    // eslint-disable-next-line no-console
    console.log('Error', err);
  } else {
    Object.keys(filenames).forEach((key) => {
      const pageTitle = getPageTitle(filenames[key]);
      if (pageTitle) {
        results.push({
          id: filenames[key].slice(outputDir.length),
          title: pageTitle,
        });
      }
    });
    // eslint-disable-next-line no-console
    console.log(JSON.stringify(results));
  }
});
