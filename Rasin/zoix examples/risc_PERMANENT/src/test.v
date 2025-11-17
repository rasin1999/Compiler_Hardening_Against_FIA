/*******************************************************************************
* (c) 2016 Synopsys, Inc.
*
* This file and it's contents are proprietary to Synopsys, Inc. and may 
* only be used pursuant to the terms and conditions of a written license 
* agreement with Synopsys, Inc. All other use, reproduction, modification, 
* or distribution of this file is stricly prohibited.
*******************************************************************************/

`timescale 100ps / 100ps

module test;
  parameter ops = 10;

  reg        reset_req;
  reg [2:0]  op [0:ops-1];
  reg [31:0] tstamp [0:ops-1];
  reg [31:0] opcnt [0:7];

  integer    i;

  // CPU instance
  cpu risc1 (reset_req);

  initial
    reset_cpu; 

  initial
    $timeformat(-9, 2, " ns", 20);

  task reset_cpu;
    begin
     reset_req = 0;
     #1 reset_req = 1;
    end
  endtask

  initial optrace;

  task optrace;
    forever @(test.risc1.ireghi[8:6])
      $display($time,,"opcode = %s", op2str(test.risc1.ireghi[8:6])); 
  endtask

  task opcnt_monitor;
    input     cont; // if 0, clear counts and resume; if 1, preserve existing counts and resume
    integer   i;
    reg [2:0] op;

    begin
      if (!cont)
        for (i = 0; i < 8; i = i + 1)
          opcnt[i] = 0;
      
      forever @(test.risc1.ireghi[8:6])
        begin
          op = test.risc1.ireghi[8:6];
          opcnt[op] = opcnt[op] + 1;
        end
    end
  endtask

  task opstream_monitor;
    forever @(test.risc1.ireghi[8:6])
      begin
        for (i = (ops-1); i > 0; i = i - 1)
          begin
            op[i] = op[i-1];
            tstamp[i] = tstamp[i-1];
          end
        op[0] = test.risc1.ireghi[8:6]; tstamp[0] = $stime; 
      end
  endtask

  function [8*8:1] op2str;
    input [2:0] op;
    case (op)
      0       : op2str = "halt    ";
      1       : op2str = "skz     ";
      2       : op2str = "add     ";
      3       : op2str = "and     ";
      4       : op2str = "xor     ";
      5       : op2str = "load    ";
      6       : op2str = "store   ";
      7       : op2str = "jump    ";
      default : op2str = "????????";
    endcase 
  endfunction

  initial
    forever @(negedge test.risc1.fetch)
      if (test.risc1.ireghi[8:6] == 3'h7 )
        $display(test.risc1.mem1.memory[5'h1a]);

  reg [7:0] tmp;

initial begin
`ifdef DUMP_VCD
   $dumpvars();
`endif
`ifdef DUMP_FSDB   
   $fsdbDumpvars();
`endif   
end

endmodule

