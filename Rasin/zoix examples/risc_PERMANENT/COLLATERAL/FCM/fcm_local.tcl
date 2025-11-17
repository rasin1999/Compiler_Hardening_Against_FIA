set_config -global_max_jobs 1
create_testcases -name {"test1" } -exec "$::env(PWD)/simv" -args "+TESTNAME=user_test1" -fsim_args ""
create_testcases -name {"test2" } -exec "$::env(PWD)/simv" -args "+TESTNAME=user_test2" -fsim_args ""
fcm_internal_set_flag -name force_elapsed_time_test1 -value 5
fcm_internal_set_flag -name force_elapsed_time_test2 -value 7
fsim
report -campaign riscdemo -report fsim_v.rpt -overwrite
