<template>
  <div class="row col-12 q-pt-xl justify-center">
    <div class="col-12 q-mt-xl flex justify-center">
      <span class="text-weight-bold" style="color: #001f54; font-size: 3em"
        >Time Manager</span
      >
    </div>
    <div class="col-12 q-mt-xl flex justify-center">
      <q-btn size="xl" unelevated color="primary" label="Create User" >
        <template v-slot:default>
          <q-icon style="color: white" class="q-pl-sm" name="img:icons/add-circle.svg" />
        </template>
      </q-btn>
    </div>
    <div class="col-12 q-mt-lg flex justify-center">
      <q-btn size="xl" unelevated color="primary" label="Show Users" >
        <template v-slot:default>
          <q-icon color="white" class="q-pl-sm" name="img:icons/people.png" />
        </template>
      </q-btn>
    </div>
    <div class="col-12 q-mt-lg flex justify-center">
      <q-btn size="xl" unelevated color="primary" label="Unelevated" />
    </div>
  </div>
</template>

<script>
import { defineComponent } from "vue";

export default defineComponent({
  name: "IndexPage",
});
</script>
