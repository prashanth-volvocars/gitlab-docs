const replace = require('@rollup/plugin-replace');
const { nodeResolve } = require('@rollup/plugin-node-resolve');
const nodePolyfills = require('rollup-plugin-node-polyfills');
const importResolver = require('rollup-plugin-import-resolver');
const commonjs = require('rollup-plugin-commonjs');
const vue = require('rollup-plugin-vue');
const babel = require('rollup-plugin-babel');
const json = require('@rollup/plugin-json');
const glob = require('glob');

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
    nodeResolve({ browser: true, preferBuiltins: true }),
    commonjs(),
    nodePolyfills(),
    babel({
      exclude: 'node_modules/**',
    }),
    json(),
    vue(),
    importResolver({
      alias: {
        vue: './node_modules/vue/dist/vue.esm.browser.min.js',
      },
    }),
    replace({
      'process.env.NODE_ENV': JSON.stringify('production'),
    }),
  ],
}));