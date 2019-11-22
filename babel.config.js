module.exports = {
  env: {
    development: {
      presets: [
        [
          '@babel/preset-env',
          {
            targets: {
              ie: '11',
            },
          },
        ],
      ],
    },
    test: {
      presets: [
        [
          '@babel/preset-env',
          {
            targets: {
              node: 'current',
            },
          },
        ],
      ],
    },
  },
};
