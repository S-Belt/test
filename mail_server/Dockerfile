# Utiliser une image de base officielle Python
FROM python:3.9

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier les fichiers de dépendances dans le répertoire de travail
COPY requirements.txt .

# Installer les dépendances
RUN pip install --no-cache-dir -r requirements.txt

# Install mail flask & PyJWT & Flask-Mail & python-dotenv
RUN pip install Flask-Mail PyJWT python-dotenv

# Copier le contenu du répertoire local dans le répertoire de travail
COPY . .

# Copier le script d'entrée et le rendre exécutable
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Spécifier la variable d'environnement
ENV NAME gotham

# Définir le script d'entrée comme point d'entrée du conteneur
ENTRYPOINT ["/app/entrypoint.sh"]
