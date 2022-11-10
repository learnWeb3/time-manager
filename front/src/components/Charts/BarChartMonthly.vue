<template>
  <div class="example">
    <apexchart
      width="500"
      height="300"
      type="bar"
      :options="store.optionsMonthly"
      :series="store.seriesMonthly"
    ></apexchart>
  </div>
</template>

<script>
import { date } from "quasar";
import { useGlobalStore } from "stores/global";
export default {
  el: "#appl",
  setup() {
    const store = useGlobalStore();

    return {
      store,
    };
  },
  methods: {},
  mounted() {},
};
</script>
