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
    output reg [31:0] E_instr,
    output reg [31:0] E_rs,
    output reg [31:0] E_rt,
    output reg [31:0] E_IMM,
    output reg [31:0] E_pc
    );
	 always@(posedge clk) begin
	      if ( reset == 1'b1) begin
			     E_instr <= 32'b0;
				  E_rs <= 32'b0;
              E_rt <= 32'b0;
				  E_IMM <= 32'b0;
				  E_pc <= 32'b0;
			end
			else begin
			     E_instr <=   D_instr;
				  E_rs <=  D_rs;
              E_rt <=  D_rt;
				  E_IMM <= D_IMM;
				  E_pc <=  D_pc;
			end
	 end


endmodule
