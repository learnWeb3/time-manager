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
            <q-input outlined v-model="store.createUser.username" label="Username" />
          </div>
        </div>
        <div class="col-12 row items-center justify-center">
          <div class="col-8 q-mt-lg">
            <q-input outlined v-model="store.createUser.email" label="Email" />
          </div>
        </div>
        <div class="col-12 row items-center justify-center">
          <div class="col-8 q-my-lg">
            <q-input
              outlined
              v-model="store.createUser.profession"
              label="Profession"
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
          v-close-popup
        />
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script>
import { defineComponent } from "vue";
import { useGlobalStore } from "stores/global";

export default defineComponent({
  name: "CreateUser",

  setup() {
    const store = useGlobalStore();

    return {
      store,
    };
  },
});
</script>
