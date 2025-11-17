all: run_vc_zoix 

run_vc_zoix: vc_comp vc_fcm_local

clean:
	rm -rf sim.* fcm.dir* *.log ucli* csrc fdb* user_coverage* zoix.sim* __* fgen* verdi* simv* testability.txt fault_report* *rpt

vc_comp:
	vcs ./test.v -kdb -lca -fusa=portfaults -debug_access +vcs+fsdbon -sverilog -full64 +define+ZOIX -l comp_v.log

vc_fcm_local:
	vc_fcm -tcl_script ./fcm.tcl 
