<template>
    <div>
        <h3>Créer un nouvel utilisateur</h3>
        <form @submit.prevent="createUser">
            <input v-model="formCreate.firstname" type="text" placeholder="Firstname" required /><br>
            <input v-model="formCreate.lastname" type="text" placeholder="Lastname" required /><br>
            <input v-model="formCreate.email" type="email" placeholder="Email" required /><br>
            <input v-model="formCreate.team" type="text" placeholder="Team" required /><br>
            <button type="submit">Créer l'utilisateur</button>
        </form>
        <p v-show="createUserSuccess">L'ajout de l'utilisateur a été effectué.</p>
    </div>
</template>

<script>
import { baseApiUrl} from "@/components/services/api";
import store from "@/components/services/store";

export default {
        name: 'createUserComponent',
        data() {
            return {
                formCreate: {
                    firstname: '',
                    lastname: '',
                    email: '',
                    team: ''
                },
                createUserSuccess: false,
            }
        },
        methods: {

        formatName(firstName, lastName) {
            const formattedFirstName = firstName.charAt(0).toUpperCase() + firstName.slice(1).toLowerCase();
            const formattedLastName = lastName.charAt(0).toUpperCase() + lastName.slice(1).toLowerCase();
            return formattedFirstName + formattedLastName;
        },

        async createUser() {
            this.username = this.formatName(this.formCreate.firstname, this.formCreate.lastname);
            if (store.state.user.rang === 1) {
                this.rang = 2;
            } else {
                this.rang = 3;
            }
            const apiUrl = `${baseApiUrl}/users`;
            const userData = {
                user: {
                    username: this.username,
                    email: this.formCreate.email,
                    role_id: this.rang,
                    team_id: store.state.user.team_id
                }
            };
            console.log(JSON.stringify(userData));
            try {
                const response = await fetch(apiUrl, {
                method: "POST",
                mode: "cors",
                headers: {
                    "Authorization": `Bearer ${store.state.xsrfToken}`,
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(userData)
                });
                if (response.status === 200) {
                    this.createUserSuccess = true;
                }
            } catch (error) {
                console.error("Erreur lors de la création de l'utilisateur.", error);
            }
        },
    }
};
</script>