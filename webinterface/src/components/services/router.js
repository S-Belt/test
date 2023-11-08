import { createRouter, createWebHashHistory } from 'vue-router';
import Login from '../../components/Login';
import Dashboard from '../../components/Dashboard';
import Update from '../../components/Specificcomponents/Update';
import store from './store';

const routes = [
    { path: '', component: Dashboard, meta: { requiresAuth: true } },
    { path: '/login', component: Login },
    { path : '/dashboard', component: Dashboard, meta: { requiresAuth: true } },
    { path : '/update', component: Update, meta: { requiresAuth: true }}
]

const router = createRouter({
    history: createWebHashHistory(),
    routes,
})

router.beforeEach((to, from, next) => {
    if (to.matched.some((record) => record.meta.requiresAuth)) {
      if (store.getters.isAuthenticated) {
        next();
        return;
      }
      next("/login");
    } else {
      next();
    }
  });

  
export default router
