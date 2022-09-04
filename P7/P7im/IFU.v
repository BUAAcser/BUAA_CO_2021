`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:09:57 11/28/2021 
// Design Name: 
// Module Name:    IFU 
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
module IFU(
    input en,
    input clk,
    input reset,
    input [31:0] npc,
	 input  D_eret,
	 input [31:0] EPC,
	 input Req,
    output [31:0] F_pc,
	 output F_AdEL
    );
	
	 reg [31:0] F_pc_Reg ; 

	 
	 assign F_pc = ( D_eret == 1'b1) ? EPC :F_pc_Reg ;
	  
	  
    assign F_AdEL = ( (  F_pc[1:0] != 2'b00 ) ||  F_pc < 32'h0000_3000 || F_pc > 32'h0000_6ffc )? 1:0;

	  
	 initial begin
	      F_pc_Reg <= 32'h0000_3000;
	 end
    always@(posedge clk) begin
	      if ( reset == 1'b1 ) begin
			      F_pc_Reg <= 32'h0000_3000;
			end
			else begin
			      if ( en | Req ) begin   //阻塞要服从于中断
					    F_pc_Reg <= npc;
					end
			end
	 end

endmodule
