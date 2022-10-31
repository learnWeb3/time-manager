<template>
    <div class="example">
      <apexchart  width="500" height="300"  type="pie" :options="options" :series="series"></apexchart>
    </div>
  </template>
      
  <script>
  export default {
    el: '#appl',
    data: function() {
      return {
    series: [44, 55, 13, 43, 22],
    options: {
      chart: {
            id: 'vuechart-example'
      },
      labels: ['Team A', 'Team B', 'Team C', 'Team D', 'Team E'],
    }
  }}}
  </script>