/*******************************************************************************
* (c) 2016 Synopsys, Inc.
*
* This file and it's contents are proprietary to Synopsys, Inc. and may 
* only be used pursuant to the terms and conditions of a written license 
* agreement with Synopsys, Inc. All other use, reproduction, modification, 
* or distribution of this file is stricly prohibited.
*******************************************************************************/

`timescale 100 ps / 100 ps

module clocks (fetch,clk_2,clk);
  output fetch,clk,clk_2;
  reg    fetch,clk_2;
  reg    start;

  nor #10 (clk, clk, start);

  initial
   begin
     fetch = 0;
     clk_2 = 0;
     start = 1;
     #20 start = 0;
   end

  always @(negedge clk)
    clk_2 = ~clk_2;

  always @(posedge clk_2)
    fetch = ~fetch;

endmodule
