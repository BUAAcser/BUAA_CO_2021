`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:58:11 11/28/2021 
// Design Name: 
// Module Name:    M_reg 
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
module M_reg(
    input clk,
	 input reset,
    input [31:0] E_instr,
    input [31:0] E_ALUresult,
    input [31:0] E_rt,
    input [31:0] E_pc,
	 input  E_cmpresult,
    output reg[31:0] M_instr,
    output reg [31:0] M_ALUresult,
    output reg [31:0] M_rt,
    output reg [31:0] M_pc,
	 output reg M_cmpresult
    );
	 always@(posedge clk) begin
	     if ( reset == 1'b1 ) begin
		       M_instr <= 32'b0;
				 M_ALUresult <= 32'b0;
				 M_rt <= 32'b0;
				 M_pc <= 32'b0;
				 M_cmpresult <= 1'b0;
		  end
		  else begin
		       M_instr <= E_instr;
				 M_ALUresult <= E_ALUresult   ;
				 M_rt <= E_rt ;
				 M_pc <= E_pc ;
		       M_cmpresult <= E_cmpresult;
		  end
	 end


endmodule
