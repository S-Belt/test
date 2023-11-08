#!/bin/bash
set -e

# Liste des variables d'environnement requises
required_vars=("MAIL_SERVER" "MAIL_PORT" "MAIL_USE_TLS" "MAIL_USER" "MAIL_PASSWORD")

# Vérifier si toutes les variables d'environnement requises sont définies
for var in "${required_vars[@]}"; do
  if [ -z "${!var}" ]; then
    echo "Erreur: La variable d'environnement $var n'est pas définie."
    exit 1
  fi
done

# Exécuter l'application
exec python app.py
