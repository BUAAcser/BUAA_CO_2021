`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:48:02 11/13/2021 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [31:0] dataA,
    input [31:0] dataB,
    input [2:0] ALUctrl,
    output [31:0] result,
    output ALUzero
    );
	 
	 assign result = ( ALUctrl == 3'b000 ) ? dataA & dataB :
	                 ( ALUctrl == 3'b001 ) ? dataA | dataB :
						  ( ALUctrl == 3'b010 ) ? dataA + dataB :
						  ( ALUctrl == 3'b011 ) ? dataA - dataB :
						  ( ALUctrl == 3'b100 ) ? dataA ^ dataB :
						                                           result        ;
    assign ALUzero = (result == 32'b0)? 1:0;

endmodule
