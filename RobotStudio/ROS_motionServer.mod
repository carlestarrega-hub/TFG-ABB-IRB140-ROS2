MODULE ROS_motionServer
    LOCAL VAR socketdev s_sk;
    LOCAL VAR socketdev c_sk;
    LOCAL VAR R_traj_pt tr_buffer{10};
    LOCAL VAR num b_size := 0;

    PROC main()
        VAR R_msg_joint m;
        
        ! Limpieza de seguridad: Evita bloqueos al reiniciar
        R_new_tr := FALSE; 
        R_tr_lock := FALSE; 
        
        ! Abrimos el puerto de escucha 
        ROS_init_sk s_sk, 12000;
        ROS_wait_cli s_sk, c_sk;
        
        WHILE true DO
            R_rec_msg_tr c_sk, m;
            
            TEST m.seq_id
                CASE 1: ! ID = 1 (R_TR_START) -> Limpiamos memoria
                    b_size := 0;
                CASE 2: ! ID = 2 (R_TR_END) -> Trayectoria completa
                    WaitTestAndSet R_tr_lock;
                    R_tr := tr_buffer;
                    R_tr_size := b_size;
                    R_new_tr := TRUE; ! Activa la tarea T_ROB1
                    R_tr_lock := FALSE;
                DEFAULT: ! ID = 0 -> Guardamos el punto en el buffer
                    IF (b_size < 10) THEN
                        Incr b_size;
                        tr_buffer{b_size}.j_pos := m.joints;
                        tr_buffer{b_size}.e_pos := m.e_axes;
                        tr_buffer{b_size}.dur := m.duration;
                    ENDIF
            ENDTEST
        ENDWHILE
    ERROR
        ! Si la Pi se desconecta, cerramos limpio y volvemos a escuchar
        IF SocketGetStatus(c_sk) <> SOCKET_CLOSED THEN
            SocketClose c_sk;
        ENDIF
        ROS_wait_cli s_sk, c_sk;
        RETRY;
    ENDPROC
ENDMODULE