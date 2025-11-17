fdb_connect -fdb_project "test"
create_campaign -args "-full64 -daidir simv.daidir -campaign fc1 -sff in.sff  -dut_path test -overwrite "
set_config -global_max_jobs 1
create_testcases -name {"test_result"} -exec "$::env(PWD)/simv" -args "" -fsim_args ""
set_config -fsim_mode concurrent
catch {fsim}
report -campaign fc1 -report fsim_v_pre.rpt -overwrite
set_config -fsim_mode serial
catch {fsim  -no_coats -select {IA IF}}
report -campaign fc1 -report fsim_v.rpt -overwrite
