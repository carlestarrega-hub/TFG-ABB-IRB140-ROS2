# TFG-ABB-IRB140-ROS2

Este proyecto presenta una arquitectura de control distribuido para la modernización de un brazo robótico **ABB IRB 140**. Utiliza **ROS 2 Jazzy Jalisco** centralizado en una **Raspberry Pi 5** para gobernar el manipulador físico, permitiendo además su control a través de una interfaz web en tiempo real.

## 🚀 Características Principales
- **Control Distribuido:** Delegación de carga computacional entre una Máquina Virtual (Gemelo Digital) y Raspberry Pi 5 (Control de Campo).
- **Gemelo Digital:** Simulación y planificación de trayectorias mediante **MoveIt 2** y **RViz2**.
- **Interfaz HMI:** Control bidireccional mediante una interfaz web accesible desde cualquier navegador en la red local.
- **Protocolo de Comunicación:** Puente lógico entre la red de usuario y el armario de control **ABB IRC5**.

## 📂 Estructura del Repositorio
- `📁 VM_workspace/`: Paquetes de configuración de MoveIt, archivos URDF y lógica del gemelo digital ejecutados en la máquina virtual.
- `📁 RaspberryPi5/`: Scripts de orquestación en Bash y nodos Python para la inyección de cinemática y servidor de control embebido.
- `📁 RobotStudio/`: Código RAPID para el controlador IRC5 de ABB.

## 🛠️ Requisitos del Sistema
- **Hardware:** Raspberry Pi 5, Brazo Robótico ABB IRB 140, PC para supervisión.
- **Software:** ROS 2 Jazzy Jalisco, Ubuntu 24.04 LTS , RobotStudio .

## ⚙️ Instalación y Uso Rápido
1. **Configurar la Raspberry Pi:** Acceder a la carpeta `RaspberryPi5/` y ejecutar `./iniciar_robot.sh` para levantar el puente de comunicaciones.
2. **Lanzar la Supervisión:** En la carpeta `VM_workspace/`, ejecutar el script de visualización correspondiente e introducir la IP de la Raspberry Pi.
3. **Control Web:** Acceder a la dirección IP de la placa a través del navegador para abrir el panel de control.

---
*Este proyecto ha sido desarrollado como Trabajo de Fin de Grado (TFG).*
