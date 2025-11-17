/*******************************************************************************
* (c) 2016 Synopsys, Inc.
*
* This file and it's contents are proprietary to Synopsys, Inc. and may 
* only be used pursuant to the terms and conditions of a written license 
* agreement with Synopsys, Inc. All other use, reproduction, modification, 
* or distribution of this file is stricly prohibited.
*******************************************************************************/

`timescale 100 ps / 100 ps

module alu (alu_out,zero,opcode,data,accum,clock);
  input [7:0]  data,accum;
  input [2:0]  opcode;
  input        clock;

  output [7:0] alu_out;
  reg [7:0]    alu_out;

  output       zero;
  reg          zero;

  initial
    zero = 0;

always @(clock)
	$display($time,,"in always @ %m, clock= %b", clock);

always @(negedge clock)
	$display($time,,"in always @negedge  %m, clock=%b", clock);


  always @(negedge clock)
    case (opcode)
      3'h0: alu_out = accum;
      3'h1: alu_out = accum;
      3'h2: alu_out = accum + data;
      3'h3: alu_out = accum & data;
      3'h4: alu_out = accum ^ data;
      3'h5: alu_out = data;
      3'h6: alu_out = accum;
      3'h7: alu_out = accum;
      default: $display("invalid opcode");
    endcase

  always @(accum)
    if (!accum)
      zero = 1;
	else
      zero = 0;

endmodule
