`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:09:31 11/28/2021 
// Design Name: 
// Module Name:    M_DM 
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
module M_DM(
    input clk,
	 input reset,
	 input en,
	 input [31:0] M_pc,
    input [31:0] A,
    input [31:0] WD,
    output [31:0] RD
    );
	 reg [31:0] dm [3071:0];
	 
	 wire [13:2] addr = A [13:2];
	 assign RD = dm [addr];
	 integer i;
	 initial begin
	     for(i=0;i<3072;i=i+1) begin
				       dm[i] <= 32'b0;
		  end
	 end
	 always@(posedge clk) begin
	      if ( reset == 1'b1 ) begin
			     for(i=0;i<3072;i=i+1) begin
				       dm[i] <= 32'b0;
				  end
			end
			else begin
			     if ( en == 1'b1) begin
                   dm[addr] <= WD;
                   $display("%d@%h: *%h <= %h", $time, M_pc, A, WD);				       
				  end
			end
	    
	 end
	 


endmodule
