#Charger la version de node voulu
FROM node:20

#Précision du dossier
WORKDIR /gothamfront

#Copie des fichiers dans l'image
COPY . .

#Node : On installe le tout
RUN npm install

#On précise le port
EXPOSE 8080

#On lance la commande "npm run serve"
CMD ["npm", "run", "serve"]