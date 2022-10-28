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
                :rows="rows"
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
                        @click="props.expand = !props.expand"
                        :icon="props.expand ? 'remove' : 'add'"
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
                        @click="store.selectedUser = props.row, dialog = true"
                      />
                      <q-btn flat round color="negative" icon="delete" />
                    </q-td>
                  </q-tr>
                  <q-tr v-show="props.expand" :props="props">
                    <q-td colspan="100%">
                      <div class="text-left">Working Time</div>
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
                    style="max-height: 50vh"
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
                          v-model="store.selectedUser.email"
                          label="Email"
                        />
                      </div>
                    </div>
                    <div class="col-12 row items-center justify-center">
                      <div class="col-8 q-my-lg">
                        <q-input
                          outlined
                          v-model="store.selectedUser.profession"
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
            </div>
          </div>
        </div>
      </q-step>
      <q-step :name="2" title="Dashboard" :done="store.step > 2"> </q-step>
    </q-stepper>
  </div>
</template>

<script>
import { defineComponent, ref } from "vue";
import { useGlobalStore } from "stores/global";
import LeftMenu from "components/LeftMenu.vue";

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
    name: "profession",
    label: "Profession",
    field: "profession",
    sortable: true,
  },
];

const rows = [
  {
    username: "Samuel Cadau",
    email: "test@gmail.com",
    profession: "Full-stack",
  },
  {
    username: "Antoine Le-Guillou",
    email: "test@gmail.com",
    profession: "Full-stack2",
  },
  {
    username: "Mohamed Lahcen",
    email: "test@gmail.com",
    profession: "Full-stack3",
  },
  {
    username: "Charlène Obadia",
    email: "test@gmail.com",
    profession: "Full-stack4",
  },
  {
    username: "Serge le bidon",
    email: "test@gmail.com",
    profession: "Full-stack5",
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
      rows,
      filter,
    };
  },
  components: {
    LeftMenu,
  },
});
</script>
