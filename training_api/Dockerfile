# Utiliser l'image officielle Elixir pour construire notre application
FROM elixir:1.14 AS build

# Installer les dépendances hex et rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Créer et définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de dépendances et installer les dépendances
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get && mix deps.compile

# Copier le reste des fichiers de l'application
COPY . .

# Compiler l'application
RUN mix do compile, phx.digest

# Préparer l'exécution de l'application
FROM elixir:1.14

# Installer les packages nécessaires pour exécuter l'application et hex, rebar
RUN apt-get update && \
    apt-get install -y postgresql-client && \
    mix local.hex --force && \
    mix local.rebar --force && \
    rm -rf /var/lib/apt/lists/*

# Copier l'application compilée depuis l'étape de construction
COPY --from=build /app /app
WORKDIR /app

# Copier le script d'entrée
COPY entrypoint.sh ./entrypoint.sh

# Rendre le script d'entrée exécutable
RUN chmod +x ./entrypoint.sh

# Définir les variables d'environnement nécessaires pour Phoenix
#ENV MIX_ENV=prod \
#    PORT=4000

# Exposer le port sur lequel l'application va s'exécuter
EXPOSE 4000

# Définir le script d'entrée comme point d'entrée du conteneur
ENTRYPOINT ["./entrypoint.sh"]
