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
        text: "User presence time evolution (current user vs all other users)",
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
        name: "Duration",
        data: null,
      },
      {
        name: "Average All User",
        data: [],
      },
    ],
    optionsMonthly: {
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
    options2Monthly: {
      chart: {
        id: "vuechart-example",
      },
      labels: null,
    },
    seriesMonthly: [],
    series2Monthly: [],
    options3Monthly: {
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
        text: "User presence time evolution (current user vs all other users)",
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
    series3Monthly: [
      {
        name: "Duration",
        data: null,
      },
      {
        name: "Average All User",
        data: [],
      },
    ],
    optionsWeekly: {
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
    options2Weekly: {
      chart: {
        id: "vuechart-example",
      },
      labels: null,
    },
    seriesWeekly: [],
    series2Weekly: [],
    options3Weekly: {
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
        text: "User presence time evolution (current user vs all other users)",
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
    series3Weekly: [
      {
        name: "Duration",
        data: null,
      },
      {
        name: "Average All User",
        data: [],
      },
    ],
    user: null,
    menu: "User Detail",
    menuGraphDaily: true,
    menuGraphWeekly: false,
    menuGraphMonthly: false,
    daily: null,
    dailyAllUser: null,
    weekly: null,
    weeklyAllUser: null,
    monthly: null,
    monthlyAllUser: null,
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
    selectedUser:  {
      id: "",
      username: "",
      email: "",
      password: "",
      jobtitle: "",
      role: "",
    },
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
