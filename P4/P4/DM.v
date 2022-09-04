`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:14:06 11/13/2021 
// Design Name: 
// Module Name:    DM 
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
module DM(
    input clk,
    input reset,
    input [31:0] WD,
    input [31:0] A,
    input  WE,
    input [31:0] pc,
	 output [31:0] RD
    );
    reg [31:0] memory [1023:0];
	 wire  [11:2]  addr ;
	 
	 assign addr = A[11:2];
	 assign RD = memory [addr];
	 
	 integer i;
	 initial begin
	    for(i=0;i<1024;i=i+1)
		      memory[i] <= 32'b0;
	 end
    always@(posedge clk) begin
	      if (reset == 1'b1) begin
			     for(i=0;i<1024;i=i+1) begin
				       memory[i] <= 32'b0;
				  end
			end
			else begin
			     if ( WE == 1'b1) begin
				       memory[addr] <= WD;
						 $display("@%h: *%h <= %h", pc, A, WD);
				  end
				  
			end
	 
	 end
endmodule
