#!/bin/bash

# Vérifie si des changements sont présents
if ! git diff-index --quiet HEAD --; then
    # Ajout de tous les fichiers modifiés à la zone de staging
    git add -A

    # Affichage de l'état des modifications
    git status

    # Demande à l'utilisateur de confirmer les changements
    read -p "Voulez-vous vraiment commiter ces changements ? (o/n) " confirm
    if [ "$confirm" != "o" ]; then
        echo "Commit annulé."
        exit 1
    fi

    # Demande le message de commit
    read -p "Entrez votre message de commit : " commit_message

    # Création du commit
    git commit -m "$commit_message"

    # Affichage de la log des commits
    git log --oneline -5

    # Demande à l'utilisateur de confirmer le push
    read -p "Voulez-vous push ces changements ? (o/n) " confirm_push
    if [ "$confirm_push" == "o" ]; then
        # Récupération de la branche courante
        current_branch=$(git rev-parse --abbrev-ref HEAD)

        # Push des changements
        git push origin "$current_branch"
    else
        echo "Changements committés localement, mais pas push."
    fi
else
    echo "Aucun changement détecté."
fi
