`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:44:48 11/28/2021 
// Design Name: 
// Module Name:    W_reg 
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
module W_reg(
    input clk,
    input reset,
    input [31:0] M_instr,
    input [31:0] M_dm,
    input [31:0] M_ALUresult,
    input [31:0] M_pc,
	 input  M_cmpresult,
    output reg [31:0] W_instr,
    output reg [31:0] W_dm,
    output reg [31:0] W_ALUresult,
    output reg [31:0] W_pc,
	 output reg  W_cmpresult
    );
    always@(posedge clk) begin
	     if ( reset == 1'b1) begin
		        W_instr <= 32'b0;
				  W_dm <= 32'b0;
				  W_ALUresult <= 32'b0;
				  W_pc <= 32'b0;
				  W_cmpresult <= 1'b0 ;
		  end
		  else begin
		        W_instr <= M_instr;
				  W_dm <=M_dm;
				  W_ALUresult <= M_ALUresult;
				  W_pc <= M_pc;
				  W_cmpresult <=  M_cmpresult;
		  end
	 end

endmodule
