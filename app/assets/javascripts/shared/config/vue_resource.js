import Vue from 'vue';
import VueResource from 'vue-resource';
import { camelizeKeys } from '../lib/params';
import _ from 'underscore';

Vue.use(VueResource);

const token = (() => {
  let el = document.querySelector('[name=csrf-token]');
  if (el) {
    return el.content;
  }
  return null;
})();

const queryParams = (request) => {
  let q = _.map(request.params, (v, k) => `${k}=${v}`).join('&') || '';
  if (q) {
    q = `?${q}`;
  }
  return q;
};

Vue.http.interceptors.push((request, next) => {
  const start = performance.now();
  if (token) {
    request.headers.set('X-CSRF-TOKEN', token);
  }
  next((response) => {
    const end = performance.now();
    const elapsed = parseInt(end - start);
    const q = queryParams(request);
    response.body = camelizeKeys(response.body);
  });
});
