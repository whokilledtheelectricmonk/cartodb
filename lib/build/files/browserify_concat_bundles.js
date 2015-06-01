// These bundles are expected to be used together with existing non-browerified code.
// Define step here and add the "dest" value to a bundle defined in ./js_files.js
module.exports = {
  test_specs_for_browserify_modules: {
    src: [
      'lib/build/source-map-support.js',

      // Add specs for browserify module code here:
      'lib/assets/test/spec/cartodb/common/**/*.spec.js',
      'lib/assets/test/spec/cartodb/organization/**/*.spec.js',
      'lib/assets/test/spec/cartodb/dashboard/**/*.spec.js',
      'lib/assets/test/spec/cartodb/keys/**/*.spec.js',
      'lib/assets/test/spec/cartodb/public_dashboard/**/*.spec.js',
      'lib/assets/test/spec/cartodb/account/**/*.spec.js',
      'lib/assets/test/spec/cartodb/editor/**/*.spec.js'
    ],
    dest: '<%= browserify_modules.tests.dest %>'
  }
};