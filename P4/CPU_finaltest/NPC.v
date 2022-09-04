`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:29:53 11/14/2021 
// Design Name: 
// Module Name:    NPC 
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
module NPC(
    input [31:0] pc,
    input [15:0] imm,
    input [25:0] index,
    input [31:0] RD1,
    input branch,
    input ALUzero,
    input jump, // jal and j instruction
    input jr,
	 input ifgtz,
	 input bgtz,
    output reg [31:0] npc
    );
	 
	 always@(*) begin
	       if ( jr == 1'b1 ) begin
			       npc = RD1;
			 end
			 else if ( jump == 1'b1 ) begin
			       npc = {pc[31:28], index , {2{1'b0}}};
			 end
			 else if ( (branch == 1'b1 && ALUzero == 1'b1)||(bgtz == 1'b1 && ifgtz == 1'b1)) begin
			       npc = pc + 4 + {{14{imm[15]}} , imm , 2'b00};
			 end
			 else begin
			       npc = pc +4 ;
			 end
	 end
	

endmodule
