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
            <img src="../../public/icons/manager.png" />
            <q-menu>
              <div class="row no-wrap q-pa-md">
                <div class="column items-center">
                  <q-avatar size="72px">
                    <img src="../../public/icons/manager.png" />
                  </q-avatar>

                  <div class="text-subtitle1 q-mt-sm q-mb-xs">Manager</div>

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
        <div class="col-12 row justify-center q-mx-md q-my-xl">
          <div class="col-10 row">
            <div class="col-12">
              <span
                class="text-weight-bold"
                style="font-size: 1.5em; color: #001f54"
                >Detail</span
              >
            </div>
            <div class="col-12 q-py-md">
              <q-table
                title="Treats"
                :rows="store.allUser"
                :columns="columns"
                :filter="filter"
                row-key="username"
              >
                <template v-slot:top>
                  <div class="col-12 flex justify-end">
                    <q-input
                      dense
                      debounce="300"
                      color="primary"
                      v-model="filter"
                    >
                      <template v-slot:append>
                        <q-icon name="search" />
                      </template>
                    </q-input>
                  </div>
                </template>
                <template v-slot:header="props">
                  <q-tr :props="props">
                    <q-th auto-width />
                    <q-th
                      v-for="col in props.cols"
                      :key="col.name"
                      :props="props"
                    >
                      {{ col.label }}
                    </q-th>
                  </q-tr>
                </template>

                <template v-slot:body="props">
                  <q-tr :props="props">
                    <q-td auto-width>
                      <q-btn
                        size="sm"
                        color="accent"
                        round
                        dense
                        icon="visibility"
                        @click="
                          (store.selectedUser = props.row), ActiveUser()
                        "
                      />
                    </q-td>
                    <q-td
                      v-for="col in props.cols"
                      :key="col.name"
                      :props="props"
                    >
                      {{ col.value }}
                    </q-td>
                    <q-td auto-width>
                      <q-btn
                        flat
                        round
                        style="color: #001f54"
                        icon="edit"
                        @click="
                          (store.selectedUser = props.row), (dialog = true)
                        "
                      />
                      <q-btn flat round color="negative" icon="delete" @click="
                          (store.selectedUser = props.row), DeleteUser()
                        " />
                    </q-td>
                  </q-tr>
                </template>
              </q-table>
              <q-dialog v-model="dialog">
                <q-card>
                  <q-card-section>
                    <div class="text-h6">Update User</div>
                  </q-card-section>

                  <q-separator />

                  <q-card-section
                    style="max-height: 60vh"
                    class="col-12 row scroll"
                  >
                    <div class="col-12 row items-center justify-center">
                      <div class="col-8 q-mt-lg">
                        <q-input
                          outlined
                          v-model="store.selectedUser.username"
                          label="Username"
                        />
                      </div>
                    </div>
                    <div class="col-12 row items-center justify-center">
                      <div class="col-8 q-mt-lg">
                        <q-input
                          outlined
                          v-model="store.selectedUser.password"
                          label="Password"
                        />
                      </div>
                    </div>
                    <div class="col-12 row items-center justify-center">
                      <div class="col-8 q-mt-lg">
                        <q-input
                          outlined
                          v-model="store.selectedUser.email"
                          label="Email"
                        />
                      </div>
                    </div>
                    <div class="col-12 row items-center justify-center">
                      <div class="col-8 q-mt-lg">
                        <q-input
                          outlined
                          v-model="store.selectedUser.jobtitle"
                          label="Profession"
                        />
                      </div>
                    </div>
                    <div class="col-12 row items-center justify-center">
                      <div class="col-8 q-my-lg">
                        <q-select
                          outlined
                          v-model="store.selectedUser.role"
                          emit-value
                          map-options
                          option-label="name"
                          :options="store.role"
                          label="Role"
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
                      ValueGraphDaily()
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
                      ValueGraphWeekly()
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
                      ValueGraphMonthly()
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
            </div>
          </q-slide-transition>
          <q-slide-transition appear>
            <div v-if="store.menuGraphWeekly" class="col-12 row q-mt-md">
              <div class="col-12 q-mt-md">
                <BarChartWeekly />
              </div>
            </div>
          </q-slide-transition>
          <q-slide-transition appear>
            <div v-if="store.menuGraphMonthly" class="col-12 row q-mt-md">
              <div class="col-12 q-mt-md">
                <BarChartMonthly />
              </div>
            </div>
          </q-slide-transition></div
      ></q-step>
    </q-stepper>
  </div>
</template>

