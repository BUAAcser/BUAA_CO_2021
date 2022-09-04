`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:12:33 11/28/2021 
// Design Name: 
// Module Name:    D_CMP 
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
module D_CMP(
    input [31:0] rs,
    input [31:0] rt,
	 input [2:0] btype,
    output cmp_result
    );
	 
	 assign cmp_result = ( ( btype == 3'b001 &&  rs == rt ) || 
	                       ( btype == 3'b010 &&  rs != rt ) ||
	                       ( btype == 3'b011 &&  ( rs[31] == 1'b1 || rs == 32'b0) ) ||
	                       ( btype == 3'b100 &&  ( rs[31] == 1'b0 && rs != 32'b0) ) || 
								  ( btype == 3'b101 &&  ( rs[31] == 1'b1 && rs != 32'b0) ) || 
								  ( btype == 3'b110 &&  ( rs[31] == 1'b0 || rs == 32'b0) ) || 
	                       ( btype == 3'b111 && $signed(rs) < $signed(32'b0))           )? 1 : 0 ;
	 


endmodule
