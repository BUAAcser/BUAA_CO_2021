`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:00:51 11/28/2021 
// Design Name: 
// Module Name:    D_reg 
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
module D_reg(
    input [31:0] F_instr,
    input [31:0] F_pc,
    input en,
    input clk,
    input reset,
	 input F_BD,
	 input [4:0] F_EXCcode,
	 input Req,
	 output reg [31:0] D_instr,
	 output reg [31:0] D_pc,
	 output reg D_BD ,
	 output reg [4:0] D_EXCcode
    );
	 always@(posedge clk) begin
	       if ( reset | Req ) begin
			       D_instr <= 32'b0;
					 D_BD <= 1'b0;
					 D_EXCcode <= 5'd0;
					 D_pc <=  Req? 32'h0000_4180 : 32'h0000_30000;
			 end
			 else begin
			       if ( en == 1'b1 ) begin
					       D_instr <= F_instr;
							 D_pc <= F_pc;
							 D_EXCcode <= F_EXCcode;
							 D_BD <= F_BD;
					 end
			 end
	 end


endmodule
