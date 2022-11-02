<template>
  <div class="row col-12 q-pt-xl justify-center">
    <div class="col-12 q-mt-xl flex justify-center">
      <span class="text-weight-bold" style="color: #001f54; font-size: 3em"
        >Time Manager</span
      >
    </div>
    <div class="col-12 q-mt-xl flex justify-center">
      <q-btn
        size="xl"
        unelevated
        color="primary"
        label="Create User"
        @click="store.dialog = true"
      >
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
      <q-btn
        size="xl"
        unelevated
        color="primary"
        label="Show Users"
        @click="store.step = 3"
      >
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
import axios from "axios";

export default defineComponent({
  name: "LandingPage",

  setup() {
    const store = useGlobalStore();
    const model = ref(null);
    const options = ref(store.allUser);

    return {
      store,
      model,
      options,
      filterFn(val, update, abort) {
        update(() => {
          const needle = val.toLocaleLowerCase();
          options.value = store.allUser.filter(
            (v) => v.username.toLocaleLowerCase().indexOf(needle) > -1
          );
        });
      },
    };
  },
  methods: {
    ActiveUser() {
      this.store.user = this.model;
      switch (this.store.user.role) {
        case 1:
          this.store.user.role = {
            name: "Admin",
            value: 1,
          };
          break;
        case 2:
          this.store.user.role = {
            name: "Manager",
            value: 2,
          };
          break;
        case 3:
          this.store.user.role = {
            name: "User",
            value: 3,
          };
          break;
      }
      this.store.step = 2;
    },
    async GetAllUser() {
      let res = null;
      var config = {
        method: "get",
        url: "http://localhost:4000/api/users",
        headers: {
          Authorization:
            "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ0aW1lLW1hbmFnZXIiLCJleHAiOjE2NjczODcwMzYsImlhdCI6MTY2NzM4MzQzNiwiaXNzIjoidGltZS1tYW5hZ2VyIiwianRpIjoiMnNocm9wbDExcGcyYXNkcjgwMDAwMTYyIiwibmJmIjoxNjY3MzgzNDM2LCJzdWIiOjF9.XF4UmHoK5KKIFuWAN9RpdbWiSq6_ZRfxsz8MERgKp64",
        },
      };
      await axios(config)
        .then(function (response) {
          console.log(response.data.data);
          res = response.data.data;
        })
        .catch(function (error) {
          console.log(error);
        });
      this.store.allUser = res;
    },
  },
  components: {
    CreateUser,
  },
  mounted() {
    this.GetAllUser();
  },
});
</script>
