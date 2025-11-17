// 4-bit Adder in Verilog
module four_bit_adder (
    input  [3:0] A,   // 4-bit input A
    input  [3:0] B,   // 4-bit input B
	input  [3:0] C,
    output [3:0] SUM, // 4-bit Sum output
    output COUT        // Carry-out
);
	wire [4:0] SumAB;
	
	assign SumAB = A + B;
    assign {COUT, SUM} = SumAB + C;

endmodule
