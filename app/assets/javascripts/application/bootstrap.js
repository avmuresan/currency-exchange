import createBootstrap from '$shared/lib/bootstrap';

import app from './components/app';
import router from './router';

createBootstrap({
  app,
  router,
  initializers: [
    require.context('./initializers', true, /\.js$/)
  ]
});
