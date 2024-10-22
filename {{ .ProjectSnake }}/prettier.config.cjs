/**
 * @see https://prettier.io/docs/en/configuration.html
 */
const config = {
  trailingComma: 'es5',
  tabWidth: 2,
  semi: false,
  singleQuote: true,
  plugins: [
    // Add plugins here using a require() statement.
    // This is required to ensure the node module resolution algorithm starts walking
    // up the filesystem from this file, rather than from the location where prettier interprets it.
  ],
}

module.exports = config
