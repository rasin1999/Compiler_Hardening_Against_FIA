`timescale 1ns/1ps
module done_fanin (
  input  wire rst,   // synchronous enable/gate in this design
  input  wire ld,    // load/control bit
  input  wire clk,
  output reg  done
);
  reg dcnt0, dcnt1, dcnt2, dcnt3;

  // convenience
  wire any_one = dcnt0 | dcnt1 | dcnt2 | dcnt3;

  // Synchronous next-state logic (simplified from the gate cones)
  always @(posedge clk) begin
    // When rst=0, all flops synchronously drive to 0 (since every D has a factor of rst)
    dcnt0 <= rst & (  ld | ( ~ld & any_one & ~dcnt0 ) );
    dcnt1 <= rst & (  ld | ( ~ld & any_one & ~(dcnt0 ^ dcnt1) ) );
    dcnt2 <= rst & ( ~ld & dcnt2 & (dcnt1 | dcnt0) );
    dcnt3 <= rst & (  ld | ( ~ld & dcnt3 & (dcnt2 | dcnt1 | dcnt0) ) );

    // done is high exactly when ld=0 and dcnt == 4'b0001
    done  <= (~dcnt3) & (~dcnt2) & (~dcnt1) & dcnt0 & (~ld);
  end
endmodule
