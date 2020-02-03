const importResolver = require('rollup-plugin-import-resolver');
const commonjs = require('rollup-plugin-commonjs');
const vue = require('rollup-plugin-vue');
const babel = require('rollup-plugin-babel');
const glob = require('glob');

function mapDirectory(file) {
  return file.replace('content/', 'public/');
}

module.exports = glob.sync('content/frontend/bundles/*.js').map(file => ({
  input: file,
  output: {
    file: mapDirectory(file),
    format: 'iife',
    name: file,
  },
  plugins: [
    commonjs(),
    babel(),
    vue(),
    importResolver({
      alias: {
        vue: './node_modules/vue/dist/vue.esm.browser.min.js',
      },
    }),
  ],
}));
