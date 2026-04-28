#!/usr/bin/env python3
import rclpy
import time
from moveit.planning import MoveItPy
from moveit.core.robot_state import RobotState

def main():
    rclpy.init()
    
    print("🤖 INICIANDO CONTROL DE ROBOT ABB...")

    try:
        dark_robot = MoveItPy(node_name="moveit_py")
    except Exception as e:
        print(f"❌ ERROR AL INICIAR: {e}")
        return

    print("⏳ Sincronizando (3 segundos)...")
    time.sleep(3.0) 

    abb_arm = dark_robot.get_planning_component("manipulator")
    robot_model = dark_robot.get_robot_model()
    
    # Preparamos el estado "CERO" (Home) en memoria para usarlo luego
    state_zero = RobotState(robot_model)
    state_zero.set_to_default_values()
    state_zero.set_joint_group_positions("manipulator", [0.0, 0.0, 0.0, 0.0, 0.0, 0.0])

    while rclpy.ok():
        # ---------------------------------------------------------
        # MOVIMIENTO 1: A TU POSICIÓN "UP" (Del SRDF)
        # ---------------------------------------------------------
        print("========================================")
        print("🚀 YENDO A POSICIÓN 'UP' (SRDF)")
        
        abb_arm.set_start_state_to_current_state()
        
        # Aquí usamos el nombre que tú configuraste en el Asistente
        abb_arm.set_goal_state(configuration_name="up")
        
        plan_result = abb_arm.plan()
        
        if plan_result:
            print("✅ Ruta calculada. Moviendo...")
            dark_robot.execute(plan_result.trajectory, controllers=[])
        else:
            print("❌ No se encuentra la pose 'up' o es inalcanzable")
        
        time.sleep(2.0)

        # ---------------------------------------------------------
        # MOVIMIENTO 2: A CERO (Reposo)
        # ---------------------------------------------------------
        print("========================================")
        print("⬇️ YENDO A POSICIÓN CERO")
        
        abb_arm.set_start_state_to_current_state()
        
        # Usamos el estado manual de ceros
        abb_arm.set_goal_state(robot_state=state_zero)
        
        plan_result = abb_arm.plan()
        
        if plan_result:
            print("✅ Ruta calculada. Moviendo...")
            dark_robot.execute(plan_result.trajectory, controllers=[])
        else:
            print("❌ Fallo al planificar bajada")
            
        time.sleep(2.0) 

    rclpy.shutdown()

if __name__ == "__main__":
    main()
