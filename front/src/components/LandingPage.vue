<template>
  <div class="row col-12 q-pt-xl justify-center">
    <div class="col-12 q-mt-xl flex justify-center">
      <span class="text-weight-bold" style="color: #001f54; font-size: 3em"
        >Time Manager</span
      >
    </div>
    <div class="col-12 q-mt-xl flex justify-center">
      <q-btn size="xl" unelevated color="primary" label="Create User">
        <template v-slot:default>
          <q-icon
            style="color: white"
            class="q-pl-sm"
            name="img:icons/add-circle.svg"
          />
        </template>
      </q-btn>
    </div>
    <div class="col-12 q-mt-lg flex justify-center">
      <q-btn size="xl" unelevated color="primary" label="Show Users">
        <template v-slot:default>
          <q-icon color="white" class="q-pl-sm" name="img:icons/people.png" />
        </template>
      </q-btn>
    </div>
    <div class="col-12 q-mt-lg flex justify-center">
      <q-select
        filled
        v-model="model"
        use-input
        hide-selected
        hide-dropdown-icon
        fill-input
        input-debounce="0"
        :options="options"
        @update:model-value="ActiveUser()"
        @filter="filterFn"
      >
        <template v-slot:no-option>
          <q-item>
            <q-item-section class="text-grey"> No results </q-item-section>
          </q-item>
        </template>
        <template v-slot:append>
          <q-icon name="search" @click.stop.prevent />
        </template>
      </q-select>
    </div>
  </div>
</template>

<script>
import { defineComponent, ref } from "vue";
import { useGlobalStore } from "stores/global";

const stringOptions = [
  {label: "Samuel Cadau", value: "Full-stack"},
  {label: "Antoine Le-Guillou", value: "Full-stack2"},
  {label: "Mohamed Lahcen", value: "Full-stack3"},
  {label: "Charlène Obadia", value: "Full-stack4"},
  {label: "Serge le bidon", value: "Full-stack5"},
]

export default defineComponent({
  name: "LandingPage",

  setup() {
    const store = useGlobalStore();
    const model = ref(null);
    const options = ref(stringOptions);

    return {
      store,
      model,
      options,
      filterFn(val, update, abort) {
        update(() => {
          const needle = val.toLocaleLowerCase();
          options.value = stringOptions.filter(
            (v) => v.label.toLocaleLowerCase().indexOf(needle) > -1
          );
        });
      },
    };
  },
  methods: {
    ActiveUser() {
      this.store.user = this.model;
      this.store.step = 2;
    }
  },
});
</script>