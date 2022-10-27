<template>
  <div class="row col-12 q-mt-sm">
    <div class="col-12 flex justify-center">
      <q-avatar size="125px">
        <img src="https://cdn.quasar.dev/img/avatar.png" />
      </q-avatar>
    </div>
    <div class="col-12 flex q-mt-sm justify-center">
      <span style="font-size: 1.3em; color: #0a1128">Fashion designer</span>
    </div>
    <div class="col-12 flex q-mt-xl justify-center">
      <q-btn outline rounded size="md" style="color: #1282A2 " label="User Detail" />
    </div>
    <div class="col-12 flex q-mt-md justify-center">
      <q-btn outline rounded size="md" style="color: #1282A2 " label="Dashboard" />
    </div>
  </div>
</template>

<script>
import { defineComponent } from "vue";

export default defineComponent({
  name: "LeftMenu",
});
</script>
