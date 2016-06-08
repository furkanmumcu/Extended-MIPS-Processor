`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:14:36 10/18/2015 
// Design Name: 
// Module Name:    mips 
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
//--------------------------------------------------------------
// mips.v
//
// Written by: David Harris and Sarah Harris 23 October 2005
//
// Modified by: Furkan Mumcu
//
// Single-cycle MIPS processor
//--------------------------------------------------------------


// single-cycle MIPS processor

module mips (input         clk, reset,
             output [31:0] pc,
             input  [31:0] instr,
             output        memwrite,
             output [31:0] aluout, writedata,
             input  [31:0] readdata,
				 output atomic);

  wire         pcsrc, zero, ll, sc, 
              alusrc,  regwrite, jump;
  wire [2:0]  alucontrol;
	wire [1:0] memtoreg, regdst;
	
  controller c (instr[31:26], instr[5:0], zero,
               memtoreg, memwrite, pcsrc,
               alusrc, regdst, regwrite, jump, ll, sc, atomic,
               alucontrol);
  datapath dp (clk, reset, memtoreg, pcsrc,
              alusrc, regdst, regwrite, jump,
              alucontrol, zero, pc, instr,
              aluout, writedata, readdata,ll,sc);
endmodule


module controller(input  [5:0] op, funct,
                  input        zero,
                  output      [1:0] memtoreg, 
						output 		memwrite,
                  output       pcsrc, alusrc,
                  output       [1:0]regdst, 
						output regwrite,
                  output       jump,
                  output			ll, sc,
						input atomic,
						output [2:0] alucontrol);

  wire [1:0] aluop;
  wire       branch;

  maindec md (op, regwrite, regdst, alusrc, branch,
             memwrite, memtoreg, aluop, jump,ll,sc);
  aludec  ad (funct, aluop, alucontrol);
	
  //assign newmemwrite = memwrite + 0;
  //assign memwrite = atomic | newmemwrite;
  assign pcsrc = branch & zero;
endmodule

module maindec(input  [5:0] op,
               output       regwrite, 
					output [1:0] regdst,
               output       alusrc, branch, 
               output       memwrite, 
					output [1:0] memtoreg,
               output [1:0] aluop, 
               output       jump,
					output ll,sc);

  reg [12:0] controls;
  
  assign {regwrite, regdst, alusrc, branch, 
          memwrite, memtoreg, aluop, jump,ll,sc} = controls;

  always @(*)
    case(op)
		6'b000000: controls <= 13'b1100000010000; //R-type
		6'b100011: controls <= 13'b1001001000000; //LW
		6'b101011: controls <= 13'b0001010000000; //SW
		6'b000100: controls <= 13'b0000100001000; //BEQ
		6'b001000: controls <= 13'b1001000000000; //ADDI
		6'b000010: controls <= 13'b0000000000100; //J
		6'b111000: controls <= 13'b1001000100010; //ll
		6'b110000: controls <= 13'b1001001100001; //sc
		6'b111110: controls <= 13'b1011011000000; //sw+
		6'b001100: controls <= 10'b1010000010000; //subi
		6'b111111: controls <= 10'b0010000001000; //jm
		default:   controls <= 12'bxxxxxxxxxxxx; //???
    endcase
endmodule

module aludec(input      [5:0] funct,
              input      [1:0] aluop,
              output reg [2:0] alucontrol);

  always @(*)
    case(aluop)
      2'b00: alucontrol <= 3'b010;  // add
      2'b01: alucontrol <= 3'b110;  // sub
      default: case(funct)          // RTYPE
          6'b100000: alucontrol <= 3'b010; // ADD
          6'b100010: alucontrol <= 3'b110; // SUB
          6'b100100: alucontrol <= 3'b000; // AND
          6'b100101: alucontrol <= 3'b001; // OR
          6'b101010: alucontrol <= 3'b111; // SLT
          default:   alucontrol <= 3'bxxx; // ???
        endcase
    endcase
endmodule

module datapath(input         clk, reset,
                input   [1:0]      memtoreg, 
					 input pcsrc,
                input         alusrc, 
					 input [1:0] regdst,
                input         regwrite, jump,
					 input  [2:0]  alucontrol,
                output        zero,
                output [31:0] pc,
                input  [31:0] instr,
                output [31:0] aluout, writedata,
                input  [31:0] readdata,
					 input ll, sc,
					 output atomic);

  wire [4:0]  writereg;
  wire [31:0] pcnext, pcnextbr, pcplus4, pcbranch;
  wire [31:0] signimm, signimmsh;
  wire [31:0] srca, srcb;
  wire [31:0] result;
	wire [31:0] testout;
	wire [31:0] scrap4;
	wire eqout;
	//wire atomic;
	wire [31:0] writeforSC;
	//wire newmemwrite;
  // next PC logic
  flopr #(32) pcreg(clk, reset, pcnext, pc);
  adder       pcadd1(pc, 32'b100, pcplus4);
  sl2         immsh(signimm, signimmsh);
  adder       pcadd2(pcplus4, signimmsh, pcbranch);
  mux2 #(32)  branchmux(pcplus4, pcbranch, pcsrc,
                      pcnextbr);
  mux2 #(32)  jumpmux(pcnextbr, {pcplus4[31:28], 
                    instr[25:0], 2'b00}, 
                    jump, pcnext);
					
 mux22 mmuuxx(pcnextbr, {pcplus4[31:28], 
                    instr[25:0], 2'b00},readdata,
                    jump, pcnext);

  
  
  // register file logic
  regfile     rf(clk, regwrite, instr[25:21],
                 instr[20:16], writereg,
                 result, srca, writedata);
 
	// atomic logic
	
	regfilell  test(clk, ll , readdata, testout);
	Equality   eq(testout, readdata, eqout);
	Equality1bit eq1 (sc, eqout, atomic);
	
	muxbit m1 (32'b000, 32'b001, atomic, writeforSC);
	/////////////////////////////////////////////////////////

  mux5bit   w_addrmux(instr[20:16], instr[15:11], instr[25:21],
                    regdst, writereg);
	
		 adder plus4(srca, 32'b100, scrap4);
  mux32bit  w_datamux(aluout, readdata, scrap4,writeforSC,
                     memtoreg, result);
  signext     se(instr[15:0], signimm);

  // ALU logic
  mux2 #(32)  srcbmux(writedata, signimm, alusrc,
                      srcb);
  alu         alu(srca, srcb, alucontrol,
                  aluout, zero);

///
	
	//assign newmemwrite = atomic | memwrite;
	
endmodule

//////////////////////////////////////////////////////////////////////////////////

module regfilell(input        clk, 
               input         we3, 
               input  [31:0] wd3, 
               output reg [31:0] rd1);

  

  // three-ported register file
  // read two ports combinationally
  // write third port on rising edge of clock
  // register 0 hardwired to 0

  always @(posedge clk)
    if (we3) rd1 <= wd3;	

  
endmodule

module Equality (A, B, out);

  input [31:0] A, B;
  output  out;
	//assign out = 0;	
	//assign out = (A == B) ? 1 | 0;
	assign out = (A==B)?1:0;
endmodule

module Equality1bit (A, B, out);

  input  A, B;
  output  out;
	//assign out = 0;	
	assign out = (A & B);

endmodule


module muxbit (input [31:0] a,b,
				  input [1:0] ctrl,
				  output reg[31:0] out);
		
		always@(a,b,ctrl)
		
		if(ctrl==1'b0)
			out<=a;
		
		else if(ctrl==1'b1)
			out<=b;

endmodule

module mux32bit (input [31:0] a,b,c,d,
				  input [1:0] ctrl,
				  output reg[31:0] out);
		always@(a,b,c,ctrl)
		
		if(jump==2'b00)
			out<=a;
		
		else if(ctrl==2'b01)
			outj<=b;
		
		else if(ctrl==2'b11)
			outj<=c;
		
		else if(ctrl==2'b10)
			out<=d;
endmodule

module mux5bit (input [4:0] a,b,c,
				  input [1:0] ctrl,
				  output reg[31:0] out);
		always@(a,b,c,ctrl)
		
		if(ctrl==2'b00)
			out<=a;
		
		else if(ctrl==2'b01)
			out<=b;
		
		else if(ctrl==2'b10)
			out <=c;
endmodule

module mux22 (input [31:0] a,b,c,
				  input [1:0] jump,
				  output reg[31:0] outjump);
		always@(a,b,c,jump)
		if(jump==2'b00)
			outjump<=a;
		else if(jump==2'b01)
			outjump<=b;
		else if(jump==2'b10)
			outjump<=c;
endmodule