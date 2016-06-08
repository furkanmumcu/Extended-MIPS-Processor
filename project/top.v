`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:17:32 10/18/2015 
// Design Name: 
// Module Name:    top 
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
// By Furkan Mumcu
//
//////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------

// top.v

// David_Harris@hmc.edu 9 November 2005

// Top level system including MIPS and memories

//------------------------------------------------



module top( input         clk, reset,
 
           output [31:0] writedata, dataadr,
 
           output        memwrite,
			  
			  output [31:0] pc, instr
			  
			  );



  wire [31:0]  readdata;


  
  // instantiate processor and memories


  mips mips(clk, reset, pc, instr, memwrite, dataadr, writedata, readdata,atomic);

  imem imem(pc[7:2], instr);

  dmem dmem(clk, memwrite, dataadr, writedata, readdata,atomic);



endmodule
