import socket

# La IP de tu portátil conectada a los datos del móvil
HOST_PC = '10.51.214.50'  
PORT = 5000

print(f"Llamando a RobotStudio a través del PC en {HOST_PC}:{PORT}...")

try:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.settimeout(5.0)
        s.connect((HOST_PC, PORT))
        print("¡BINGO! La Pi ha cruzado la red móvil hasta el simulador.")
        s.sendall(b'Hola RobotStudio, soy la Raspberry Pi')
        
except socket.timeout:
    print("Error: Tiempo agotado. El Firewall de Windows está bloqueando la llamada.")
except ConnectionRefusedError:
    print("Error: Conexion rechazada. Asegurate de que RobotStudio esta en Play.")
