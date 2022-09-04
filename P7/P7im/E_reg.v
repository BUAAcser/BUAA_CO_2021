`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:29:26 11/28/2021 
// Design Name: 
// Module Name:    E_reg 
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
module E_reg(
    input clk,
    input reset,
    input [31:0] D_instr,
    input [31:0] D_rs,
    input [31:0] D_rt,
    input [31:0] D_IMM,
	 input [31:0] D_pc,
	 input  [4:0] D_EXCcode,
	 input D_BD,
	 input Req,
	 input [31:0] stall_D_pc,
	 input stall,
	 input  D_cmpresult,
	 
	 
    output reg [31:0] E_instr,
    output reg [31:0] E_rs,
    output reg [31:0] E_rt,
    output reg [31:0] E_IMM,
    output reg [31:0] E_pc,
	 output reg [4:0] E_EXCcode,
	 output reg E_BD,
	 
	 output reg E_cmpresult
	 
    );
	 always@(posedge clk) begin
	      if ( reset | Req ) begin
			     E_instr <= 32'b0;
				  E_rs <= 32'b0;
              E_rt <= 32'b0;
				  E_IMM <= 32'b0;
				  E_EXCcode <= 5'd0;
				  E_BD <=  stall? D_BD : 1'b0;
				  E_cmpresult <= 1'b0;
				  if (  Req == 1'b1 ) begin
				       E_pc <= 32'h0000_4180;
				  end
				  else if (  stall == 1'b1 ) begin
				       E_pc <= stall_D_pc;
				  end
				  else begin
				       E_pc <= 32'h0000_3000;
				  end
			end
			else begin
			     E_instr <=   D_instr;
				  E_rs <=  D_rs;
              E_rt <=  D_rt;
				  E_IMM <= D_IMM;
				  E_pc <=  D_pc;
				  E_EXCcode <= D_EXCcode ;
				  E_BD <= D_BD;
				  E_cmpresult <= D_cmpresult;
			end
	 end


endmodule
