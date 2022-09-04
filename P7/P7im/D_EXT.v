`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:58:17 11/28/2021 
// Design Name: 
// Module Name:    D_EXT 
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
module D_EXT(
    input [25:0] imm,
    input [1:0] EXT,
    output [31:0] D_imm
    );
	 
	 assign D_imm = ( EXT == 2'b00 )? {{16{imm[15]}},imm[15:0]}  :
	                ( EXT == 2'b01 )? {{16{1'b0}},imm[15:0]}  :
				       ( EXT == 2'b10 )? { imm[15:0],{16{1'b0}} } :
				                                                    D_imm ;
endmodule
