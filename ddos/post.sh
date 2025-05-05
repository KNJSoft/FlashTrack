#!/bin/bash

# Adresse IP ou nom d'hôte du serveur web
SERVER_IP="travelas-backend-production.up.railway.app"
# Port du serveur web (généralement 80 pour HTTP, 443 pour HTTPS)
SERVER_PORT=80
# Chemin de l'URL pour la requête POST
PATH="/auth/login"
# Données POST partielles (incomplètes)
PARTIAL_POST_DATA='{"login": "test@gmail.com","password": "password"}'
# En-têtes HTTP POST partiels (incomplets)
PARTIAL_POST_HEADERS="POST ${PATH} HTTP/1.1\nHost: ${SERVER_IP}\nContent-Type: application/x-www-form-urlencoded\nContent-Length: "

# Calcul de la longueur du contenu (sera incomplet)
CONTENT_LENGTH=$(echo -n "$PARTIAL_POST_DATA" | wc -c)
INCOMPLETE_CONTENT_LENGTH=$((CONTENT_LENGTH + 10)) # Ajoute intentionnellement une longueur incorrecte

# Construction de la requête POST partielle
PARTIAL_REQUEST="${PARTIAL_POST_HEADERS}${INCOMPLETE_CONTENT_LENGTH}\n\n${PARTIAL_POST_DATA}"

# Envoi de la requête partielle en utilisant netcat
echo -n "$PARTIAL_REQUEST" | nc "$SERVER_IP" "$SERVER_PORT"
