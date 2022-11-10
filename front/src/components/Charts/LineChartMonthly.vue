<template>
    <div class="example">
      <apexchart   width="500" height="300" type="line" :options="store.options3Monthly" :series="store.series3Monthly"></apexchart>
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