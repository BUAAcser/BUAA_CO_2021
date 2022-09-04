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
	 input [31:0] E_HILO,
	 input [4:0] E_EXCcode, //
	 input E_BD, //
	 input Req, //
	 input E_DMOV, //
	 input  E_cmpresult,
    output reg[31:0] M_instr,
    output reg [31:0] M_ALUresult,
    output reg [31:0] M_rt,
    output reg [31:0] M_pc,
	 output reg [31:0] M_HILO,
	 output reg [4:0] M_EXCcode, 
	 output reg  M_BD,  
	 output reg  M_DMOV, 
	 output reg M_cmpresult
    );
	 always@(posedge clk) begin
	     if (  reset | Req  ) begin
		       M_instr <= 32'b0;
				 M_ALUresult <= 32'b0;
				 M_rt <= 32'b0;
				 M_cmpresult <= 1'b0;  
				 M_HILO <= 32'b0;
				 M_EXCcode <= 5'd0;
				 M_BD <= 1'b0;
				 M_DMOV <= 1'b0;
				 M_pc <=  Req ? 32'h0000_4180 : 32'h0000_3000;
		  end
		  else begin
		       M_instr <= E_instr;
				 M_ALUresult <= E_ALUresult   ;
				 M_rt <= E_rt ;
				 M_pc <= E_pc ;
		       M_cmpresult <= E_cmpresult;
				 M_HILO <= E_HILO;
				 M_EXCcode <= E_EXCcode;
				 M_BD <= E_BD;
				 M_DMOV <= E_DMOV ;
				 
		  end
	 end


endmodule
