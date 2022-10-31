<template>
  <div class="row col-12 q-pt-xl justify-center">
    <div class="col-12 q-mt-xl flex justify-center">
      <span class="text-weight-bold" style="color: #001f54; font-size: 3em"
        >Time Manager</span
      >
    </div>
    <div class="col-12 q-mt-xl flex justify-center">
      <q-btn size="xl" unelevated color="primary" label="Create User" @click="store.dialog = true">
        <template v-slot:default>
          <q-icon
            style="color: white"
            class="q-pl-sm"
            name="img:icons/add-circle.svg"
          />
        </template>
      </q-btn>
      <CreateUser />
    </div>
    <div class="col-12 q-mt-lg flex justify-center">
      <q-btn size="xl" unelevated color="primary" label="Show Users" @click="store.step = 3">
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
        option-label="username"
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
import CreateUser from "src/components/CreateUser.vue";

const stringOptions = [
  {username: "Samuel Cadau", email: "test@gmail.com", profession: "Full-stack"},
  {username: "Antoine Le-Guillou", email: "test@gmail.com", profession: "Full-stack2"},
  {username: "Mohamed Lahcen", email: "test@gmail.com", profession: "Full-stack3"},
  {username: "Charlène Obadia", email: "test@gmail.com", profession: "Full-stack4"},
  {username: "Serge le bidon", email: "test@gmail.com", profession: "Full-stack5"},
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
            (v) => v.username.toLocaleLowerCase().indexOf(needle) > -1
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
  components: {
    CreateUser,
  }
});
</script>