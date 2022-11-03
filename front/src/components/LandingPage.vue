<template>
  <div class="row col-12 q-pt-xl justify-center">
    <div class="col-12 q-mt-xl flex justify-center">
      <span class="text-weight-bold" style="color: #001f54; font-size: 3em"
        >Time Manager</span
      >
    </div>
    <q-stepper v-model="stepLog" ref="stepper" color="primary" animated flat>
      <q-step :name="1" title="Not JWT" :done="stepLog > 1">
        <div class="row col-12 justify-center">
          <div class="col-12 row items-center justify-center">
            <div class="col-6 q-mt-xl">
              <q-input outlined v-model="email" label="Email" />
            </div>
          </div>
          <div class="col-12 row items-center justify-center">
            <div class="col-6 q-mt-lg">
              <q-input
                v-model="password"
                outlined
                :type="isPwd ? 'password' : 'text'"
                label="Password"
              >
                <template v-slot:append>
                  <q-icon
                    :name="isPwd ? 'visibility_off' : 'visibility'"
                    class="cursor-pointer"
                    @click="isPwd = !isPwd"
                  />
                </template>
              </q-input>
            </div>
            <div class="col-12 row items-center justify-center">
              <div class="col-6 flex justify-end q-mt-lg">
                <q-btn
                  flat
                  label="Validate"
                  style="background-color: #001f54; color: white"
                  @click="LoginUser()"
                />
              </div>
            </div>
          </div>
        </div>
      </q-step>
      <q-step :name="2" title="JWT" :done="stepLog > 2">
        <div class="row col-12 justify-center">
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
                <q-icon
                  color="white"
                  class="q-pl-sm"
                  name="img:icons/people.png"
                />
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
                  <q-item-section class="text-grey">
                    No results
                  </q-item-section>
                </q-item>
              </template>
              <template v-slot:append>
                <q-icon name="search" @click.stop.prevent />
              </template>
            </q-select>
          </div>
        </div>
      </q-step>
    </q-stepper>
  </div>
</template>

<script>
import { defineComponent, ref } from "vue";
import { useGlobalStore } from "stores/global";
import CreateUser from "src/components/CreateUser.vue";
import axios from "axios";
import { LocalStorage, Loading, Notify } from "quasar";

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
      isPwd: ref(true),
      email: ref(null),
      password: ref(null),
      step: 1,
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
      this.store.avatar = "https://eu.ui-avatars.com/api/?rounded=true&name=" + this.store.user.username
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
          Authorization: "Bearer " + this.store.jwt,
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
    async LoginUser() {
      Loading.show({
        message: "Login in progress ...",
      });
      let res = null;
      let success = false;
      var data = JSON.stringify({
        email: this.email,
        password: this.password,
      });

      var config = {
        method: "post",
        url: "http://localhost:4000/api/sessions/login",
        headers: {
          "Content-Type": "application/json",
        },
        data: data,
      };

      await axios(config)
        .then(function (response) {
          console.log(JSON.stringify(response.data.token));
          res = response.data.token;
          LocalStorage.set("JWT", res);
          Loading.hide();
          success = true;
        })
        .catch(function (error) {
          console.log(error);
          Loading.hide();
        });
      if (success === true) {
        this.store.stepLanding = 2;
      } else {
        Notify.create({
          type: "negative",
          message: "Wrong Email or Password",
        });
      }
    },
  },
  computed: {
    stepLog() {
      let final = this.store.stepLanding;
      if (this.store.jwt !== null) {
        final = 2;
      }
      return final;
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
