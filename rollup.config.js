const inject = require('@rollup/plugin-inject');
const json = require('@rollup/plugin-json');
const { nodeResolve } = require('@rollup/plugin-node-resolve');
const replace = require('@rollup/plugin-replace');
const glob = require('glob');
const commonjs = require('@rollup/plugin-commonjs');
const { babel } = require('@rollup/plugin-babel');
const importResolver = require('rollup-plugin-import-resolver');
const css = require('rollup-plugin-import-css');
const image = require('@rollup/plugin-image');
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
    nodeResolve({ browser: true, preferBuiltins: false }),
    commonjs({
      requireReturnsDefault: 'preferred',
    }),
    vue(),
    image(),
    inject({
      exclude: 'node_modules/**',
    }),
    babel({
      exclude: 'node_modules/**',
      babelHelpers: 'bundled',
    }),
    json(),
    css(),
    importResolver({
      alias: {
        vue: './node_modules/vue/dist/vue.esm.browser.min.js',
      },
    }),
    replace({
      preventAssignment: true,
      'process.env.NODE_ENV': JSON.stringify('production'),
    }),
  ],
}));
