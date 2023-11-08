<template>
    <div>
        <nav>
            <router-link to="/dashboard">Dashboard</router-link>
        </nav>
        <div>
            <h3>Mettre à jour vos données utilisateur<i class="fas fa-chevron-down" :class="{ 'rotate': !formUpdateVisible }"></i></h3>
            <form @submit.prevent="updateUser">
                <input v-model="formUpdate.username" type="text" required /><br>
                <input v-model="formUpdate.email" type="email" required /><br>
                <button type="submit">Mettre à jour les données de l'utilisateur</button>
            </form>
            <p v-show="updateSuccess">Mise à jour effectué.</p>
        </div>
    </div>
</template>

<script>
    import { baseApiUrl } from '../services/api';
    import store from "@/components/services/store";
    export default {
        name: 'updateComponent',
        computed: {
            //get user from store
            user () {
                return store.state.user;
            }
        },
        data() {
            return {
                formUpdate: {
                    username: '',
                    email: '',
                    password: '',
                    password2: ''
                },
                updateSuccess: false,
                formUpdateVisible: true
            }
        },
        
        props: {
            user_id: String
        },
        
        created() {
            this.updateForm()
        },
        methods: {
            
            updateForm() {
                this.formUpdate.email = this.user.email;
                this.formUpdate.username= this.user.username;
            },

            async updateUser() {
            // Créer un objet temporaire pour stocker les données modifiées
                const updatedUser = {};
    
                // Comparer les valeurs du formulaire avec les valeurs actuelles du state.user
                if (this.formUpdate.username !== this.user.username) {
                    updatedUser.username = this.formUpdate.username;
                }
                if (this.formUpdate.email !== this.user.email) {
                    updatedUser.email = this.formUpdate.email;
                }
                if (this.formUpdate.password !== null) {
                    updatedUser.password = this.formUpdate.password;
                }
    
                store.commit('updateUser', updatedUser);
                    
                const apiUrl = `${baseApiUrl}/users/${store.state.user.id}`;
                    const userData = {
                        user: {
                            username: this.formUpdate.username,
                            email: this.formUpdate.email,
                        }
                    }
                try {
                    const response = await fetch(apiUrl, {
                        method: "PUT", 
                        headers: {
                            "Authorization": `Bearer ${store.state.xsrfToken}`,
                            "Content-Type": "application/json"
                        },
                        body: JSON.stringify(userData)
                    });
                    if (response.status === 201) {
                        this.createUserSuccess = true;
                    }
                } catch (error) {
                    console.error("Erreur lors de la création de l'utilisateur.", error);
                }
                    
                // Réinitialisation du formulaire
                this.formUpdate = {
                    username: this.user.username,
                    email: this.user.email,
                };
                this.updateSuccess = true;
        },
    },
};
</script>