class latch;

int count;

task eval(input clk, input d, inout q);
    count = count + 1;
    q = clk ? d : q;
endtask

endclass

module test;
reg i, j;

dut d1(o1, o3, i, j);
dut d2(o2, o4, o3, j);

initial begin
    #1;
    i = 1;
    j = 0;
    #1;
    i = 0;
    j = 1;
    #1;
    i = 0;
    j = 0;
    #1;
    i = 1;
    j = 1;
    #1;
`ifdef ZOIX
    $fs_strobe(o1, o2, o3, o4); 
`endif
end

endmodule

`suppress_faults
`enable_portfaults
module dut(o1, o2, i, j);
output o1, o2;
input i, j;
reg o1;

assign o2 = j ? i : o2;

latch a = new;

always @(i or j) begin
    a.eval(i, j, o1);
end

final $display("count:",, a.count);

endmodule
