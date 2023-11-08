#!/bin/bash

# start-docker-compose.sh

set -e

ENVIRONMENT=$1

down_containers() {
  echo "Arrêt des conteneurs existants..."
  docker-compose -f $1 down
}

start_containers() {
  cd api
  mix deps.get
  cd ../
  echo "Démarrage de Docker Compose en mode $1..."
  docker-compose -f $2 up --build
}

if [ "$ENVIRONMENT" == "prod" ]; then
  down_containers docker-compose.prod.yml
  start_containers production docker-compose.prod.yml
elif [ "$ENVIRONMENT" == "dev" ]; then
  down_containers docker-compose.dev.yml
  start_containers développement docker-compose.dev.yml
else
  echo "Veuillez spécifier l'environnement comme argument : 'prod' ou 'dev'."
  exit 1
fi