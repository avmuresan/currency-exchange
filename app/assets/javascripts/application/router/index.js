import Vue from 'vue';
import VueRouter from 'vue-router';

import Home from '../pages/home';

Vue.use(VueRouter);

const routes = [
  { path: '/', component: Home },
  { path: '*',  component: Home }
];

const router = new VueRouter({
  mode: 'history',
  routes: routes
});

export default router;
