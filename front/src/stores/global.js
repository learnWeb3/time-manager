import { defineStore } from "pinia";

export const useGlobalStore = defineStore("global", {
  state: () => ({
    step: 1,
    user: null,
    menu: 'User Detail',
    userEdit: true,
    inputEdit: false,
    stepUser: 1,
    dialog: false,
    createUser: {
      username: "",
      email: "",
      password: "",
      jobtitle: "",
      role: "",
    },
    selectedUser: null,
    allUser: null,
    role: [
      {
        name: "Admin",
        value: 1,
      },
      {
        name: "Manager",
        value: 2,
      },
      {
        name: "User",
        value: 3,
      },
    ]
  }),
  getters: {},
  actions: {},
});
