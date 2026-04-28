#!/bin/bash
# Script de Configuración de Red UNICAST (Pi -> VM)

# IP DE LA MÁQUINA VIRTUAL (DESTINO)
PEER_IP="192.168.1.142"

# 1. Detectar tarjeta de red (probablemente wlan0)
INTERFACE=$(ip route get $PEER_IP | awk '{print $5; exit}')
echo "📡 Tarjeta de red detectada: $INTERFACE"

# 2. Crear archivo CycloneDDS
cat > ~/cyclonedds.xml <<EOF
<?xml version="1.0" encoding="UTF-8" ?>
<CycloneDDS xmlns="https://cdds.io/config" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="https://cdds.io/config https://raw.githubusercontent.com/eclipse-cyclonedds/cyclonedds/master/etc/cyclonedds.xsd">
    <Domain id="any">
        <General>
            <NetworkInterface>$INTERFACE</NetworkInterface>
            <AllowMulticast>false</AllowMulticast>
        </General>
        <Discovery>
            <Peers>
                <Peer address="$PEER_IP"/>
            </Peers>
            <ParticipantIndex>auto</ParticipantIndex>
        </Discovery>
    </Domain>
</CycloneDDS>
EOF

# 3. Inyectar la configuración en el script de inicio
# Buscamos dónde está el export RMW y añadimos el URI debajo
sed -i '/export RMW_IMPLEMENTATION/a export CYCLONEDDS_URI="file:///home/ubuntu/cyclonedds.xml"' ~/iniciar_robot.sh

echo "✅ Red configurada. La Pi ahora disparará datos directos a la VM."
