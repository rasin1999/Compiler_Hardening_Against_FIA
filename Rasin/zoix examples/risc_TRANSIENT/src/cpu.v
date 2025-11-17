/*******************************************************************************
* (c) 2016 Synopsys, Inc.
*
* This file and it's contents are proprietary to Synopsys, Inc. and may 
* only be used pursuant to the terms and conditions of a written license 
* agreement with Synopsys, Inc. All other use, reproduction, modification, 
* or distribution of this file is stricly prohibited.
*******************************************************************************/

`timescale 100 ps / 100 ps

module cpu (reset_req);
  input       reset_req;
  wire [7:0]  alu_out;
  wire [7:0]  data;
  wire [7:0]  accum;
  wire [4:0]  address;
  wire [4:0]  pcaddr;
  wire [8:5]  ireghi;
  wire [4:1]  ireglo;
  wire        clock, clock2;
  wire        clock_temp;

  event dbevt;

  // hook for VirSim event display
  always
    begin
      wait ((clock===1'b1) && (clock2===1'b1) && (data===8'bz))
        begin
          ->dbevt;
        end
      wait (clock==1'b0);
    end

  tricon   tricon  (data[7:0], alu_out[7:0], ~(mem_read | fetch | clock2));

  mux2x5   mux2x5  (address[4:0], {ireghi[5], ireglo}, pcaddr, fetch);

  reseter  reseter (reset, reset_req, fetch, clock2);

  register instreg ({ireghi, ireglo}, clock, data[7:0], load_ir, reset);

  register alureg  (accum, clock, alu_out[7:0], load_accum, reset);

  mem      mem1    (data[7:0], address[4:0], mem_read, mem_write);

  decoder  instdec (load_accum, mem_read, mem_write, inc_pc, load_pc, load_ir,
                    ireghi[8:6], fetch, zero, clock, clock2, reset);

  counter  pgmctr  (pcaddr, inc_pc, {ireghi[5], ireglo}, reset, load_pc);

  clocks   clks    (fetch, clock2, clock);

	assign #0 clock_temp = clock | fetch | clock2;
  alu      alu1    (alu_out[7:0], zero, ireghi[8:6], data[7:0], accum, clock_temp);
  //alu      alu1    (alu_out[7:0], zero, ireghi[8:6], data[7:0], accum, clock | fetch | clock2);

  initial
    $monitor($time,, test.risc1.alu_out,, test.risc1.fetch,, test.risc1.ireghi[8:6]);

endmodule
