#!/bin/sh
set -e

# Vérifier si les variables d'environnement nécessaires sont définies
#required_vars="DB_HOST DB_PORT DB_USER DB_PASSWORD DB_NAME"
#for var in $required_vars; do
#  if [ -z "${!var}" ]; then
#    echo "Erreur : La variable d'environnement $var n'est pas définie."
#    exit 1
#  fi
#done

# Attente de la base de données
until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER"; do
  echo "En attente de la base de données..."
  sleep 1
done

echo "La base de données est prête !"

# Exécution des commandes d'initialisation de la base de données (si nécessaire)
mix ecto.create
mix ecto.migrate

# Démarrage de l'application Phoenix
exec mix phx.server
