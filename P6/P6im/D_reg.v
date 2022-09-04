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
	 output reg [31:0] D_instr,
	 output reg [31:0] D_pc
    );
	 always@(posedge clk) begin
	       if ( reset == 1'b1 ) begin
			       D_instr <= 32'b0;
					 D_pc <= 32'b0;
			 end
			 else begin
			       if ( en == 1'b1 ) begin
					       D_instr <= F_instr;
							 D_pc <= F_pc;
					 end
			 end
	 end


endmodule
