MODULE ROS_motion
    PROC main()
        VAR jointtarget target;
        
        TPWrite "======================================";
        TPWrite "T_ROB1: TAREA DE MOVIMIENTO LISTA.";
        TPWrite "======================================";

        WHILE true DO
            IF R_new_tr = TRUE THEN
                ! Bloqueamos la memoria mientras leemos
                WaitTestAndSet R_tr_lock;
                
                IF R_tr_size > 0 THEN
                    FOR i FROM 1 TO R_tr_size DO
                        target.robax := R_tr{i}.j_pos;
                        target.extax := R_tr{i}.e_pos;
                        
                        
                        MoveAbsJ target, v100, z10, tool0;
                    ENDFOR
                ENDIF
                
                ! Reseteamos señales para esperar la siguiente trayectoria
                R_new_tr := FALSE;
                R_tr_lock := FALSE;
            ENDIF
            
            ! Pausa de 50ms para no saturar la CPU de la controladora
            WaitTime 0.05; 
        ENDWHILE
    ENDPROC
ENDMODULE