<template>
  <div id="app">
    <header>
      <h1>Gotham Time Manager</h1>
    </header>

    <main>
      <router-view />
    </main>

    <footer>
    </footer>
  </div>
</template>

<script>

export default {
  name: 'App',
}
</script>

<style>
#app {
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
@import './assets/ressource/css/style.css';
</style>
