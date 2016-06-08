`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:17:08 10/18/2015 
// Design Name: 
// Module Name:    mipsparts 
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
//------------------------------------------------
// mipsparts.v
// Components used in MIPS processor
//------------------------------------------------

module alu(input      [31:0] A, B, 
           input      [2:0]  ALUControl, 
           output reg [31:0] Result,
           output            Zero);	
			  always @ (A or B or ALUControl)
		case(ALUControl)
		  3'b000: Result = A & B; // AND
		  3'b001: Result = A | B; // OR
		  3'b010: Result = A + B; // ADD
		  3'b011: Result = 32'b11111111111111111111111111111111; //invalid
		  3'b100: Result = 32'b11111111111111111111111111111111; //invalid
		  3'b101: Result = 32'b11111111111111111111111111111111; //invalid
		  3'b110: Result = A - B; // SUB
		  3'b111: Result = (A < B)? 1:0; // SLT - set if less than
		 default: Result = {4{1'b1}}; //undefined ALU operation
		endcase

		assign Zero = Result == 32'b0000000000000000000000000000;
		endmodule

module regfile(input         clk, 
               input         we3, 
               input  [4:0]  ra1, ra2, wa3, 
               input  [31:0] wd3, 
               output [31:0] rd1, rd2);

  reg [31:0] rf[31:0];

  // three-ported register file
  // read two ports combinationally
  // write third port on rising edge of clock
  // register 0 hardwired to 0

  always @(posedge clk)
    if (we3) rf[wa3] <= wd3;	

  assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
  assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule

module adder(input [31:0] a, b,
             output [31:0] y);

  assign y = a + b;
endmodule

module sl2(input  [31:0] a,
           output [31:0] y);

  // shift left by 2
  assign y = {a[29:0], 2'b00};
endmodule

module signext(input  [15:0] a,
               output [31:0] y);
              
  assign y = {{16{a[15]}}, a};
endmodule

module flopr #(parameter WIDTH = 8)
              (input                  clk, reset,
               input      [WIDTH-1:0] d, 
               output reg [WIDTH-1:0] q);

  always @(posedge clk, posedge reset)
    if (reset) q <= 0;
    else       q <= d;
endmodule

module flopenr #(parameter WIDTH = 8)
                (input                  clk, reset,
                 input                  en,
                 input      [WIDTH-1:0] d, 
                 output reg [WIDTH-1:0] q);
 
  always @(posedge clk, posedge reset)
    if      (reset) q <= 0;
    else if (en)    q <= d;
endmodule

module mux2 #(parameter WIDTH = 8)
             (input  [WIDTH-1:0] d0, d1, 
              input              s, 
              output [WIDTH-1:0] y);

  assign y = s ? d1 : d0; 
endmodule
