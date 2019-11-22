import createBootstrap from '$shared/lib/bootstrap';

import app from './components/app';
import store from './store';
import router from './router';

createBootstrap({
  app,
  router,
  store,
  initializers: [
    require.context('./initializers', true, /\.js$/)
  ]
});
