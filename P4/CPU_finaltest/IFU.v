`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:46:06 11/14/2021 
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
    input clk,
    input reset,
    input [31:0] npc,
    output  reg [31:0] pc,
    output [31:0] instr,
    output [5:0] op,
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [5:0] func,
    output [15:0] imm,
    output [25:0] index
    );
	 reg [31:0] im [1023:0];
	 wire [11:2] addr ;
	   
	 assign addr = pc [11:2];
	 assign instr = im [addr];
	 assign op = instr [31:26];
	 assign rs = instr [25:21];
	 assign rt = instr [20:16];
	 assign rd = instr [15:11];
	 assign func = instr [5:0];
	 assign imm = instr [15:0];
	 assign index = instr [25:0];
	 
	 initial begin
	         pc <= 32'h0000_3000;
	         $readmemh("code.txt",im);
	 end
	 always@(posedge clk) begin
	      if ( reset == 1'b1) begin
			     pc <= 32'h0000_3000;
			end
			else begin
			     pc <= npc;
			end
			
	 end

endmodule
