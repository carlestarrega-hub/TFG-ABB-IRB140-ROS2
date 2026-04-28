import socket
import struct
import time

# La IP del puente en tu portátil
ip_de_tu_pc = "192.168.1.134"
puerto_motion = 11000

def enviar_mensaje(s, seq_id, joints):
    # Valores por defecto que configuramos en RAPID
    m_type = 10
    c_type = 1
    r_code = 0
    ext = [9E9] * 6  # 9E9 le dice al robot ABB que ignore los ejes externos
    duracion = 5.0   # Segundos que durará el movimiento
    m_len = 68       # Tamaño exacto en bytes de la carga útil

    # Empaquetamos todo en código binario (Little-Endian)
    # <I : 1 unsigned int (m_len = 4 bytes)
    # <4i: 4 enteros (m_type, c_type, r_code, seq_id = 16 bytes)
    # <13f: 13 floats (6 juntas, 6 ext, 1 duracion = 52 bytes)
    paquete = struct.pack('<I4i13f', 
        m_len, 
        m_type, c_type, r_code, seq_id,
        joints[0], joints[1], joints[2], joints[3], joints[4], joints[5],
        ext[0], ext[1], ext[2], ext[3], ext[4], ext[5],
        duracion
    )
    s.sendall(paquete)

try:
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((ip_de_tu_pc, puerto_motion))
    print("✅ Conectado al controlador ABB.")

    # PASO 1: Abrir la trayectoria (seq_id = 1)
    print("1️⃣ Abriendo buffer de trayectoria...")
    enviar_mensaje(s, 1, [0, 0, 0, 0, 0, 0])
    time.sleep(0.1)

# PASO 2: Enviar los puntos de destino (seq_id = 0)
    print("2️⃣ Enviando primer punto (J1: 45°, J2: 30°)...")
    enviar_mensaje(s, 0, [45.0, 30.0, 0.0, 0.0, 0.0, 0.0])
    
    # Le damos 3 segundos para que le dé tiempo a llegar físicamente
    time.sleep(3) 

    print("3️⃣ Enviando segundo punto (Todo a 0°)...")
    enviar_mensaje(s, 0, [0.0, 0.0, 0.0, 0.0, 0.0, 0.0])
    time.sleep(0.1)

    # PASO 3: Cerrar y ejecutar (seq_id = 2)
    print("4️⃣ Cerrando trayectoria. ¡Mira la pantalla de RobotStudio!")
    enviar_mensaje(s, 2, [0, 0, 0, 0, 0, 0])

    time.sleep(5)
    s.close()
    print("🏁 Órdenes enviadas correctamente.")

except Exception as e:
    print(f"❌ Error fatal: {e}")
