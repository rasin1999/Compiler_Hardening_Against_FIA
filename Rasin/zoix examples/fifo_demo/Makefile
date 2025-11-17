export FSDB_FAULT_DUMP_MODE=fm
export VERDI_FUSA_DEBUG=1
export VERDI_FUSA_DUMP_FSDB_CMD=./COLLATERAL/VERDI/dumping_v.sh

run_vc_zoix:  setup_fdb vc_comp vc_fcm_exp stop_fdb

run_zoix: z_comp z_fmsh

run_vc_fmdump: clean setup_fdb vc_comp vc_fcm_exp vc_verdi vc_info 

clean:
	rm -rf sim.* fcm.dir* *.fsdb novas* *.log ucli* csrc fdb* user_coverage* zoix.sim* __* fgen* verdi* simv* testability.txt fault_report*

setup_fdb:
	fdb_control -init_database -fdb_storage_path fdb_data
	fdb_control -start_server -fdb_storage_path fdb_data -fdb_server ${HOST}:${FDB_DB_PORT}
	fdb_control -new_project -fdb_server ${HOST}:${FDB_DB_PORT} -fdb_name fifo

stop_fdb:
	fdb_control -stop_server -fdb_storage_path fdb_data -fdb_server ${HOST}:${FDB_DB_PORT}
	\rm -rf fdb_data

## VC-Z01X ##

vc_comp:
	vcs -f ./rtl.f ./src/strobe.sv -fusa=dut:test.DUT -kdb -lca -fusa=portfaults -debug_access +vcs+fsdbon -sverilog -full64 -l comp_v.log

vc_fcm_exp:
	vc_fcm -tcl_script ./COLLATERAL/FCM/fcm.tcl -connect -fdb_server $(HOST):$(FDB_DB_PORT) -fdb_project fifo

## Z01X ##

z_comp:
	zoix -f ./rtl.f ./src/strobe.sv -kdb -lca +sv -portfaults -fsdb -l comp_z.log

z_fmsh:
	fmsh -load ./COLLATERAL/FMSH/user.fmsh

## VERDI DUMPING ##

vc_verdi:
	verdi -lca -dbdir simv.daidir &

vc_info:
	cat ./COLLATERAL/VERDI/dumping_note 
