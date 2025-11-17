/*******************************************************************************
* (c) 2017 Synopsys, Inc.
*
* This file and it's contents are proprietary to Synopsys, Inc. and may 
* only be used pursuant to the terms and conditions of a written license 
* agreement with Synopsys, Inc. All other use, reproduction, modification, 
* or distribution of this file is stricly prohibited.
*******************************************************************************/

module strobe;

  integer cmp;
`ifdef DUMP_FSDB
  initial begin
     $fsdbDumpvars();
     $fsdbDumpMDA;
  end
`endif  

/*
* Whenever the fetch signal transitions to 1'b0, compare the output of the
* device. If it shows a difference (GM-FM are different), set the status to ON or
* PN (if there is an X involved).  Continue to simulate the fault.  This 
* indicates the fault is dangerous and can cause the device to fail.
*/
  initial
    begin
      forever @(negedge test.risc1.fetch)
        begin
          #25
          // Compare alu_out signal in GM and FM
          cmp = $fs_compare(test.risc1.alu_out);
          if (1 == cmp)
            begin
              // cmp == 1 indicates diff in GM and FM signals
              $fs_set_status("ON", test.risc1.alu_out);
              break;
            end
          else if (2 == cmp)
            begin
              // cmp == 2 indicates diff in GM and FM signals with X
              $fs_set_status("PN", test.risc1.alu_out);
              break;
            end
        end
    end

  integer i;
  string status;
  reg [7:0] tmp;

/*
* At the end of the simulation, compare the memory inside the device.  If a 
* difference is observed, set the status to observed detected and drop the fault
* from simulation.  If the status was not previously observed, set it to 
* diagnosed, but not observed.
*/
`ifndef ZOIX
  final begin
    // Get current status of fault
    status = $fs_get_status();
    // tmp = test.risc1.mem1.memory[i];
    // Compare memory word in GM and FM
		$display("VCS Simulation");
    cmp = $fs_compare(test.risc1.mem1.memory);
		$display("Compare mem, cmp val %d", cmp);
    // cmp == 1 indicates diff in GM and FM in memory word
    if (1 == cmp)
      begin
        if ((status == "ON") || (status == "PN"))
          // if status is observed, drop observed diagnosed
          $fs_drop_status("OD");
        else
          // if status was not observed, drop not observed, diagnosed
          $fs_drop_status("ND");
      end
    // cmp == 2 indicates diff in GM and FM in memory word with X
    else if (2 == cmp)
      begin
        if ((status == "ON") || (status == "PN"))
          // if status is observed, drop observed potentially diagnosed
          $fs_drop_status("OP");
        else
          // if status was not observed, drop not observed, potentially diagnosed
          $fs_drop_status("NP");
      end
    end

`else			

  final
    for (i = 0; i <= 31; i = i + 1)
      begin
        // Get current status of fault
        status = $fs_get_status();
        tmp = test.risc1.mem1.memory[i];
        // Compare memory word in GM and FM
        cmp = $fs_compare(tmp);
				$display("Compare mem %d, Has val %d", i, cmp);
        // cmp == 1 indicates diff in GM and FM in memory word
        if (1 == cmp)
          begin
            if ((status == "ON") || (status == "PN"))
              // if status is observed, drop observed diagnosed
              $fs_drop_status("OD");
            else
              // if status was not observed, drop not observed, diagnosed
              $fs_drop_status("ND");
            break;
          end
        // cmp == 2 indicates diff in GM and FM in memory word with X
        else if (2 == cmp)
          begin
            if ((status == "ON") || (status == "PN"))
              // if status is observed, drop observed potentially diagnosed
              $fs_drop_status("OP");
            else
              // if status was not observed, drop not observed, potentially diagnosed
              $fs_drop_status("NP");
            break;
          end
      end
`endif

endmodule
