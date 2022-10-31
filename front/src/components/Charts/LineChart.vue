<template>
    <div class="example">
      <apexchart   width="500" height="300" type="line" :options="options" :series="series"></apexchart>
    </div>
  </template>
    
  <script>
  export default {
    el: '#app',
    data: function() {
      return {
        options: {
            chart: {
              height: 350,
              type: 'line',
              zoom: {
                enabled: false
              }
            },
            dataLabels: {
              enabled: false
            },
            stroke: {
              curve: 'straight'
            },
            title: {
              text: 'Product Trends by Month',
              align: 'left'
            },
            grid: {
              row: {
                colors: ['#f3f3f3', 'transparent'], // takes an array which will be repeated on columns
                opacity: 0.5
              },
            },
            xaxis: {
              categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep'],
            }
          },
        series: [{
              name: "Desktops",
              data: [10, 41, 35, 51, 49, 62, 69, 91, 148]
          },
          {
              name: "Low - 2013",
              data: [12, 11, 14, 18, 17, 13, 13,34,43]
            }],
      }
    }
  }
  </script>