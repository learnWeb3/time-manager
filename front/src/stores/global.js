import { defineStore } from "pinia";

export const useGlobalStore = defineStore("global", {
  state: () => ({
    step: 1,
    user: null,
    menu: 'User Detail',
  }),
  getters: {},
  actions: {},
});
