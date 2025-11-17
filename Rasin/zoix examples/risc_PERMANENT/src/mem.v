/*******************************************************************************
* (c) 2016 Synopsys, Inc.
*
* This file and it's contents are proprietary to Synopsys, Inc. and may 
* only be used pursuant to the terms and conditions of a written license 
* agreement with Synopsys, Inc. All other use, reproduction, modification, 
* or distribution of this file is stricly prohibited.
*******************************************************************************/

`timescale 100 ps / 100 ps

module mem (data, addr, read, write);
  input       read, write;
  input [4:0] addr;

  inout [7:0] data;

  reg   [7:0] memory [0:8'h1f];

  assign data = (read) ? memory[addr] : 8'bz;

  always @(posedge write)
begin
    $display("write mem[%0d]: %0d", addr, data);
    memory[addr] = data;
end

  task dumpmem;
    reg [5:0] i;

    begin 
      for (i = 0; i < 32; i = i + 1)
        begin
          if (!(i & 15)) $display; 
          $write("%h:%h  ", i, memory[i]);
        end
      $display;
      $stop(0);
    end
  endtask

string testname;
integer success;
  initial 
    begin
        success = $value$plusargs("TESTNAME=%s", testname);
        $readmemb({testname,".dat"},memory);     // program
    end

endmodule
