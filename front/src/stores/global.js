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
      profession: "",
    },
    selectedUser: null
  }),
  getters: {},
  actions: {},
});
