<template>
  <q-dialog v-model="store.dialog">
    <q-card>
      <q-card-section>
        <div class="text-h6">Create a User</div>
      </q-card-section>

      <q-separator />

      <q-card-section style="max-height: 50vh" class="col-12 row scroll">
        <div class="col-12 row items-center justify-center">
          <div class="col-8 q-mt-lg">
            <q-input
              outlined
              v-model="store.createUser.username"
              label="Username"
            />
          </div>
        </div>
        <div class="col-12 row items-center justify-center">
          <div class="col-8 q-mt-lg">
            <q-input
              v-model="store.createUser.password"
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
        </div>
        <div class="col-12 row items-center justify-center">
          <div class="col-8 q-mt-lg">
            <q-input outlined v-model="store.createUser.email" label="Email" />
          </div>
        </div>
        <div class="col-12 row items-center justify-center">
          <div class="col-8 q-mt-lg">
            <q-input
              outlined
              v-model="store.createUser.jobtitle"
              label="Profession"
            />
          </div>
          <div class="col-8 q-mt-lg">
            <q-select
              outlined
              v-model="model"
              emit-value
              map-options
              option-label="name"
              :options="store.role"
              label="Role"
              @update:model-value="store.createUser.role = model"
            />
          </div>
        </div>
      </q-card-section>

      <q-separator />

      <q-card-actions align="right">
        <q-btn flat label="Cancel" color="negative" v-close-popup />
        <q-btn
          flat
          label="Validate"
          style="background-color: #001f54; color: white"
          @click="CreateUser()"
          v-close-popup
        />
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script>
import { defineComponent, ref } from "vue";
import { useGlobalStore } from "stores/global";
import axios from "axios";

export default defineComponent({
  name: "CreateUser",

  setup() {
    const store = useGlobalStore();

    return {
      store,
      isPwd: ref(true),
      model: ref(null),
    };
  },
  methods: {
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
    async CreateUser() {
      let res = null;
      var data = JSON.stringify({
        user: {
          username: this.store.createUser.username,
          email: this.store.createUser.email,
          password: this.store.createUser.password,
          jobtitle: this.store.createUser.jobtitle,
          role: this.store.createUser.role,
        },
      });

      var config = {
        method: "post",
        url: "http://localhost:4000/api/users",
        headers: {
          Authorization: "Bearer " + this.store.jwt,
          "Content-Type": "application/json",
        },
        data: data,
      };

      axios(config)
        .then(function (response) {
          console.log(JSON.stringify(response.data));
        })
        .catch(function (error) {
          console.log(error);
        });
      this.GetAllUser();
      this.store.createUser = {
        username: "",
        email: "",
        password: "",
        jobtitle: "",
        role: "",
      };
    },
  },
});
</script>
