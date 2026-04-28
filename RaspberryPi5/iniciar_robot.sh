#!/bin/bash
# SCRIPT CORREGIDO PARA TU REPOSITORIO
cleanup() {
    echo "🛑 Apagando..."
    pkill -P $$
    exit
}
trap cleanup SIGINT EXIT

source /opt/ros/jazzy/setup.bash
source ~/tfg_ws/install/setup.bash
export ROS_DOMAIN_ID=0

echo "🚀 INICIANDO RASPBERRY PI (Modo: Cerebro)"

# 1. DRIVER DEL ROBOT
# Añadimos use_gui:=false para que no intente abrir ventanas en la Pi
echo "🤖 [1/3] Conectando con Robot..."
ros2 launch abb_irb140_support display_irb140.launch.py robot_ip:=192.168.125.1 use_fake_hardware:=true use_rviz:=false use_gui:=false &

sleep 8

# 2. ROSBRIDGE
echo "📡 [2/3] Lanzando Rosbridge..."
ros2 launch rosbridge_server rosbridge_websocket_launch.xml port:=9090 > /dev/null 2>&1 &

# 3. WEB (AQUÍ ESTABA EL FALLO DE LA CARPETA)
echo "🌐 [3/3] Iniciando Web..."
cd ~/tfg_ws/src/abb_irb140_support
python3 app.py > /dev/null 2>&1 &

echo "---------------------------------------------------"
echo "✅ TODO LISTO. Abre en tu PC: http://RaspberryPi.local:5000"
echo "---------------------------------------------------"

wait
