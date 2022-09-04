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
    output [31:0] F_instr,
    output reg  [31:0] F_pc
    );
	 
 
	 reg [31:0] im [4095:0];
	 
	 
	 assign F_instr = im [ F_pc [15:2] - 13'hC00];
	 
	 initial begin
	      F_pc <= 32'h0000_3000;
			$readmemh("code.txt",im);
	 end
    always@(posedge clk) begin
	      if ( reset == 1'b1 ) begin
			      F_pc <= 32'h0000_3000;
			end
			else begin
			      if ( en == 1'b1 ) begin
					    F_pc <= npc;
					end
			end
	 end

endmodule
