<template>
    <div class="example">
      <apexchart   width="500" height="300" type="line" :options="store.options3" :series="store.series3"></apexchart>
    </div>
  </template>
    
  <script>
import { useGlobalStore } from "stores/global";
  export default {
    el: '#app',
    setup() {
    const store = useGlobalStore();

    return {
      store,
    };
  },
    data: function() {
      return {
        
      }
    }
  }
  </script>