<template>
  <div>
    <nav>
      <router-link to="/update"
        ><span>Mettre à jours mes données utilisateurs</span></router-link>
    </nav>
    <h2>Dashboard de {{ user.username }}</h2>
    <h3 v-show="!working">
      Cliquez sur <strong>Démarrer</strong> pour lancer le timer
    </h3>
    <h3 v-show="working">Vous travaillez depuis {{ workingDurationTime }}</h3>
    <br />
    <div>
      <button v-show="!working && !showPopUp" type="button" @click="toggleCount">
        <img src="../assets/ressource/images/start.png" alt="Start" />
      </button>
      <button v-show="working" type="button" @click="showPopUp = true">
        <img src="../assets/ressource/images/stop.png" alt="Stop" />
      </button>
      <button v-show="working" @click="togglePause"><img src="../assets/ressource/images/pause.png" alt="pause" /></button>
      <div v-show="showPopUp">
        <p>Êtes-vous sur de vouloir signaler une fin de travail ?</p>
        <button @click="toggleCount">Yes</button>
        <button @click="showPopUp = false">No</button>
      </div>
      <p v-show="submitSuccess">Vos horaires ont bien été soumis.</p>
    </div>
    <div>
        <barChartWeek />
    </div>
    </div>
        <barChartMonths />
    <div v-if="user.role_id===1 || user.role_id===2">
      <h4>Gérer mon équipe</h4>
      <table>
        <thead>
          <tr>
            <th><button @click="toggleCreateUser"><img src="../assets/ressource/images/Plus_Circle.png" alt="add_new_user"></button></th>
            <th>Nom d'utilisateur</th>
            <th>E-mail</th>
            <th>Rôle</th>
            <th>Equipe</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in teamMates" :key="user.id">
            <td><button @click="toggleEditing(user.id)"><img src="../assets/ressource/images/update.png" alt="mise à jours données utilisateurs"/></button></td>
            <td :style="{ 'background-color': user.clocks ? 'green' : 'red' }">
              {{ editing ? '' : user.username }}
              <template v-if="editing">
                <input v-model="user.username" />
              </template>
            </td>
            <td>
              {{ editing ? '' : user.role_id }}
              <template v-if="editing">
                <input v-model="user.role_id" />
              </template>
            </td>
            <td>
              {{ editing ? '' : user.team_id }}</td>
              <template v-if="editing">
                <input v-mode="user.team_id" />
              </template>
          </tr>
        </tbody>
      </table>
      <div>
        <createUserComponent v-if="showCreateUserVue" />
      </div>
      <div>
        <div>
              <select v-model="selectedUserId">
                <option value="" disabled>Sélectionnez un employée</option>
                <option v-for="user in team" :value="user.user.id" :key="user.user.id">{{ user.user.username }}</option>
              </select>
          </div>
          <div v-if="selectedUserId">
              <barChartWeekSpecificUser :selectedUserId="selectedUserId"/>
              <LineChartMonthsSpecitifUser :selectedUserId="selectedUserId" />
          </div>
          <div v-if="selectedUserId">
            <barChartAnnualSpecificUser :selectedUserId="selectedUserId" />
          </div>
      </div>
    </div>
    <div>
      <button @click="logoff">Se déconnecter</button>
    </div>
</template>

<script>
import moment from "moment";
import { baseApiUrl } from "./services/api";
import router from "@/components/services/router";
import barChartWeek from "@/components/graph/user/BarChartWeek.vue";
import barChartMonths from "@/components/graph/user/BarChartMonths.vue";
import barChartWeekSpecificUser from "@/components/graph/manager/BarChartWeekSpecificUser.vue";
import barChartAnnualSpecificUser from "@/components/graph/manager/BarChartAnnualSpecificUser.vue";
import lineChartMonthsSpecitifUser from "@/components/graph/manager/LineChartMonthsSpecitifUser.vue";
import createUserComponent from "@/components/Specificcomponents/createUser.vue";
import store from "@/components/services/store.js";

