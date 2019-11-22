import Vue from 'vue';
import Vuex from 'vuex';

import currencies from './currencies';

Vue.use(Vuex);

const store = new Vuex.Store({
  strict: true,
  modules: {
    currencies
  }
});

export default store;
