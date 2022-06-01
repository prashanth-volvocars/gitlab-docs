#!/usr/bin/env node

/**
 * Create a JSON string of all content pages.
 * This is used to prebuild the LunrJS search index.
 */

const cheerio = require('cheerio');
const fs = require('fs');
const glob = require('glob');

const outputDir = 'public/';
let results = [];

const getFiles = (src, callback) => {
  glob(src + '/**/*.html', callback);
};

const getPageTitle = (file) => {
  let $ = cheerio.load(fs.readFileSync(file));
  return $('h1').text().replace('\n', '');
};

getFiles(outputDir, function (err, filenames) {
  if (err) {
    console.log('Error', err);
  } else {
    for (const file of filenames) {
      let pageTitle = getPageTitle(file);
      if (pageTitle) {
        results.push({
          id: file.slice(outputDir.length),
          title: pageTitle,
        });
      }
    }
    console.log(JSON.stringify(results));
  }
});
