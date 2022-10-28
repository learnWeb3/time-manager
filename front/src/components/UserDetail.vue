<template>
  <div>
    <q-header elevated style="background-color: #001f54">
      <q-toolbar class="flex justify-between">
        <q-btn flat dense round icon="menu" aria-label="Menu" @click="leftDrawerOpen = !leftDrawerOpen" />

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
          <span style="font-size: 1.5em; color: #0a1128">{{
              store.user.username
          }}</span>
        </q-item-label>

        <LeftMenu />
      </q-list>
    </q-drawer>
    <q-stepper v-model="store.stepUser" ref="stepper" animated style="min-height: 100vh">
      <q-step :name="1" title="User Detail" :done="store.step > 1">
        <div class="col-12 row justify-center q-mx-xl q-my-xl">
          <div class="col-10 row">
            <div class="col-12">
              <span class="text-weight-bold" style="font-size: 1.5em; color: #001f54">Detail</span>
            </div>
            <q-slide-transition appear>
              <div v-show="store.userEdit" class="col-12 row items-center justify-center">
                <div class="col-2 q-ml-xl q-mt-xl">
                  <span class="text-weight-bold" style="font-size: 1.3em; color: #001f54">Username :</span>
                </div>
                <div class="col-6 q-mt-xl">
                  <span style="font-size: 1.3em; color: #001f54" class="text-weight-light q-pl-xl">{{
                      store.user.username
                  }}</span>
                </div>
              </div>
            </q-slide-transition>
            <q-slide-transition appear>
              <div v-show="store.userEdit" class="col-12 row items-center justify-center">
                <div class="col-2 q-ml-xl q-mt-xl">
                  <span class="text-weight-bold" style="font-size: 1.3em; color: #001f54">Email :</span>
                </div>
                <div class="col-6 q-mt-xl">
                  <span style="font-size: 1.3em; color: #001f54" class="text-weight-light q-pl-xl">{{ store.user.email
                  }}</span>
                </div>
              </div>
            </q-slide-transition>
            <q-slide-transition appear>
              <div v-show="store.userEdit" class="col-12 row items-center justify-center">
                <div class="col-2 q-ml-xl q-mt-xl">
                  <span class="text-weight-bold" style="font-size: 1.3em; color: #001f54">Profession :</span>
                </div>
                <div class="col-6 q-mt-xl">
                  <span style="font-size: 1.3em; color: #001f54" class="text-weight-light q-pl-xl">{{
                      store.user.profession
                  }}</span>
                </div>
              </div>
            </q-slide-transition>
            <q-slide-transition appear>
              <div v-show="store.inputEdit" class="col-12 row items-center justify-center">
                <div class="col-8 q-ml-xl q-mt-xl">
                  <q-input outlined v-model="store.user.username" label="Username" />
                </div>
              </div>
            </q-slide-transition>
            <q-slide-transition appear>
              <div v-show="store.inputEdit" class="col-12 row items-center justify-center">
                <div class="col-8 q-ml-xl q-mt-lg">
                  <q-input outlined v-model="store.user.email" label="Email" />
                </div>
              </div>
            </q-slide-transition>
            <q-slide-transition appear>
              <div v-show="store.inputEdit" class="col-12 row items-center justify-center">
                <div class="col-8 q-ml-xl q-mt-lg">
                  <q-input outlined v-model="store.user.profession" label="Profession" />
                </div>
              </div>
            </q-slide-transition>
            <div class="col-12 row items-center justify-center">
              <div class="col-8 flex justify-center q-mt-xl">
                <q-btn unelevated style="background-color: #001f54; color: white"
                  :label="store.userEdit === true ? 'Edit User' : 'Validate'"
                  :icon-right="store.userEdit === true ? 'edit' : 'check'" @click="
                    (store.userEdit = !store.userEdit),
                    (store.inputEdit = !store.inputEdit)
                  " />
              </div>
            </div>
          </div>
          <div class="col-10 q-mt-xl row">
            <div class="col-12 q-mt-xl">
              <span class="text-weight-bold" style="font-size: 1.5em; color: #001f54">Danger Zone</span>
            </div>
            <div class="col-12 row items-center justify-center">
              <div class="col-8 justify-start text-center q-mt-xl">
                <span class="text-weight-light" style="font-size: 1.3em; color: #001f54">This action will permanently
                  delete the user from the Time
                  Manager platform and database.</span>
              </div>
              <div class="col-8 flex justify-center q-mt-lg">
                <q-btn unelevated color="negative" label="Delete User" />
              </div>
            </div>
          </div>
        </div>
      </q-step>
      <q-step :name="2" title="Dashboard" :done="store.step > 2">
        <div class="col-12 q-mx-xl q-my-md">
          <div class="row">
            <div class="col-2 row q-mt-md">
              <span class="text-weight-bold" style="font-size: 1.5em; color: #001f54">Dashboard</span>
            </div>
            <div class="col-4 row q-mt-md justify-between justify-center">
              <div class="col-4 flex justify-center">
                <q-btn :outline="store.menu === 'Weekly' ? false : true" rounded unelevated size="md" :style="store.menu === 'Weekly' ? 'background-color: #001f54; color: white' : 'color: #0a1128'" label="Weekly" @click="store.menu = 'Weekly', store.stepUser = 2"/>
              </div>
              <div class="col-4 flex justify-center">
                <q-btn :outline="store.menu === 'Monthly' ? false : true" rounded unelevated size="md" :style="store.menu === 'Monthly' ? 'background-color: #001f54; color: white' : 'color: #0a1128'" label="Monthly" @click="store.menu = 'Monthly', store.stepUser = 2"/>
              </div>
              <div class="col-4 flex justify-center">
                <q-btn :outline="store.menu === 'Yearly' ? false : true" rounded unelevated size="md" :style="store.menu === 'Yearly' ? 'background-color: #001f54; color: white' : 'color: #0a1128'" label="Yearly" @click="store.menu = 'Yearly', store.stepUser = 2"/>
              </div>
              
            </div>
          </div>

          <div class="col-12 row q-mt-md">
            <div class="col-6 ">
              <BarChart />
            </div>
            <div class="col-6">
              <PieChart />
            </div>
          </div>
          <div class="col-12 row ">
            <LineChart />
          </div>
        </div>
      </q-step>
    </q-stepper>
  </div>
</template>

<script>
import { defineComponent, ref } from "vue";
import LeftMenu from "src/components/LeftMenu.vue";
import { useGlobalStore } from "stores/global";
import BarChart from "src/components/Charts/BarChart.vue";
import LineChart from "src/components/Charts/LineChart.vue"
import PieChart from "src/components/Charts/PieChart.vue"

export default defineComponent({
  name: "UserDetail",

  components: {
    LeftMenu, BarChart, LineChart, PieChart
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

<style>
.q-stepper--horizontal .q-stepper__step-inner {
  padding: 0px;
}
</style>