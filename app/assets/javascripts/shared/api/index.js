import Vue from 'vue';
import { underscoreKeys } from '../lib/params';

const BASE_PATH = '/api/';
const buildPath = (path) => BASE_PATH + path.replace(/^\//, '');

export default {
  get(path, params) {
    return Vue.http.get(buildPath(path), { params });
  },
  post(path, params) {
    return Vue.http.post(buildPath(path), underscoreKeys(params));
  },

  put(path, params) {
    return Vue.http.put(buildPath(path), underscoreKeys(params));
  },
  delete(path, params) {
    return Vue.http.delete(buildPath(path), underscoreKeys(params));
  }
};
