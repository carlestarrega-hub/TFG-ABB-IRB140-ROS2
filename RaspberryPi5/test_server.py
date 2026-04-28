import socket

# La IP de tu Raspberry en eth0
HOST = '192.168.125.50'  
PORT = 5000

print(f"--- Iniciando servidor en {HOST}:{PORT} ---")
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen(1)
    print("Esperando al robot... (Pulsa Play en el FlexPendant)")
    
    conn, addr = s.accept()
    with conn:
        print(f"¡CONECTADO! El robot con IP {addr} ha llamado a la puerta.")
        data = conn.recv(1024)
        print(f"Mensaje recibido: {data.decode('utf-8')}")
