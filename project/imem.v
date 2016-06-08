`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:15:42 10/18/2015 
// Design Name: 
// Module Name:    imem 
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
// imem.v 
//
// External instruction memory used by MIPS single-cycle processor
//
//------------------------------------------------



module imem (	input [5:0] addr,
    		output reg [31:0] instr);

	always@(addr)
	   case ({addr,2'b00})
//		address		instruction
//		-------		-----------

8'h00: instr = 32'h20020007;  // addi   v0, zero, 7 
8'h04: instr = 32'h2003000c; // addi   v1, zero, 12
8'h08: instr = 32'h2067fff7; // addi   a3, v1, -9
8'h0c: instr = 32'hf8430008; // sw+    v1, 8, v0
8'h10: instr = 32'h20420004;
8'h14: instr = 32'h20420000; // addi   v0, v0, 0
8'h18: instr = 32'h20020005;
8'h1c: instr = 32'h2003000c;
8'h20: instr = 32'h00000030; // first sc
8'h24: instr = 32'he0630001; // ll
8'h28: instr = 32'hc0420002; // second sc
8'h2c: instr = 32'h2003000c;
8'h30: instr = 32'h20020005;

	      default: instr = {32{1'bx}};	// unknown instruction
	    endcase

endmodule