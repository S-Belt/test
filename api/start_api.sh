#!/bin/bash
set -a # automatically export all variables
source .env
set +a

# Vérifier si toutes les variables d'environnement requises sont définies
if [ -z "$JWT_SECRET_KEY" ]; then
  echo "GUARDIAN_SECRET_KEY est manquante."
  exit 1
fi

# Démarrer l'application Elixir
mix phx.server

