const state = {
  currencies: []
};

const mutations = {
  seed(state, currencies) {
    state.currencies = currencies;
  }
};

const actions = {
  set({ commit }, currencies) {
    commit('seed', currencies);
  }
};

const getters = {
  all(state) {
    return state.currencies;
  }
};

const module = {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
};

export default module;
