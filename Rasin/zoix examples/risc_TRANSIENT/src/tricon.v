/*******************************************************************************
* (c) 2016 Synopsys, Inc.
*
* This file and it's contents are proprietary to Synopsys, Inc. and may 
* only be used pursuant to the terms and conditions of a written license 
* agreement with Synopsys, Inc. All other use, reproduction, modification, 
* or distribution of this file is stricly prohibited.
*******************************************************************************/

module tricon (o, i, ctl);
  output [7:0] o;
  input  [7:0] i;
  input        ctl;

  assign o = ctl ? i : 8'bz;

endmodule
