#!/bin/bash

# Fonction pour afficher les résultats
# Paramètres :
#   $1: Fichier/Dossier concerné
#   $2: Action effectuée (Copie, Déplacement, Création, Suppression, etc.)
#   $3: Statut de l'action (Succès, Échec)
#   $4: Temps écoulé (en secondes, optionnel)
function afficher_statut {
    local fichier="$1"
    local action="$2"
    local statut="$3"
    local temps="$4"
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] Action: $action, Fichier: $fichier, Statut: $statut, Temps écoulé: $temps secondes." >> /var/log/removable_disks.log
}

action="$1"
mount_point="$2"
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

case "$action" in
    "mount")
        echo "[$timestamp] Disque amovible monté sur: $mount_point" >> /var/log/removable_disks.log
        # Vérifier si le point de montage existe
        if ! [[ -d "$mount_point" ]]; then
            echo "[$timestamp] Erreur: Le point de montage '$mount_point' n'existe pas." >> /var/log/removable_disks.log
            exit 1
        fi
        # Écoute des événements dans le répertoire, exécution en arrière-plan
        (
            inotifywait -m -r -e close_write,moved_to,moved_from,create,delete "$mount_point" --format '%w%f %e' |
            while IFS= read -r fichier evenement; do
                # Commencer le chronomètre
                debut=$(date +%s)

                # Initialiser le statut par défaut
                statut="Succès"
                action_type="Inconnu" #Pour les cas non gérés

                # Vérifier le type d'événement
                case "$evenement" in
                    CLOSE_WRITE*)
                        action_type="Copie"
                        ;;
                    MOVED_TO*)
                        action_type="Déplacement vers la clé"
                        ;;
                    MOVED_FROM*)
                        action_type="Déplacement depuis la clé"
                        ;;
                    CREATE*)
                        action_type="Création"
                        ;;
                    DELETE*)
                         action_type="Suppression"
                         ;;
                    *)
                        action_type="Autre"
                        statut="N/A" # Statut N/A pour les actions non gérées
                        ;;
                 esac

                # Fin du chronomètre
                fin=$(date +%s)
                temps=$((fin - debut))

                # Affichage du temps écoulé.
                afficher_statut "$fichier" "$action_type" "$statut" "$temps"
            done
        ) & # Exécution en arrière-plan
        ;;
    "unmount")
        echo "[$timestamp] Disque amovible démonté de: $mount_point" >> /var/log/removable_disks.log
        #  Ajouter ici les actions que vous souhaitez effectuer lors du démontage
        #  IMPORTANT: Tuer le processus inotifywait, ici on utilise pkill
        pkill -f "inotifywait -m -r -e close_write,moved_to,moved_from,create,delete $mount_point"
        ;;
    *)
        echo "[$timestamp] Action non reconnue: $action" >> /var/log/removable_disks.log
        ;;
esac

exit 0
