<template>
    <div class="example">
      <apexchart  width="500" height="300"  type="pie" :options="store.options2" :series="store.series2"></apexchart>
    </div>
  </template>
      
  <script>
  import { useGlobalStore } from "stores/global";
  export default {
    el: '#appl',
    setup() {
    const store = useGlobalStore();

    return {
      store,
    };
  },
    data: function() {
      return {
    
  }}}
  </script>