# Guide de Démarrage pour l'Application

Ce guide fournit les instructions nécessaires pour configurer et démarrer l'application en utilisant Docker et Docker Compose.

## Prérequis

Avant de commencer, assurez-vous d'avoir installé les outils suivants sur votre machine :

- Docker
- Docker Compose

Vous pouvez les télécharger et les installer à partir du [site officiel de Docker](https://www.docker.com/get-started).

## Configuration

1. **Variables d'Environnement** : Copiez le fichier `.env.example` à la racine du projet et renommez-le en `.env`. Ouvrez le fichier et configurez vos variables d'environnement. Voici un exemple de configuration :

    ```bash
    # .env
    DB_HOST=db
    DB_PORT=5432
    DB_NAME=ma_base_de_donnees
    DB_USER=utilisateur
    DB_PASSWORD=mot_de_passe
    MAIL_USE_TLS=boolean
    MAIL_USE_SSL=boolean
    MAIL_SERVER=smtp.exemple.com
    MAIL_PORT=587
    MAIL_USER=utilisateur_email
    MAIL_PASSWORD=mot_de_passe_email
    JWT_SECRET=secret_jwt
    ```

2. **Docker Compose** : Il y a deux fichiers Docker Compose dans ce projet, `docker-compose.dev.yml` pour le développement et `docker-compose.prod.yml` pour la production. Chaque fichier est configuré pour répondre aux besoins spécifiques de chaque environnement.

## Démarrage de l'Application

Vous pouvez démarrer l'application en utilisant le script `start-docker-compose.sh`.

1. Rendez le script exécutable :

    ```bash
    chmod +x start-docker-compose.sh
    ```

2. Exécutez le script avec l'environnement souhaité (`dev` ou `prod`) :

   - Pour l'environnement de développement :
       ```bash
       ./start-docker-compose.sh dev
       ```
   - Pour l'environnement de production :
       ```bash
       ./start-docker-compose.sh prod
       ```
     Le script va démarrer les conteneurs Docker en fonction de l'environnement spécifié.

## Accès à l'Application

Une fois l'application démarrée, vous pouvez y accéder à travers votre navigateur web ou en utilisant un client HTTP comme `curl`.
L'interface web est accessible [ICI](http://localhost:8080)

## Arrêt de l'Application

Pour arrêter l'application, vous avez deux options :

### 1. Utiliser le Terminal

Si vous avez démarré l'application en utilisant le terminal et que celle-ci s'exécute en avant-plan, vous pouvez simplement appuyer sur `CTRL+C` dans ce même terminal pour l'arrêter.

### 2. Utiliser Docker Compose

Si l'application s'exécute en arrière-plan ou si vous souhaitez utiliser une approche différente, vous pouvez utiliser Docker Compose pour l'arrêter. Voici les étapes à suivre :

1. Ouvrez un terminal et naviguez jusqu'au répertoire contenant vos fichiers `docker-compose`.

2. Exécutez la commande suivante pour arrêter et supprimer les conteneurs, les réseaux et les volumes définis dans votre fichier Docker Compose :

    - Pour la production :
      ```bash
      docker-compose -f docker-compose.prod.yml down
      ```

    - Pour le développement :
      ```bash
      docker-compose -f docker-compose.dev.yml down
      ```

Assurez-vous de spécifier le fichier Docker Compose approprié en utilisant l'option `-f`.

Après avoir exécuté ces commandes, tous les services, réseaux et volumes définis dans le fichier Docker Compose spécifié seront arrêtés et supprimés.
