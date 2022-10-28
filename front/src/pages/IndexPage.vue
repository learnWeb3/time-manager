<template>
  <q-stepper
    v-model="store.step"
    ref="stepper"
    color="primary"
    animated
    style="min-height: 100vh"
  >
    <q-step :name="1" title="Landing Page" :done="store.step > 1">
      <LandingPage />
    </q-step>
    <q-step :name="2" title="User Detail" :done="store.step > 2">
      <UserDetail />
    </q-step>
    <q-step :name="3" title="All User" :done="store.step > 3">
      <AllUser />
    </q-step>
  </q-stepper>
</template>

<script>
import LandingPage from "src/components/LandingPage.vue";
import UserDetail from "src/components/UserDetail.vue";
import AllUser from "src/components/AllUser.vue";
import { defineComponent, ref } from "vue";
import { useGlobalStore } from "stores/global";

export default defineComponent({
  name: "IndexPage",

  setup() {
    const store = useGlobalStore();

    return {
      store,
    };
  },
  components: {
    LandingPage,
    UserDetail,
    AllUser,
  },
});
</script>

<style>
.q-stepper__header {
  display: none;
}
</style>
