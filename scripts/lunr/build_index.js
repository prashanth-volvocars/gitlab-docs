#!/usr/bin/env node

/*
 * This script is copied from
 * https://lunrjs.com/guides/index_prebuilding.html,
 * with custom field elements for GitLab Docs.
 */

var lunr = require('lunr'),
  stdin = process.stdin,
  stdout = process.stdout,
  buffer = [];

stdin.resume();
stdin.setEncoding('utf8');

stdin.on('data', function (data) {
  buffer.push(data);
});

stdin.on('end', function () {
  var documents = JSON.parse(buffer.join(''));

  var idx = lunr(function () {
    this.ref('id');
    /* Custom fields */
    this.field('h1', { boost: 10 });
    this.field('h2', { boost: 5 });
    this.field('h3', { boost: 2 });

    documents.forEach(function (doc) {
      this.add(doc);
    }, this);
  });

  stdout.write(JSON.stringify(idx));
});
