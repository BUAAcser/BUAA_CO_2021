`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:47:18 11/28/2021 
// Design Name: 
// Module Name:    D_GRF 
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
module D_GRF(
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD,
    input en,
    input clk,
	 input reset,
	 input [31:0] W_pc,
    output [31:0] RD1,
    output [31:0] RD2
    );
	 
	 reg [31:0] grf [31:0];
	 
	 assign RD1 = (A1 == 0)? 32'b0: 
	              (A1 == A3 && en == 1'b1 )? WD:
					                                grf[A1];
	 assign RD2 = (A2 == 0)? 32'b0: 
	              (A2 == A3 && en == 1'b1 )? WD:
					                                grf[A2];
	 integer i;
	 initial begin
	     for (i=0;i<32;i=i+1) begin
		        grf[i] <= 32'd0;
		  end
	 end
	 always@(posedge clk) begin
	    if ( reset == 1'b1) begin
		     for (i=0;i<32;i=i+1) begin
			        grf[i] <= 32'd0;
			  end
		 
		 end
		 else begin
		     if ( en == 1'b1  ) begin
			       if ( A3 != 5'd0 ) begin
			            grf[A3] <= WD;
					 end 
			  end
		 end
	 
	 end
endmodule
