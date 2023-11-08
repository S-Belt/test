import Vuex from 'vuex';
import { baseApiUrl } from './api';
import moment from "moment";
import createPersistedState from 'vuex-persistedstate';

export default new Vuex.Store({
  state: {
    xsrfToken: "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJleHAiOjE3MDE4MTI0OTYsImlhdCI6MTY5OTM5MzI5NiwiaXNzIjoiYXBpIiwianRpIjoiOTcxMWRkYzAtMDc3My00ZTcxLTg1OTQtMmU2ODU4NzBiNDVlIiwibmJmIjoxNjk5MzkzMjk1LCJzdWIiOiJiYzE0MDgxMS1jMjZlLTQ5N2QtYTE1NS1mMWVhZmFjY2YwNTQiLCJ0eXAiOiJhY2Nlc3MifQ.5QuaLvVXe45QBsuigDSi9GeKCTAB6HImyy2cgN1YncN7_OQdoqfgwEXyxops5TKakIKHg_sNTe346AGuP7XIOg",
    user: {},
    team: [],
    workingDurationTime: 0,
    cloking: false,
  },

  mutations: {
    setXsrfToken(state, token) {
      state.xsrfToken = token;
      },

    setUser(state, myUser) {
      state.user = myUser;
      },

    increment(state) {
      state.workingDurationTime += 1;
      },

    setWorkingtimeUser(state, data) {
      state.workingtimeUser = data;
      },

    updateUser(state, updatedData) {
      if (updatedData.username) {
        state.user.username = updatedData.username;
      }
      if (updatedData.email) {
        state.user.email = updatedData.email;
      }
    },

    toggleClocking(state, boolean) {
      state.cloking = boolean;
      },
    
    addToTeam(state, data) {
      state.team.append(data);
    }
  },

  actions: {

    async setClocking({ commit }, boolean) {
      commit("toggleClocking", boolean);
      const apiUrl = `${baseApiUrl}/clocks/${this.state.user.id}`;
      const data = {
        time: moment().format("YYYY-MM-DD HH:mm:ss"),
        status: boolean,
      };
      try {
        await fetch(apiUrl, {
          method: "POST",
          mode: "no-cors",
          cache: "no-cache",
          credentials: "same-origin",
          headers: {
            "Authorization": `Bearer ${this.state.xsrfToken}`,
            "Content-Type": "application/json",
          },
          body: JSON.stringify(data),
        });
      } catch (error) {
        console.error(error);
      }
    },

    setTokens({ commit }, xsrfToken) {
      commit("setXsrfToken", xsrfToken);
      },

    clearTokens({ commit }) {
      commit("setXsrfToken", "");
      },

    setUser({ commit }, data) {
      commit("setUser", data)
    },  

    async getUser({ commit }, id) {
      try {
        const response = await fetch(`${baseApiUrl}/users/${id}`, {
          headers: {
            "Authorization": `Bearer ${this.store.state.xsrfToken}`
          }
        });
        const data = await response.json();
        console.log(data);
        commit("setUser", data);
      } catch (error) {
        console.log(error);
      }
    },

    async getAllTeamMates({ commit }) {
      const apiUrl = `${baseApiUrl}/users`
      try {
        const response = await fetch(apiUrl, {
          headers: {
            "Authorization": `Bearer ${this.store.state.xsrfToken}`
          }
        });
        const data = await response.json();
        data.forEach((entry) => {
          if (entry.team === this.state.store.user.team) {
            commit("addToTeam", entry);
          }
        });
      } catch (error) {
        console.log(error);
      }
    },
  },
  getters: {
    isAuthenticated: (state) => !!state.xsrfToken,
  },
    plugins: [createPersistedState()]
});
