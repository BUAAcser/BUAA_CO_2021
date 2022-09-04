`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:20:40 11/28/2021 
// Design Name: 
// Module Name:    D_NPC 
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
module D_NPC(
    input [31:0] D_pc,
    input [31:0] F_pc,
    input [25:0] imm,
    input [31:0] FW_D_rs,
    input branch,
    input jump,
    input jr,
    input cmp_result,
	 input D_branch_link,
	 input Req,
	 input D_eret,
	 input [31:0]  EPC,
    output [31:0] npc
    );
	 
	 assign npc = (  Req == 1'b1) ? 32'h0000_4180 :
	              (  D_eret == 1'b1 )? EPC + 4 :
	              ( branch == 1'b1 && cmp_result == 1'b1 )? 	D_pc + 4+ {{14{imm[15]}},imm[15:0],{2{1'b0}}}:
	              ( jump == 1'b1 )? { D_pc[31:28],imm,{2{1'b0}}}:
					  (  jr == 1'b1 ) ?  FW_D_rs :
					  ( D_branch_link == 1'b1 && cmp_result == 1'b1 )?  D_pc + 4+ {{14{imm[15]}},imm[15:0],{2{1'b0}}}:                  
					                                                                                                    F_pc+4;
															
endmodule
