import _ from 'underscore';
import Vue from 'vue';

import '$shared/config/vue_resource';
import env from '$shared/lib/env';
import { camelizeKeys } from './params';

// Run initializers

const initialize = (context) => {
  if (_.isArray(context)) {
    _.each(context, initialize);
    return;
  }
  context.keys().forEach((k) => {
    let initializer = context(k);

    if (typeof initializer.default === 'function') {
      initializer.default();
    }
  });
};

// Seed store
const seed = (store, data) => {
  if (store === null) {
    return;
  }
  _.each(data, (data, key) => {
    store.commit(`${key}/seed`, camelizeKeys(data));
  });
};

// Create app

const createApp = (app, el, router, store) => {
  if (_.isString(el)) {
    el = document.querySelector(el);
  }

  let options = {
    el: el
  };

  if (store !== null) {
    options.store = store;
  }

  if (router !== null) {
    options.router = router;
  }

  let App = Vue.extend(app);
  new App(options);
};

// Create the bootstrap function

const createBootstrap = (options = {}) => {
  options = _.extend({
    app: null,
    router: null,
    store: null,
    initializers: [],
    el: '.app-body'
  }, options);

  window.bootstrap = (data) => {
    let environment = data.environment;
    env.set(environment);
    delete(data.environment);

    initialize(options.initializers);
    seed(options.store, data);
    createApp(options.app, options.el, options.router, options.store);

    // Cleanup
    delete window.bootstrap;
    let scriptEl = document.querySelector('[data-bootstrap]');
    if (scriptEl) {
      scriptEl.parentNode.removeChild(scriptEl);
    }
  };
};

export default createBootstrap;
