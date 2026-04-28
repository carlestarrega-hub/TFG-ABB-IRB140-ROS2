#!/bin/bash
# Script: ver_robot.sh (VM - VERSIÓN UNIVERSAL)
# Intenta conectar por nombre de red antes de pedir IP.

cleanup() {
    pkill -P $$
    exit
}
trap cleanup SIGINT EXIT

source /opt/ros/jazzy/setup.bash
source ~/tfg_ws/install/setup.bash
export ROS_DOMAIN_ID=0

clear
echo "=========================================="
echo "👀 VISUALIZADOR REMOTO (VM)"
echo "=========================================="

# INTENTO DE AUTODETECCIÓN
PI_HOST="RaspberryPi.local"
echo "🔍 Buscando a la Raspberry Pi ($PI_HOST)..."

if ping -c 1 -W 2 $PI_HOST &> /dev/null; then
    echo "✅ Pi encontrada mediante nombre de red."
    IP_PI=$PI_HOST
else
    echo "⚠️  No se encuentra '$PI_HOST' en esta red."
    read -p "Introduce la IP de la Pi manualmente: " IP_PI
fi

if [ -z "$IP_PI" ]; then
    echo "❌ Error: Se necesita una IP para continuar."
    exit 1
fi

echo "🚀 Conectando a $IP_PI..."

# 1. RVIZ
echo "🎨 [1/2] Abriendo RViz..."
rviz2 -d ~/tfg_ws/src/abb_irb140_support/rviz/remoto.rviz &

# 2. ABRIR WEB
echo "🌐 [2/2] Abriendo Web..."
# Espera un poco a que el servidor de la Pi esté listo
sleep 2
xdg-open "http://$IP_PI:5000" &

echo "---------------------------------------------------"
echo "✅ Visualización iniciada."
echo "---------------------------------------------------"
wait
