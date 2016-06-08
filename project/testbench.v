`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:27:55 10/18/2015
// Design Name:   top
// Module Name:   C:/Users/furka_000/Desktop/p2/mipsProcc/testbench.v
// Project Name:  mipsProcc
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
// by Furkan Mumcu
////////////////////////////////////////////////////////////////////////////////

module testbench();

  reg         clk;
  reg         reset;

  wire [31:0] writedata, dataadr, pc, instr;
  wire memwrite;

  // instantiate device to be tested
  top dut(clk, reset, writedata, dataadr, memwrite,pc,instr);
  
  // initialize test
  initial
    begin
      reset <= 1; # 22; reset <= 0;
    end

  // generate clock to sequence tests
  always
    begin
      clk <= 1; # 5; clk <= 0; # 5;
    end

  // check that 7 gets written to address 84

endmodule

