all:	run_vc_zoix

run_vc_zoix:  vc_comp vc_vcfcc vc_vcfdb_report vc_fcm_local

run_zoix: z_comp z_fr2fdef z_fault_report z_fmsh_local

clean:
	rm -rf sim.* fcm.dir* *.log ucli* csrc fdb* user_coverage* zoix.sim* __* fgen* verdi* simv* testability.txt fault_report*

## VC-Z01X ##

vc_comp:
	vcs -f ./run.f ./src/strobe.sv -debug_access +vcs+fsdbon -sverilog -full64 -fusa -l comp_v.log

vc_vcfcc:
	vc_fcc -full64 -daidir simv.daidir -sff ./COLLATERAL/SFF/config.sff,./COLLATERAL/SFF/faults.sff -campaign riscdemo -dut test.risc1 -overwrite -l fgen_v.log

vc_vcfdb_report:
	vc_fdb_report -campaign riscdemo -report fgen_v.rpt -overwrite 

vc_fcm_local:
	vc_fcm -tcl_script ./COLLATERAL/FCM/fcm_local.tcl -connect -fc riscdemo

## Z01X ##

z_comp:
	zoix -f ./run.f ./src/strobe.sv -flop -fsdb +sv -l comp_z.log
	
z_fr2fdef:
	fr2fdef +format+standard -fr ./COLLATERAL/SFF/config.sff ./COLLATERAL/SFF/faults.sff +maintainflop +warnreturn+0 -l fgen_z.log
	
z_fault_report:
	fault_report -out fgen_z.rpt 
	
z_fmsh_local:
	fmsh -load ./COLLATERAL/FMSH/user_local.fmsh
