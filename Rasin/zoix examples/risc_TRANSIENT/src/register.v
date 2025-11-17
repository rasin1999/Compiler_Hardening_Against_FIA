/*******************************************************************************
* (c) 2016 Synopsys, Inc.
*
* This file and it's contents are proprietary to Synopsys, Inc. and may 
* only be used pursuant to the terms and conditions of a written license 
* agreement with Synopsys, Inc. All other use, reproduction, modification, 
* or distribution of this file is stricly prohibited.
*******************************************************************************/

module register(r,clk,data,ena,rst);
input clk,ena,rst;
input [8:1] data;
output [8:1] r;

wire [8:1] data,r;

and a1(load,clk,ena);
dff d1(r[1],,load,data[1],rst),
    d2(r[2],,load,data[2],rst),
    d3(r[3],,load,data[3],rst),
    d4(r[4],,load,data[4],rst),
    d5(r[5],,load,data[5],rst),
    d6(r[6],,load,data[6],rst),
    d7(r[7],,load,data[7],rst),
    d8(r[8],,load,data[8],rst);

endmodule
