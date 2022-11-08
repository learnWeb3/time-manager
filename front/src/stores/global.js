import { defineStore } from "pinia";
import { LocalStorage } from "quasar";

export const useGlobalStore = defineStore("global", {
  state: () => ({
    jwt: LocalStorage.getItem("JWT"),
    step: 1,
    stepLanding: 1,
    avatar: null,
    options: {
      chart: {
        type: "bar",
        id: "vuechart-example",
      },
      xaxis: {
        categories: null,
      },
      title: {
        text: "Hours",
      },
    },
    options2: {
      chart: {
        id: "vuechart-example",
      },
      labels: null,
    },
    series: [],
    series2: [],
    options3: {
      chart: {
        height: 350,
        type: "line",
        zoom: {
          enabled: false,
        },
      },
      dataLabels: {
        enabled: false,
      },
      stroke: {
        curve: "straight",
      },
      title: {
        text: "Product Trends by Month",
        align: "left",
      },
      grid: {
        row: {
          colors: ["#f3f3f3", "transparent"], // takes an array which will be repeated on columns
          opacity: 0.5,
        },
      },
      xaxis: {
        categories: null,
      },
    },
    series3: [
      {
        name: "Desktops",
        data: null,
      },
      {
        name: "Low - 2013",
        data: [12, 11, 14, 18, 17, 13, 13, 34, 43],
      },
    ],
    user: null,
    menu: "User Detail",
    menuGraph: "Daily",
    daily: null,
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
    ],
  }),
  getters: {},
  actions: {},
});
