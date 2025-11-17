/*******************************************************************************
* (c) 2016 Synopsys, Inc.
*
* This file and it's contents are proprietary to Synopsys, Inc. and may 
* only be used pursuant to the terms and conditions of a written license 
* agreement with Synopsys, Inc. All other use, reproduction, modification, 
* or distribution of this file is stricly prohibited.
*******************************************************************************/

module reseter (reset, reset_req, fetch, clk_2);
input reset_req, fetch, clk_2;
output reset;
reg reset;

always @(reset_req)
  if (reset_req == 0)
    reset = 0;

always @ (posedge reset_req)
	@  (negedge fetch)
	  @ (negedge clk_2)
	    #1 reset = 1;

endmodule
