MODULE ROS_stateServer
    LOCAL VAR socketdev s_sk;
    LOCAL VAR socketdev c_sk;

    PROC main()
        VAR R_msg_data m;
        VAR jointtarget j;
        ROS_init_sk s_sk, 11002;
        ROS_wait_cli s_sk, c_sk;
        WHILE true DO
            j := CJointT();
            m.header.m_type := R_MT_JOINT;
            m.joints := j.robax;
            m.e_axes := j.extax;
            WaitTime 0.1;
        ENDWHILE
    ENDPROC
ENDMODULE