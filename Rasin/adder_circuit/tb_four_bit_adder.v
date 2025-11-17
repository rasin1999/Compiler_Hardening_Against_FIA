`timescale 1ns/1ps

module tb_four_bit_adder;

    // Testbench signals
    reg  [3:0] A;
    reg  [3:0] B;
    reg  [3:0] C;
    wire [3:0] SUM;
    wire COUT;

    // Instantiate the DUT (Device Under Test)
    four_bit_adder uut (
        .A(A),
        .B(B),
        .C(C),
        .SUM(SUM),
        .COUT(COUT)
    );

    // Test procedure
    initial begin
        // Display header
        $display("Time\tA\tB\tC\t|\tCOUT\tSUM");
        $display("-------------------------------------");

        // Apply test vectors
        A = 4'b0001; B = 4'b0010; C = 4'b0000; #10;
        $display("%0t\t%b\t%b\t%b\t|\t%b\t%b", $time, A, B, C, COUT, SUM);

        A = 4'b0111; B = 4'b0001; C = 4'b0001; #10;
        $display("%0t\t%b\t%b\t%b\t|\t%b\t%b", $time, A, B, C, COUT, SUM);

        A = 4'b1111; B = 4'b1111; C = 4'b0001; #10;
        $display("%0t\t%b\t%b\t%b\t|\t%b\t%b", $time, A, B, C, COUT, SUM);

        A = 4'b1010; B = 4'b0101; C = 4'b0011; #10;
        $display("%0t\t%b\t%b\t%b\t|\t%b\t%b", $time, A, B, C, COUT, SUM);

        $display("-------------------------------------");
		
		$dumpfile("adder_wave.vcd");
		$dumpvars(0, tb_four_bit_adder);

        $finish;
    end

endmodule
