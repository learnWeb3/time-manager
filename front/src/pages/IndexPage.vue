<template>
  <q-stepper v-model="store.step" ref="stepper" color="primary" animated style="min-height: 100vh">
    <q-step
      :name="1"
      title="Landing Page"
      :done="store.step > 1"
    >
      <LandingPage />
    </q-step>
  </q-stepper>
</template>

<script>
import LandingPage from "src/components/LandingPage.vue";
import { defineComponent, ref } from "vue";
import { useGlobalStore } from 'stores/global';

const stringOptions = [
  "Samuel Cadau",
  "Antoine Le-Guillou",
  "Mohamed Lahcen",
  "Charlène Obadia",
  "Serge le bidon",
].reduce((acc, opt) => {
  for (let i = 1; i <= 5; i++) {
    acc.push(opt + " " + i);
  }
  return acc;
}, []);

export default defineComponent({
  name: "IndexPage",

  setup() {
    const model = ref(null);
    const options = ref(stringOptions);
    const store = useGlobalStore();

    return {
      model,
      options,
      store,
      filterFn(val, update, abort) {
        update(() => {
          const needle = val.toLocaleLowerCase();
          options.value = stringOptions.filter(
            (v) => v.toLocaleLowerCase().indexOf(needle) > -1
          );
        });
      },

      setModel(val) {
        model.value = val;
      },
    };
  },
  components: {
    LandingPage,
  },
});
</script>

<style>
.q-stepper__header {
  display: none;
}
</style>
