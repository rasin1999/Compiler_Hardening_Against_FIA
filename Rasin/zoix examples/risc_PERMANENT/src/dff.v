/*******************************************************************************
* (c) 2016 Synopsys, Inc.
*
* This file and it's contents are proprietary to Synopsys, Inc. and may 
* only be used pursuant to the terms and conditions of a written license 
* agreement with Synopsys, Inc. All other use, reproduction, modification, 
* or distribution of this file is stricly prohibited.
*******************************************************************************/

`timescale 100 ps / 100 ps

`celldefine

`suppress_faults
`enable_portfaults

module dff(q,qb,clk,d,rst);
  input  d, clk, rst;
  output q, qb;

  dflop d1 (q_, d, clk, rst);
  buf   b1 (q, q_);
  not   n1 (qb, q);

endmodule

`disable_portfaults
`nosuppress_faults

`endcelldefine

primitive dflop (q, d, clk, rst);
  input  d, clk, rst;
  output q;
  reg    q;

  table
  // d clk  rst : q_old : q_new
     ?  ?    0  :   ?   :   0;
     ?  ?    x  :   0   :   0;
     0  r    1  :   ?   :   0;
 //  0 (01)  1  :   ?   :   0;
     1  r    1  :   ?   :   1;
 //  1 (01)  1  :   ?   :   1;
     ?  f    1  :   ?   :   -;
 //  ? (10)  1  :   ?   :   -;
     *  ?    ?  :   ?   :   -;
     ?  ?    *  :   ?   :   -;
  endtable

endprimitive
