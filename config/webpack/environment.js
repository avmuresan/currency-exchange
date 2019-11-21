const { environment } = require('@rails/webpacker');
const { VueLoaderPlugin } = require('vue-loader');
const path = require('path');
const vue = require('./loaders/vue');
const pug =  require('./loaders/pug');

// Add some aliases to reduce the need for relative paths
const config = {
  resolve: {
    alias: {
      '$shared': path.resolve('app/assets/javascripts/shared')
    }
  }
};
environment.config.merge(config);

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin());
environment.loaders.prepend('vue', vue);
environment.loaders.prepend('pug', pug);
module.exports = environment;
