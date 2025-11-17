/*******************************************************************************
* (c) 2016 Synopsys, Inc.
*
* This file and it's contents are proprietary to Synopsys, Inc. and may 
* only be used pursuant to the terms and conditions of a written license 
* agreement with Synopsys, Inc. All other use, reproduction, modification, 
* or distribution of this file is stricly prohibited.
*******************************************************************************/

`timescale 100 ps / 100 ps

module counter (cnt,clk,data,rst,le);
  input        clk, rst, le;
  input  [5:1] data;
  output [5:1] cnt;

  wire [5:1] data,cnt,mcnt,next_cnt;

  dff d1 (cnt[1],next_cnt[1],clk,mcnt[1],rst),
      d2 (cnt[2],,clk,mcnt[2],rst),
      d3 (cnt[3],,clk,mcnt[3],rst),
      d4 (cnt[4],,clk,mcnt[4],rst),
      d5 (cnt[5],,clk,mcnt[5],rst);

  mux m1 (mcnt[1],data[1],next_cnt[1],le),
      m2 (mcnt[2],data[2],next_cnt[2],le),
      m3 (mcnt[3],data[3],next_cnt[3],le),
      m4 (mcnt[4],data[4],next_cnt[4],le),
      m5 (mcnt[5],data[5],next_cnt[5],le);

  xor x2 (next_cnt[2],cnt[1],cnt[2]);

  and a3 (an3,cnt[1],cnt[2]);
  xor x3 (next_cnt[3],an3,cnt[3]);

  and a4 (an4,cnt[1],cnt[2],cnt[3]);
  xor x4 (next_cnt[4],an4,cnt[4]);

  and a5 (an5,cnt[1],cnt[2],cnt[3],cnt[4]);
  xor x5 (next_cnt[5],an5,cnt[5]);

endmodule

module mux (muxout,in1,in0,sel);
  input  in1, in0, sel;
  output muxout;

  not n1(selb,sel);

  and a1(selh,in1,sel),
      a2(sell,in0,selb);

  or  o1(muxout,selh,sell);

endmodule
