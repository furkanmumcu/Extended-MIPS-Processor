`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:16:03 10/18/2015 
// Design Name: 
// Module Name:    dmem 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------
// 
// External data memory used by MIPS single-cycle
// processor
//------------------------------------------------

module dmem(input         clk, we, atomic,
            input  [31:0] addr, wd,
            output [31:0] rd);

  reg  [31:0] RAM[63:0];
	wire newcont;
	assign newcont = we | atomic;
  assign rd = RAM[addr[31:2]]; // word aligned read (for lw)

  always @(posedge clk)
    if (newcont)
      RAM[addr[31:2]] <= wd;   // word aligned write (for sw)

endmodule