<template>
    <div>
        <form @submit.prevent="login">
            <input v-model="form.email" type="email" placeholder="Votre email"/>
            <input v-model="form.password" type="password" placeholder="Votre password"/>
            <button type="submit">Se connecter</button>
        </form>
        <p v-if="error">Email ou mot de passe non reconnu</p>
    </div>
</template>

<script>
import { baseApiUrl } from './services/api';
import router from "@/components/services/router";

export default {
    name: "loginComponent",
    data() {
        return {
            error: false,
            form: {
                email: null,
                password: null
            },
        }
    },
    methods: {
        async login() {
            const password = this.form.password;
            const email = this.form.email;

            //Requête POST
            const raw = JSON.stringify({
                "email": email,
                "hash_password": password
            });
            try {
                const response = await fetch(`${baseApiUrl}/users/sign_in`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: raw
                });
                if (response.status === 200) {
                    const responseData = await response.json();
                    const xsrfToken = responseData.token;
                    const userId = responseData.id;
                    const userUsername = responseData.username;
                    const userEmail = responseData.email;
                    const userRoleId = responseData.role_id;
                    const userTeamId = responseData.team_id;
                    const data = {
                        id: userId,
                        username: userUsername,
                        email: userEmail,
                        role_id: userRoleId,
                        team_id: userTeamId
                    };
                    this.$store.dispatch('setTokens', xsrfToken);
                    this.$store.dispatch('setUser', data);
                    await router.push('/dashboard');
                } else {
                    this.error = true;
                }
            } catch (error) {
                this.error = true;
                console.error(error);
            }
        }
    }
}
</script>