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
	 input Req,
    input [31:0] M_instr,
    input [31:0] M_dm,
    input [31:0] M_ALUresult,
    input [31:0] M_pc,
	 input [31:0] M_HILO,
	 input [31:0] M_CP0,
	 input  M_cmpresult,
    output reg [31:0] W_instr,
    output reg [31:0] W_dm,
    output reg [31:0] W_ALUresult,
    output reg [31:0] W_pc,
	 output reg [31:0] W_HILO,
	 output reg [31:0] W_CP0,
	 output reg  W_cmpresult
    );
    always@(posedge clk) begin
	     if ( reset | Req ) begin
		        W_instr <= 32'b0;
				  W_dm <= 32'b0;
				  W_ALUresult <= 32'b0;
				  W_cmpresult <= 1'b0 ;
				  W_HILO <= 32'b0;
				  W_CP0 <= 32'b0;
				  W_pc <= Req? 32'h0000_4180 : 32'h0000_3000 ;
		  end
		  else begin
		        W_instr <= M_instr;
				  W_dm <=M_dm;
				  W_ALUresult <= M_ALUresult;
				  W_pc <= M_pc;
				  W_cmpresult <=  M_cmpresult;
				  W_HILO <= M_HILO;
				  W_CP0 <= M_CP0;
		  end
	 end

endmodule
