const moduleNameMapper = {
  '^~(/.*)$': '<rootDir>/content/frontend$1',
};

module.exports = {
  testMatch: ['<rootDir>/spec/javascripts/**/**/*_spec.js'],
  moduleFileExtensions: ['js', 'json', 'vue'],
  moduleNameMapper,
  cacheDirectory: '<rootDir>/tmp/cache/jest',
  restoreMocks: true,
  transform: {
    '^.+\\.js$': 'babel-jest',
    '^.+\\.vue$': 'vue-jest',
  },
};
