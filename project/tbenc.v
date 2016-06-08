`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:34:44 11/09/2015
// Design Name:   top
// Module Name:   C:/Users/furka_000/Desktop/p2v1/mipsProcc/tbenc.v
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
// by Furkan Mumcu
////////////////////////////////////////////////////////////////////////////////

module tbenc;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire [31:0] writedata;
	wire [31:0] dataadr;
	wire memwrite;
	wire [31:0] pc;
	wire [31:0] instr;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clk(clk), 
		.reset(reset), 
		.writedata(writedata), 
		.dataadr(dataadr), 
		.memwrite(memwrite), 
		.pc(pc), 
		.instr(instr)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

