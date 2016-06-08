`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:47:36 11/09/2015 
// Design Name: 
// Module Name:    topoverall 
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
//////////////////////////////////////////////////////////////////////////////////
module topoverall(input         clk, reset,push,
						output[0:3] anot,
						output[6:0] katot,
						output dot,memwrite
 
);

				wire [31:0] writedata, dataadr, pc, instr;
				
				wire clk_pulse;
				
				top t0(clk_pulse, reset,writedata, dataadr,memwrite, pc, instr);
				
				display_controller d0(clk, reset,4'b1111,writedata[3:0],writedata[7:4],dataadr[3:0],dataadr[7:4],anot,katot,dot);
				
				pulse_controller p0(clk,push,reset,clk_pulse );
endmodule