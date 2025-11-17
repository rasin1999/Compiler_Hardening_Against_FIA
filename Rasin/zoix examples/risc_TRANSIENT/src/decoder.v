/*******************************************************************************
* (c) 2016 Synopsys, Inc.
*
* This file and it's contents are proprietary to Synopsys, Inc. and may 
* only be used pursuant to the terms and conditions of a written license 
* agreement with Synopsys, Inc. All other use, reproduction, modification, 
* or distribution of this file is stricly prohibited.
*******************************************************************************/

`timescale 100ps / 100ps

module decoder (load_accum,mem_read,mem_wr,inc_pc,load_pc,load_ir,
		        opcode,fetch,zero,clk,clk_2, not_reset);

  parameter  cycle = 20;

  input       fetch,zero,clk,clk_2, not_reset;
  input [2:0] opcode;
  output      load_accum,mem_read,mem_wr,inc_pc,load_pc,load_ir;

  wire [2:0] opcode;
  reg        load_accum,mem_read,mem_wr,inc_pc,load_pc,load_ir;

  integer cmp;

  always @(negedge fetch)
    begin   // reset active low
	  mem_read = 0;
      inc_pc = 1;
      load_ir = 0;

      @(posedge clk)
        begin
          if (opcode >= 3'h2 && opcode <= 3'h5)
            mem_read = 1;
          inc_pc = 0;
        end

      @(negedge clk_2)
        begin
            case (opcode)
                        // Normal termination
              3'h0    :
                begin
                    cmp = $fs_compare(opcode,not_reset);
                    if (cmp > 0) $fs_drop_status("ON", opcode,not_reset);
                    if (not_reset) $finish;
                end
              3'h1    : if (zero) inc_pc = 1;
              3'h2    : load_accum = 1;
              3'h3    : load_accum = 1;
              3'h4    : load_accum = 1;
              3'h5    : load_accum = 1;
              3'h6    : ;
              3'h7    : load_pc = 1;
              default :
                begin
            	      $display("bad opcode");
                      cmp = $fs_compare(opcode);
                      if (cmp > 0) $fs_drop_status("OD",opcode);
            	      $finish;
                end
            endcase
        end

        @(posedge clk)
		  if (opcode == 3'h6) mem_wr = 1;

        if (opcode == 3'h7) inc_pc = 1;

    end

  always @(posedge fetch)
    begin  // reset active low
      inc_pc = 0;
      load_accum = 0;
      load_pc = 0;
      mem_wr = 0; 
      mem_read = 0;
      @(posedge clk) mem_read = 1;
      @(negedge clk_2) load_ir = 1;
    end

  initial
    begin
      load_accum = 0;
      load_pc = 0;
      mem_wr = 0; 
      mem_read = 0;
      inc_pc = 0;
      load_ir = 0;
    end

endmodule
