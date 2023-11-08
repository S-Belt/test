import { createApp } from 'vue'
import App from './App.vue'
import router from './components/services/router'
import store from './components/services/store'

createApp(App)
    .use(router)
    .use(store)    
    .mount('#app')