export default {
  name: "dashboardComponent",
  components: { barChartWeek, barChartMonths, barChartWeekSpecificUser, barChartAnnualSpecificUser, lineChartMonthsSpecitifUser, createUserComponent },
  data() {
    return {
      showPopUp: false,
      startClock: false,
      interval: null,
      workingTime: {
        start: null,
        end: null,
      },
      submitSuccess: null,
      selectedUserId: '',
      clocksTeam: [],
      showCreateUserVue: false,
      showUpdateVue: false,
      pause: false,
      editing: false,
    };
  },

  created() {
    this.launchClock();
  },

  computed: {
    //get user from store
    user() {
      return this.$store.state.user;
    },

    //get all user on the team's manager
    teamMates() {
      return this.$store.state.team;
    },

    working() {
      return this.$store.state.cloking;
    },

    //get count from store and transform it in hh:mm:ss
    workingDurationTime() {
      const duration = moment.duration(
        this.$store.state.workingDurationTime,
        "seconds"
      );
      const hours = duration.hours().toString().padStart(2, "0");
      const minutes = duration.minutes().toString().padStart(2, "0");
      const seconds = duration.seconds().toString().padStart(2, "0");
      return `${hours}:${minutes}:${seconds}`;
    },
  },

  methods: {

    togglePause() {
      if (this.working) {
        this.pause = true;
        this.$store.dispatch("setClocking", false);
        this.launchClock();
      } else {
        this.working = false;
        this.$store.dispatch("setCloking", true);
        this.launchClock();
      }
    },

    //method for switching user working
    toggleCount() {
      if (this.working) {
        this.working = false;
        this.$store.dispatch("setClocking", false);
        this.launchClock()
        this.workingTime.end = moment().format("YYYY-MM-DD HH:mm:ss");
        this.submitWorkingTime();
        this.showPopUp = false;
      } else {
        this.working = true;
        console.log(this.working);
        this.$store.dispatch("setClocking", true);
        console.log(this.$store.state.cloking);
        this.launchClock()
        this.workingTime.start = moment().format("YYYY-MM-DD HH:mm:ss");
      }
    },
    
    launchClock() {
      if (this.$store.state.cloking) {
        this.interval = setInterval(this.increment, 1000);
      } else {
        clearInterval(this.interval);
      }
    },

    // Call the mutation of workingtimeDuration in store
    increment() {
      this.$store.commit("increment");
    },

    toggleCreateUser() {
      this.showCreateUserVue = !this.showCreateUserVue;
    },

    //submit workingTime on API
    async submitWorkingTime() {
      const apiUrl = `${baseApiUrl}/workingtimes/users/${this.$store.state.user.id}`;
      try {
        const response = await fetch(apiUrl, {
          method: "POST",
          headers: {
            Authorization: `Bearer ${this.$store.state.xsrfToken}`,
          },
          body: JSON.stringify(this.workingTime),
        });
        if (response.status === 200) {
          this.submitSuccess = true;
        }
      } catch (error) {
        console.error(error);
      }
    },

    async getClockingTeam() {
      for (const entry of this.TeamMates) {
        const apiUrl = `${baseApiUrl}/clocks/${entry.id}`;
        try {
          const response = await fetch(apiUrl, {
            headers: {
              "Authorization": `Bearer ${this.$store.state.xsrfToken}`
            }
          });
          if (response.status === 200) {
            const responseData = await response.json();
            this.data = responseData.data;
            entry.clocks = this.data.status;
          }
        } catch (error) {
          console.log(error);
        }
      }
    },

    async toggleEditing(id) {

      if (this.editing) {

        const userToEdit = this.teamMates.find((user) => user.id === id);

        if (userToEdit) {
          const updatedUser = {
            username: userToEdit.username,
            email: userToEdit.email,
            role_id: userToEdit.role_id,
            team_id: userToEdit.team_id,
          };
          const apiUrl = `${baseApiUrl}/users/${id}`;
          try {
            const response = await fetch(apiUrl, {
              method: "PUT",
              headers: {
                "Authorization": `Bearer ${store.state.xsrfToken}`,
              },
              body: JSON.stringify(updatedUser)
            });
            if (response.status === 201) {
              this.editing = false;
            }
          } catch (error) {
            console.error("Erreur lors de la création de l'utilisateur.", error);
            this.editing = false;
          }
        }
      } else {
        this.editing = true;
      }
  },

    logoff() {
      this.$store.dispatch("setTokens", "");
      router.push("/login");
    },
  },
};
</script>