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
            <img :src="this.store.avatar" />
            <q-menu>
              <div class="row no-wrap q-pa-md">
                <div class="column items-center">
                  <q-avatar size="72px">
                    <img :src="this.store.avatar" />
                  </q-avatar>

                  <div class="text-subtitle1 q-mt-sm q-mb-xs">
                    {{ this.store.user.username }}
                  </div>

                  <q-btn
                    color="primary"
                    label="Go Back"
                    unelevated
                    size="sm"
                    @click="GoBack()"
                    v-close-popup
                  />
                </div>
              </div>
            </q-menu>
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
    <q-stepper
      v-model="store.stepUser"
      ref="stepper"
      animated
      style="min-height: 100vh"
    >
      <q-step :name="1" title="User Detail" :done="store.step > 1">
        <div class="col-12 row justify-center q-mx-xl q-my-xl">
          <div class="col-10 row">
            <div class="col-12">
              <span
                class="text-weight-bold"
                style="font-size: 1.5em; color: #001f54"
                >Detail</span
              >
            </div>
            <q-slide-transition appear>
              <div
                v-show="store.userEdit"
                class="col-12 row items-center justify-center"
              >
                <div class="col-2 q-ml-xl q-mt-xl">
                  <span
                    class="text-weight-bold"
                    style="font-size: 1.3em; color: #001f54"
                    >Username :</span
                  >
                </div>
                <div class="col-6 q-mt-xl">
                  <span
                    style="font-size: 1.3em; color: #001f54"
                    class="text-weight-light q-pl-xl"
                    >{{ store.user.username }}</span
                  >
                </div>
              </div>
            </q-slide-transition>
            <q-slide-transition appear>
              <div
                v-show="store.userEdit"
                class="col-12 row items-center justify-center"
              >
                <div class="col-2 q-ml-xl q-mt-xl">
                  <span
                    class="text-weight-bold"
                    style="font-size: 1.3em; color: #001f54"
                    >Email :</span
                  >
                </div>
                <div class="col-6 q-mt-xl">
                  <span
                    style="font-size: 1.3em; color: #001f54"
                    class="text-weight-light q-pl-xl"
                    >{{ store.user.email }}</span
                  >
                </div>
              </div>
            </q-slide-transition>
            <q-slide-transition appear>
              <div
                v-show="store.userEdit"
                class="col-12 row items-center justify-center"
              >
                <div class="col-2 q-ml-xl q-mt-xl">
                  <span
                    class="text-weight-bold"
                    style="font-size: 1.3em; color: #001f54"
                    >Profession :</span
                  >
                </div>
                <div class="col-6 q-mt-xl">
                  <span
                    style="font-size: 1.3em; color: #001f54"
                    class="text-weight-light q-pl-xl"
                    >{{ store.user.jobtitle }}</span
                  >
                </div>
              </div>
            </q-slide-transition>
            <q-slide-transition appear>
              <div
                v-show="store.userEdit"
                class="col-12 row items-center justify-center"
              >
                <div class="col-2 q-ml-xl q-mt-xl">
                  <span
                    class="text-weight-bold"
                    style="font-size: 1.3em; color: #001f54"
                    >Role :</span
                  >
                </div>
                <div class="col-6 q-mt-xl">
                  <span
                    style="font-size: 1.3em; color: #001f54"
                    class="text-weight-light q-pl-xl"
                    >{{ CheckRole() }}</span
                  >
                </div>
              </div>
            </q-slide-transition>
            <q-slide-transition appear>
              <div
                v-show="store.inputEdit"
                class="col-12 row items-center justify-center"
              >
                <div class="col-8 q-ml-xl q-mt-xl">
                  <q-input
                    outlined
                    v-model="store.user.username"
                    label="Username"
                  />
                </div>
              </div>
            </q-slide-transition>
            <q-slide-transition appear>
              <div
                v-show="store.inputEdit"
                class="col-12 row items-center justify-center"
              >
                <div class="col-8 q-ml-xl q-mt-lg">
                  <q-input
                    outlined
                    v-model="store.createUser.password"
                    label="Password"
                  />
                </div>
              </div>
            </q-slide-transition>
            <q-slide-transition appear>
              <div
                v-show="store.inputEdit"
                class="col-12 row items-center justify-center"
              >
                <div class="col-8 q-ml-xl q-mt-lg">
                  <q-input outlined v-model="store.user.email" label="Email" />
                </div>
              </div>
            </q-slide-transition>
            <q-slide-transition appear>
              <div
                v-show="store.inputEdit"
                class="col-12 row items-center justify-center"
              >
                <div class="col-8 q-ml-xl q-mt-lg">
                  <q-input
                    outlined
                    v-model="store.user.jobtitle"
                    label="Profession"
                  />
                </div>
              </div>
            </q-slide-transition>
            <q-slide-transition appear>
              <div
                v-show="store.inputEdit"
                class="col-12 row items-center justify-center"
              >
                <div class="col-8 q-ml-xl q-mt-lg">
                  <q-select
                    outlined
                    v-model="store.user.role"
                    emit-value
                    map-options
                    option-label="name"
                    :options="store.role"
                    label="Role"
                  />
                </div>
              </div>
            </q-slide-transition>
            <div class="col-12 row items-center justify-center">
              <div class="col-8 flex justify-center q-mt-xl">
                <q-btn
                  unelevated
                  style="background-color: #001f54; color: white"
                  :label="store.userEdit === true ? 'Edit User' : 'Validate'"
                  :icon-right="store.userEdit === true ? 'edit' : 'check'"
                  @click="
                    (store.userEdit = !store.userEdit),
                      (store.inputEdit = !store.inputEdit),
                      store.userEdit === true ? UpdateUser() : null
                  "
                />
              </div>
            </div>
          </div>
          <div class="col-10 q-mt-xl row">
            <div class="col-12 q-mt-xl">
              <span
                class="text-weight-bold"
                style="font-size: 1.5em; color: #001f54"
                >Danger Zone</span
              >
            </div>
            <div class="col-12 row items-center justify-center">
              <div class="col-8 justify-start text-center q-mt-xl">
                <span
                  class="text-weight-light"
                  style="font-size: 1.3em; color: #001f54"
                  >This action will permanently delete the user from the Time
                  Manager platform and database.</span
                >
              </div>
              <div class="col-8 flex justify-center q-mt-lg">
                <q-btn
                  unelevated
                  color="negative"
                  label="Delete User"
                  @click="DeleteUser()"
                />
              </div>
            </div>
          </div>
        </div>
      </q-step>
      <q-step :name="2" title="Dashboard" :done="store.step > 2">
        <div class="col-12 q-px-xl q-my-md">
          <div class="row">
            <div class="col-2 row q-mt-md">
              <span
                class="text-weight-bold"
                style="font-size: 1.5em; color: #001f54"
                >Dashboard</span
              >
            </div>
            <div class="col-4 row q-mt-md justify-between justify-center">
              <div class="col-3 flex justify-center">
                <q-btn
                  :outline="store.menuGraphDaily === true ? false : true"
                  rounded
                  unelevated
                  size="md"
                  :style="
                    store.menuGraphDaily === true
                      ? 'background-color: #001f54; color: white'
                      : 'color: #0a1128'
                  "
                  label="Daily"
                  @click="
                    (store.menuGraphDaily = true),
                    (store.menuGraphWeekly = false),
                    (store.menuGraphMonthly = false),
                      (store.stepUser = 2),
                      ValueGraphDaily(),
                      ValueGraphDailyAllUser()
                  "
                />
              </div>
              <div class="col-4 flex justify-center">
                <q-btn
                  :outline="store.menuGraphWeekly === true ? false : true"
                  rounded
                  unelevated
                  size="md"
                  :style="
                    store.menuGraphWeekly === true
                      ? 'background-color: #001f54; color: white'
                      : 'color: #0a1128'
                  "
                  label="Weekly"
                  @click="
                    (store.menuGraphDaily = false),
                    (store.menuGraphWeekly = true),
                    (store.menuGraphMonthly = false),
                      (store.stepUser = 2),
                      ValueGraphWeekly(),
                      ValueGraphWeeklyAllUser()
                  "
                />
              </div>
              <div class="col-4 flex justify-center">
                <q-btn
                  :outline="store.menuGraphMonthly === true ? false : true"
                  rounded
                  unelevated
                  size="md"
                  :style="
                    store.menuGraphMonthly === true
                      ? 'background-color: #001f54; color: white'
                      : 'color: #0a1128'
                  "
                  label="Monthly"
                  @click="
                   (store.menuGraphDaily = false),
                    (store.menuGraphWeekly = false),
                    (store.menuGraphMonthly = true),
                      (store.stepUser = 2),
                      ValueGraphMonthly(),
                      ValueGraphMonthlyAllUser()
                  "
                />
              </div>
            </div>
          </div>
          <q-slide-transition appear>
            <div v-if="store.menuGraphDaily" class="col-12 row q-mt-md">
              <div class="col-12 q-mt-md">
                <BarChartDaily />
              </div>
              <div class="col-12 q-mt-md">
                <PieChartDaily />
              </div>
              <div class="col-12 q-mt-md">
                <LineChartDaily />
              </div>
            </div>
          </q-slide-transition>
          <q-slide-transition appear>
            <div v-if="store.menuGraphWeekly" class="col-12 row q-mt-md">
              <div class="col-12 q-mt-md">
                <BarChartWeekly />
              </div>
              <div class="col-12 q-mt-md">
                <PieChartWeekly />
              </div>
              <div class="col-12 q-mt-md">
                <LineChartWeekly />
              </div>
            </div>
          </q-slide-transition>
          <q-slide-transition appear>
            <div v-if="store.menuGraphMonthly" class="col-12 row q-mt-md">
              <div class="col-12 q-mt-md">
                <BarChartMonthly />
              </div>
              <div class="col-12 q-mt-md">
                <PieChartMonthly />
              </div>
              <div class="col-12 q-mt-md">
                <LineChartMonthly />
              </div>
            </div>
          </q-slide-transition>
        </div>
      </q-step>
    </q-stepper>
  </div>
