const json = require('@rollup/plugin-json');
const glob = require('glob');
const babel = require('rollup-plugin-babel');
const commonjs = require('rollup-plugin-commonjs');
const importResolver = require('rollup-plugin-import-resolver');
const vue = require('rollup-plugin-vue');

function mapDirectory(file) {
  return file.replace('content/', 'public/');
}

module.exports = glob.sync('content/frontend/**/*.js').map((file) => ({
  input: file,
  output: {
    file: mapDirectory(file),
    format: 'iife',
    name: file,
  },
  plugins: [
    commonjs(),
    babel(),
    json(),
    vue(),
    importResolver({
      alias: {
        vue: './node_modules/vue/dist/vue.esm.browser.min.js',
      },
    }),
  ],
}));
