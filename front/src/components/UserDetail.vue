<template>
    <div>
      <q-header elevated style="background-color: #001f54">
        <q-toolbar class="flex justify-between">
          <q-btn
            flat
            dense
            round
            icon="menu"
            aria-label="Menu"
            @click="leftDrawerOpen = !leftDrawerOpen"
          />
  
          <div>
            <q-avatar>
              <img src="https://cdn.quasar.dev/img/avatar.png" />
            </q-avatar>
          </div>
        </q-toolbar>
      </q-header>
  
      <q-drawer v-model="leftDrawerOpen" bordered>
        <q-list>
          <q-item-label header class="flex justify-center q-mt-sm">
            <span style="font-size: 1.5em; color: #0a1128">{{ store.user.label }}</span>
          </q-item-label>
  
          <LeftMenu />
        </q-list>
      </q-drawer>
    </div>
  </template>
  
  <script>
  import { defineComponent, ref } from "vue";
  import LeftMenu from "src/components/LeftMenu.vue";
  import { useGlobalStore } from 'stores/global';
  
  export default defineComponent({
    name: "UserDetail",
  
    components: {
      LeftMenu,
    },
  
    setup() {
      const leftDrawerOpen = ref(false);
      const store = useGlobalStore();
  
      return {
        leftDrawerOpen,
        store,
      };
    },
  });
  </script>
  