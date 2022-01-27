const moduleNameMapper = {
  '^~(/.*)$': '<rootDir>/content/frontend$1',
};

module.exports = {
  testMatch: ['<rootDir>/spec/frontend/**/**/*_spec.js'],
  moduleFileExtensions: ['js', 'json', 'vue'],
  moduleNameMapper,
  cacheDirectory: '<rootDir>/tmp/cache/jest',
  restoreMocks: true,
  transform: {
    '^.+\\.js$': 'babel-jest',
    '^.+\\.vue$': '@vue/vue2-jest',
    '^.+\\.svg$': '@vue/vue2-jest',
  },
  transformIgnorePatterns: ['node_modules/(?!(@gitlab/(ui|svgs)|bootstrap-vue)/)'],
};