</template>

<script>
import { defineComponent, ref } from "vue";
import LeftMenu from "src/components/LeftMenu.vue";
import { useGlobalStore } from "stores/global";
import BarChartDaily from "src/components/Charts/BarChartDaily.vue";
import LineChartDaily from "src/components/Charts/LineChartDaily.vue";
import PieChartDaily from "src/components/Charts/PieChartDaily.vue";
import BarChartMonthly from "src/components/Charts/BarChartMonthly.vue";
import LineChartMonthly from "src/components/Charts/LineChartMonthly.vue";
import PieChartMonthly from "src/components/Charts/PieChartMonthly.vue";
import BarChartWeekly from "src/components/Charts/BarChartWeekly.vue";
import LineChartWeekly from "src/components/Charts/LineChartWeekly.vue";
import PieChartWeekly from "src/components/Charts/PieChartWeekly.vue";
import axios from "axios";

export default defineComponent({
  name: "UserDetail",

  components: {
    LeftMenu,
    BarChartDaily,
    LineChartDaily,
    PieChartDaily,
    BarChartMonthly,
    LineChartMonthly,
    LineChartWeekly,
    PieChartMonthly,
    BarChartWeekly,
    PieChartWeekly,
  },

  setup() {
    const leftDrawerOpen = ref(false);
    const store = useGlobalStore();

    return {
      leftDrawerOpen,
      store,
    };
  },

  methods: {
    GoBack() {
      this.store.step = 1;
    },
    CheckRole() {
      switch (this.store.user.role) {
        case 1:
          return "Admin";
        case 2:
          return "Manager";
        case 3:
          return "User";
        default:
          return this.store.user.role.name;
      }
    },
    async UpdateUser() {
      if (this.store.user.role.name) {
        this.store.user.role = this.store.user.role.value;
      }
      var data = {
        user: {
          role: this.store.user.role,
          username: this.store.user.username,
          email: this.store.user.email,
          password: this.store.user.password,
          jobtitle: this.store.user.jobtitle,
        },
      };

      var config = {
        method: "put",
        url: process.env.API_ROOT_URL + "/users/" + this.store.user.id,
        headers: {
          Authorization: "Bearer " + this.store.jwt,
        },
        data: data,
      };

      await axios(config)
        .then(function (response) {
          console.log(JSON.stringify(response.data));
        })
        .catch(function (error) {
          console.log(error);
        });
    },
    async DeleteUser() {
      var config = {
        method: "delete",
        url: process.env.API_ROOT_URL + "/users/" + this.store.user.id,
        headers: {
          Authorization: "Bearer " + this.store.jwt,
        },
      };

      await axios(config)
        .then(function (response) {
          console.log(JSON.stringify(response.data));
        })
        .catch(function (error) {
          console.log(error);
        });
      this.store.step = 1;
    },
    async ValueGraphMonthly() {
      let final;
      var config = {
        method: "get",
        url:
          process.env.API_ROOT_URL + "/clocks/presence?userId=" +
          this.store.user.id +
          "&periodicity=month",
        headers: {
          Authorization: "Bearer " + this.store.jwt,
        },
      };

      await axios(config)
        .then(function (response) {
          console.log(response.data.data);
          final = response.data.data;
        })
        .catch(function (error) {
          console.log(error);
        });
      this.store.monthly = final;
      this.SortMonthly();
    },
    async ValueGraphMonthlyAllUser() {
      let final;
      var config = {
        method: "get",
        url:
          process.env.API_ROOT_URL + "/clocks/presence?periodicity=month",
        headers: {
          Authorization: "Bearer " + this.store.jwt,
        },
      };

      await axios(config)
        .then(function (response) {
          console.log(response.data.data);
          final = response.data.data;
        })
        .catch(function (error) {
          console.log(error);
        });
      this.store.monthlyAllUser = final;
      this.SortMonthAllUser();
    },
    async ValueGraphWeekly() {
      let final;
      let dateStart = Math.floor(Date.now() / 1000) - 7 * 86400 * 12;
      let dateEnd = Math.floor(Date.now() / 1000);
      var config = {
        method: "get",
        url:
          process.env.API_ROOT_URL + "/clocks/presence?userId=" +
          this.store.user.id +
          "&periodicity=week&start=" +
          dateStart +
          "&end=" +
          dateEnd,
        headers: {
          Authorization: "Bearer " + this.store.jwt,
        },
      };

      await axios(config)
        .then(function (response) {
          console.log(response.data.data);
          final = response.data.data;
        })
        .catch(function (error) {
          console.log(error);
        });
      this.store.weekly = final;
      this.SortWeek();
    },
    async ValueGraphWeeklyAllUser() {
      let final;
      let dateStart = Math.floor(Date.now() / 1000) - 7 * 86400 * 4;
      let dateEnd = Math.floor(Date.now() / 1000);
      var config = {
        method: "get",
        url:
          process.env.API_ROOT_URL + "/clocks/presence?periodicity=week&start=" +
          dateStart +
          "&end=" +
          dateEnd,
        headers: {
          Authorization: "Bearer " + this.store.jwt,
        },
      };

      await axios(config)
        .then(function (response) {
          console.log(response.data.data);
          final = response.data.data;
        })
        .catch(function (error) {
          console.log(error);
        });
      this.store.weeklyAllUser = final;
      this.SortWeekAllUser();
    },
    async ValueGraphDaily() {
      let final;
      let dateStart = Math.floor(Date.now() / 1000) - 7 * 86400;
      let dateEnd = Math.floor(Date.now() / 1000);
      var config = {
        method: "get",
        url:
          process.env.API_ROOT_URL + "/clocks/presence?userId=" +
          this.store.user.id +
          "&periodicity=day&start=" +
          dateStart +
          "&end=" +
          dateEnd,
        headers: {
          Authorization: "Bearer " + this.store.jwt,
        },
      };

      await axios(config)
        .then(function (response) {
          console.log(response.data.data);
          final = response.data.data;
        })
        .catch(function (error) {
          console.log(error);
        });
      this.store.daily = final;
      this.SortDay();
    },
    async ValueGraphDailyAllUser() {
      let final;
      let dateStart = Math.floor(Date.now() / 1000) - 7 * 86400;
      let dateEnd = Math.floor(Date.now() / 1000);
      var config = {
        method: "get",
        url:
          process.env.API_ROOT_URL + "/clocks/presence?periodicity=day&start=" +
          dateStart +
          "&end=" +
          dateEnd,
        headers: {
          Authorization: "Bearer " + this.store.jwt,
        },
      };

      await axios(config)
        .then(function (response) {
          console.log(response.data.data);
          final = response.data.data;
        })
        .catch(function (error) {
          console.log(error);
        });
      this.store.dailyAllUser = final;
      this.SortDayAllUser();
    },
    SortDayAllUser() {
      let allDate = [];
      let dayName = [];
      let dura = [];
      let tmpDate = [];
      let time = null;
      let totaltime = null;
      this.store.dailyAllUser.forEach(function (item) {
        let tmp = item.periodicity.split(":");
        let day = tmp[0];
        let month = tmp[1] - 1;
        let year = tmp[2];
        let date = new Date(year, month, day);
        allDate.push({ date: date, data: item.duration });
      });
      allDate.sort(function (a, b) {
        return a.date - b.date;
      });
      allDate.forEach(function (item) {
        let name = item.date.toLocaleDateString("fr-FR", { weekday: "long" });
        name = name.charAt(0).toUpperCase() + name.slice(1);
        item.date = name;
        dayName.push(name);
        console.log(item.data);
        totaltime = totaltime + item.data;
        let d = Number(item.data);
        var h = Math.floor(d / 3600);
        var m = Math.floor((d % 3600) / 60);
        var s = Math.floor((d % 3600) % 60);
        time = "" + h + ".";
        if (m < 10) {
          time = time + "0" + m;
        } else {
          time = time + m;
        }
        if (s > 0) {
          if (s < 10) {
            time = time + "0" + s;
          } else {
            time = time + s;
          }
        }
        item.data = time;
        tmpDate.push(item.date);
        /* dura.push(parseFloat(time)); */
      });
      let unique = [...new Set(dayName)];
      let sameDate = null;
      let average = null;
      let tmpData = [];
      for (let i = 0; i !== unique.length; i++) {
        sameDate = allDate.filter((item) => item.date === unique[i]);
        sameDate.forEach(function (item) {
          item.data = parseFloat(item.data);
        });
        average =
          sameDate.reduce((total, next) => total + next.data, 0) /
          sameDate.length;
        average = Number(average);
        average = average.toFixed(3);
        tmpData.push(average);
      }
      this.store.series3[1].data = tmpData;
    },
    onlyUnique(value, index, self) {
      return self.indexOf(value) === index;
    },
    SortWeekAllUser() {
      let allDate = [];
      let dayName = [];
      let dura = [];
      let tmpDate = [];
      let time = null;
      let totaltime = null;
      this.store.weeklyAllUser.forEach(function (item) {
        allDate.push({ date: item.periodicity, data: item.duration });
      });
      allDate.sort(function (a, b) {
        return a.date - b.date;
      });
      allDate.forEach(function (item) {
        item.date = "Semaine " + item.date;
        dayName.push(item.date);
        totaltime = totaltime + item.data;
        let d = Number(item.data);
        var h = Math.floor(d / 3600);
        var m = Math.floor((d % 3600) / 60);
        var s = Math.floor((d % 3600) % 60);
        time = "" + h + ".";
        if (m < 10) {
          time = time + "0" + m;
        } else {
          time = time + m;
        }
        if (s > 0) {
          if (s < 10) {
            time = time + "0" + s;
          } else {
            time = time + s;
          }
        }
        item.data = time;
        tmpDate.push(item.date);
        /* dura.push(parseFloat(time)); */
      });
      let unique = [...new Set(dayName)];
      console.log(unique)
      let sameDate = null;
      let average = null;
      let tmpData = [];
      for (let i = 0; i !== unique.length; i++) {
        sameDate = allDate.filter((item) => item.date === unique[i]);
        sameDate.forEach(function (item) {
          item.data = parseFloat(item.data);
        });
        average =
          sameDate.reduce((total, next) => total + next.data, 0) /
          sameDate.length;
        average = Number(average);
        average = average.toFixed(3);
        tmpData.push(average);
      }
      console.log(allDate);
      this.store.series3Weekly[1].data = tmpData;
    },
    SortMonthAllUser() {
      let allDate = [];
      let dayName = [];
      let dura = [];
      let tmpDate = [];
      let time = null;
      let totaltime = null;
      const monthNames = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
      ];
      this.store.monthlyAllUser.forEach(function (item) {
        let date = monthNames[item.periodicity - 1];
        allDate.push({ date: date, data: item.duration });
      });
      allDate.sort(function (a, b) {
        return a.date - b.date;
      });
      allDate.forEach(function (item) {
        dayName.push(item.date);
        totaltime = totaltime + item.data;
        let d = Number(item.data);
        var h = Math.floor(d / 3600);
        var m = Math.floor((d % 3600) / 60);
        var s = Math.floor((d % 3600) % 60);
        time = "" + h + ".";
        if (m < 10) {
          time = time + "0" + m;
        } else {
          time = time + m;
        }
        if (s > 0) {
          if (s < 10) {
            time = time + "0" + s;
          } else {
            time = time + s;
          }
        }
        item.data = time;
        tmpDate.push(item.date);
        /* dura.push(parseFloat(time)); */
      });
      let unique = [...new Set(dayName)];
      console.log(unique)
      let sameDate = null;
      let average = null;
      let tmpData = [];
      for (let i = 0; i !== unique.length; i++) {
        sameDate = allDate.filter((item) => item.date === unique[i]);
        sameDate.forEach(function (item) {
          item.data = parseFloat(item.data);
        });
        average =
          sameDate.reduce((total, next) => total + next.data, 0) /
          sameDate.length;
        average = Number(average);
        average = average.toFixed(3);
        tmpData.push(average);
      }
      console.log(allDate);
      this.store.series3Monthly[1].data = tmpData;
    },
    SortMonthly() {
      let allDate = [];
      let dayName = [];
      let dura = [];
      let dura2 = [];
      let time = null;
      let totaltime = null;
      const monthNames = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
      ];
      this.store.monthly.forEach(function (item) {
        let date = monthNames[item.periodicity - 1];
        allDate.push({ date: date, data: item.duration });
      });
      allDate.sort(function (a, b) {
        return a.date - b.date;
      });
      allDate.forEach(function (item) {
        dayName.push(item.date);
        totaltime = totaltime + item.data;
        let d = Number(item.data);
        var h = Math.floor(d / 3600);
        var m = Math.floor((d % 3600) / 60);
        var s = Math.floor((d % 3600) % 60);
        time = "" + h + ".";
        if (m < 10) {
          time = time + "0" + m;
        } else {
          time = time + m;
        }
        if (s > 0) {
          if (s < 10) {
            time = time + "0" + s;
          } else {
            time = time + s;
          }
        }
        dura.push(parseFloat(time));
      });
      for (let i = 0; i !== allDate.length; i++) {
        dura2.push(
          Math.round(this.PercentageChart(allDate[i].data, totaltime))
        );
      }
      this.store.optionsMonthly.xaxis.categories = dayName;
      this.store.options3Monthly.xaxis.categories = dayName;
      this.store.options2Monthly.labels = dayName;
      this.store.seriesMonthly = [
        {
          name: "Duration",
          data: dura,
        },
      ];
      this.store.series2Monthly = dura2;
      this.store.series3Monthly[0].data = dura;
    },
    SortWeek() {
      let allDate = [];
      let dayName = [];
      let dura = [];
      let dura2 = [];
      let time = null;
      let totaltime = null;
      this.store.weekly.forEach(function (item) {
        allDate.push({ date: item.periodicity, data: item.duration });
      });
      allDate.sort(function (a, b) {
        return a.date - b.date;
      });
      allDate.forEach(function (item) {
        item.date = "Week " + item.date;
        dayName.push(item.date);
        totaltime = totaltime + item.data;
        let d = Number(item.data);
        var h = Math.floor(d / 3600);
        var m = Math.floor((d % 3600) / 60);
        var s = Math.floor((d % 3600) % 60);
        time = "" + h + ".";
        if (m < 10) {
          time = time + "0" + m;
        } else {
          time = time + m;
        }
        if (s > 0) {
          if (s < 10) {
            time = time + "0" + s;
          } else {
            time = time + s;
          }
        }
        dura.push(parseFloat(time));
      });
      for (let i = 0; i !== allDate.length; i++) {
        dura2.push(
          Math.round(this.PercentageChart(allDate[i].data, totaltime))
        );
      }
      this.store.optionsWeekly.xaxis.categories = dayName;
      this.store.options3Weekly.xaxis.categories = dayName;
      this.store.options2Weekly.labels = dayName;
      this.store.seriesWeekly = [
        {
          name: "Duration",
          data: dura,
        },
      ];
      this.store.series2Weekly = dura2;
      this.store.series3Weekly[0].data = dura;
    },
    SortDay() {
      let allDate = [];
      let dayName = [];
      let dura = [];
      let dura2 = [];
      let time = null;
      let totaltime = null;
      this.store.daily.forEach(function (item) {
        let tmp = item.periodicity.split(":");
        let day = tmp[0];
        let month = tmp[1] - 1;
        let year = tmp[2];
        let date = new Date(year, month, day);
        allDate.push({ date: date, data: item.duration });
      });
      allDate.sort(function (a, b) {
        return a.date - b.date;
      });
      allDate.forEach(function (item) {
        let name = item.date.toLocaleDateString("fr-FR", { weekday: "long" });
        name = name.charAt(0).toUpperCase() + name.slice(1);
        dayName.push(name);
        console.log(item.data);
        totaltime = totaltime + item.data;
        let d = Number(item.data);
        var h = Math.floor(d / 3600);
        var m = Math.floor((d % 3600) / 60);
        var s = Math.floor((d % 3600) % 60);
        time = "" + h + ".";
        if (m < 10) {
          time = time + "0" + m;
        } else {
          time = time + m;
        }
        if (s > 0) {
          if (s < 10) {
            time = time + "0" + s;
          } else {
            time = time + s;
          }
        }
        dura.push(parseFloat(time));
      });
      for (let i = 0; i !== allDate.length; i++) {
        dura2.push(
          Math.round(this.PercentageChart(allDate[i].data, totaltime))
        );
      }
      this.store.options.xaxis.categories = dayName;
      this.store.options3.xaxis.categories = dayName;
      this.store.options2.labels = dayName;
      this.store.series = [
        {
          name: "Duration",
          data: dura,
        },
      ];
      this.store.series2 = dura2;
      this.store.series3[0].data = dura;
    },
    PercentageChart(partialValue, totalValue) {
      return (100 * partialValue) / totalValue;
    },
  },
  mounted() {
    this.ValueGraphDaily();
    this.ValueGraphDailyAllUser();
    this.ValueGraphWeekly(),
    this.ValueGraphWeeklyAllUser(),
    this.ValueGraphMonthly(),
    this.ValueGraphMonthlyAllUser()
  },
});
</script>

<style>
.q-stepper--horizontal .q-stepper__step-inner {
  padding: 0px;
}
</style>
