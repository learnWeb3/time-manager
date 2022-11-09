<template>
  <div class="row col-12 q-mt-sm" style="position: relative">
    <div :class="store.step === 3 ? 'col-12 flex justify-center q-mt-xl' : 'col-12 flex justify-center'">
      <q-avatar size="125px">
        <img :src="this.store.avatar" />
      </q-avatar>
    </div>
    <div class="col-12 flex q-mt-sm justify-center">
      <span style="font-size: 1.3em; color: #0a1128">{{ store.step === 3 ? 'Manager' : store.user.value }}</span>
    </div>
    <div class="col-12 flex q-mt-xl justify-center">
      <q-btn :outline="store.menu === 'User Detail' ? false : true" rounded size="md" unelevated :style="store.menu === 'User Detail' ? 'background-color: #1282A2; color: white' : 'color: #1282A2'" label="User Detail" @click="store.menu = 'User Detail', store.stepUser = 1" />
    </div>
    <div class="col-12 flex q-mt-md justify-center">
      <q-btn :outline="store.menu === 'Dashboard' ? false : true" rounded unelevated size="md" :style="store.menu === 'Dashboard' ? 'background-color: #1282A2; color: white' : 'color: #1282A2'" label="Dashboard" @click="store.menu = 'Dashboard', store.stepUser = 2"/>
    </div>
    <div class="col-12 flex q-mt-md justify-center" style="position: absolute; top: 550px;">
      <q-btn outline rounded unelevated size="md" style="color: #1282A2" label="Go Back" @click="store.step = 1"/>
    </div>
  </div>
</template>

<script>
import { defineComponent } from "vue";
import { useGlobalStore } from 'stores/global';

export default defineComponent({
  name: "LeftMenu",

  setup() {
      const store = useGlobalStore();
  
      return {
        store,
      };
    },
});
</script>
