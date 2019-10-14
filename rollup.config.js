const commonjs = require('rollup-plugin-commonjs');
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
    babel({
      exclude: 'node_modules/**',
      babelrc: false,
      presets: ["@babel/preset-env"],
    }),
  ]
}));

function mapDirectory(file) {
  return file.replace('content/', 'public/');
}