<script>
import { defineComponent, ref } from "vue";
import { useGlobalStore } from "stores/global";
import LeftMenu from "components/LeftMenu.vue";
import BarChartDaily from "src/components/Charts/BarChartDaily.vue";
import BarChartMonthly from "src/components/Charts/BarChartMonthly.vue";
import BarChartWeekly from "src/components/Charts/BarChartWeekly.vue";
import axios from "axios";

const columns = [
  {
    name: "name",
    required: true,
    label: "Username",
    align: "left",
    field: (row) => row.username,
    format: (val) => `${val}`,
    sortable: true,
  },
  {
    name: "email",
    align: "center",
    label: "Email",
    field: "email",
    sortable: true,
  },
  {
    name: "jobtitle",
    label: "Profession",
    field: "jobtitle",
    sortable: true,
  },
];

export default defineComponent({
  name: "AllUser",

  setup() {
    const store = useGlobalStore();
    const leftDrawerOpen = ref(false);
    const dialog = ref(false);
    const filter = ref("");

    return {
      store,
      leftDrawerOpen,
      dialog,
      columns,
      filter,
    };
  },
  methods: {
    ActiveUser() {
      this.store.user = this.store.selectedUser;
      this.store.user.password = "";
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
    async UpdateUser() {
      if (this.store.selectedUser.role.name) {
        this.store.selectedUser.role = this.store.user.selectedUser.value;
      }
      var data = {
        user: {
          role: this.store.selectedUser.role,
          username: this.store.selectedUser.username,
          email: this.store.selectedUser.email,
          password: this.store.selectedUser.password,
          jobtitle: this.store.selectedUser.jobtitle,
        },
      };

      var config = {
        method: "put",
        url: process.env.API_ROOT_URL + "/users/" + this.store.selectedUser.id,
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
        url: process.env.API_ROOT_URL + "/users/" + this.store.selectedUser.id,
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
    GoBack() {
      this.store.step = 1;
    },
    async ValueGraphMonthly() {
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
      this.store.monthly = final;
      this.SortMonthly();
    },
    async ValueGraphWeekly() {
      let final;
      let dateStart = Math.floor(Date.now() / 1000) - 7 * 86400 * 12;
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
      this.store.weekly = final;
      this.SortWeek();
    },
    async ValueGraphDaily() {
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
      this.store.daily = final;
      this.SortDay();
    },
    onlyUnique(value, index, self) {
      return self.indexOf(value) === index;
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
        dura.push({date: item.date, data:parseFloat(time)});
      });
      let unique = [...new Set(dayName)];
      let sameDate = null;
      let average = null;
      let tmpData = [];
      for (let i = 0; i !== unique.length; i++) {
        sameDate = dura.filter((item) => item.date === unique[i]);
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
      this.store.optionsMonthly.xaxis.categories = unique;
      this.store.options3Monthly.xaxis.categories = unique;
      this.store.options2Monthly.labels = unique;
      this.store.seriesMonthly = [
        {
          name: "Duration average all user",
          data: tmpData,
        },
      ];
      this.store.series3Monthly[0].data = tmpData;
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
        dura.push({date: item.date, data:parseFloat(time)});
      });
      let unique = [...new Set(dayName)];
      let sameDate = null;
      let average = null;
      let tmpData = [];
      for (let i = 0; i !== unique.length; i++) {
        sameDate = dura.filter((item) => item.date === unique[i]);
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
      this.store.optionsWeekly.xaxis.categories = unique;
      this.store.options3Weekly.xaxis.categories = unique;
      this.store.options2Weekly.labels = unique;
      this.store.seriesWeekly = [
        {
          name: "Duration average all user",
          data: tmpData,
        },
      ];
      this.store.series3Weekly[0].data = tmpData;
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
        dura.push({date: name, data:parseFloat(time)});
      });
      let unique = [...new Set(dayName)];
      let sameDate = null;
      let average = null;
      let tmpData = [];
      for (let i = 0; i !== unique.length; i++) {
        sameDate = dura.filter((item) => item.date === unique[i]);
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
      this.store.options.xaxis.categories = unique;
      this.store.options3.xaxis.categories = unique;
      this.store.options2.labels = unique;
      this.store.series = [
        {
          name: "Duration average all user",
          data: tmpData,
        },
      ];
      this.store.series3[0].data = tmpData;
    },
    PercentageChart(partialValue, totalValue) {
      return (100 * partialValue) / totalValue;
    },
  },
  mounted() {
    this.ValueGraphDaily();
    this.ValueGraphWeekly();
      this.ValueGraphMonthly();
  },
  components: {
    LeftMenu,
    BarChartDaily,
    BarChartMonthly,
    BarChartWeekly,
  },
});
</script>
