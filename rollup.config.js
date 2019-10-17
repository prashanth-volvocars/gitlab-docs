const importResolver = require('rollup-plugin-import-resolver');
const commonjs = require('rollup-plugin-commonjs');
const vue = require('rollup-plugin-vue');
const babel = require('rollup-plugin-babel');
const glob = require('glob');

module.exports = glob.sync(
  'content/frontend/bundles/*.js',
).map(file => ({
  input: file,
  output: {
    file: mapDirectory(file),
    format: 'iife',
    name: file,
  },
  plugins: [
    commonjs(),
    vue(),
    importResolver({
      alias: {
        'vue': './node_modules/vue/dist/vue.esm.browser.min.js'
      }
    }),
    babel({
      exclude: 'node_modules/**',
      babelrc: false,
      presets: ['@babel/preset-env'],
    }),
  ],
}));

function mapDirectory(file) {
  return file.replace('content/', 'public/');
}
