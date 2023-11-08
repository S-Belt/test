#!/bin/bash

# Nom du conteneur PostgreSQL
CONTAINER_NAME="postgres"

# Mot de passe PostgreSQL
POSTGRES_PASSWORD="postgres"

# Vérifier si le conteneur est déjà en cours d'exécution
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Le conteneur PostgreSQL est déjà en cours d'exécution."
else
    # Vérifier si le conteneur existe déjà (arrêté)
    if [ "$(docker ps -aq -f status=exited -f name=$CONTAINER_NAME)" ]; then
        # Supprimer le conteneur arrêté s'il existe
        docker rm $CONTAINER_NAME
    fi

    # Démarrer le conteneur PostgreSQL
    docker run --name $CONTAINER_NAME -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD -d -p 5432:5432 postgres
    echo "Le conteneur PostgreSQL a été démarré avec succès."
fi

