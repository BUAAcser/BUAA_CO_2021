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
	 input [1:0] DM_mode, // DM_mode==00 sw  DM_Mode == 01 sb    DM_mode == 10 sh  
	 output [31:0] RD
    );
    reg [31:0] memory [1023:0];
	 wire  [11:2]  addr ;
	 reg   [31:0]  trueout;
	 wire  [31:0]  preRD;
    assign preRD = memory [addr]	 ;
	 assign addr = A[11:2];
	 assign RD = (DM_mode == 2'b00)? memory [addr]:      //ÐèÒªÐÞÕý
	             (DM_mode == 2'b01 && A[1:0]==2'b00)? {{24{preRD[7]}},preRD[7:0]}:
	             (DM_mode == 2'b01 && A[1:0]==2'b01)? {{24{preRD[15]}},preRD[15:8]}:
					 (DM_mode == 2'b01 && A[1:0]==2'b10)? {{24{preRD[23]}},preRD[23:16]}:
					 (DM_mode == 2'b01 && A[1:0]==2'b11)? {{24{preRD[31]}},preRD[31:24]}:
					 (DM_mode == 2'b10 && A[1] == 1'b0)? {{16{preRD[15]}},preRD[15:0]}:
					 (DM_mode == 2'b10 && A[1] == 1'b1)? {{16{preRD[31]}},preRD[31:16]}
					                                                                  : RD;
	 integer i;
	 initial begin
	    for(i=0;i<1024;i=i+1)
		      memory[i] <= 32'b0;
	 end
    always@(posedge clk) begin
	      trueout = memory [addr];
	      if (reset == 1'b1) begin
			     for(i=0;i<1024;i=i+1) begin
				       memory[i] <= 32'b0;
				  end
			end
			else begin
			     if ( WE == 1'b1) begin
				       if (DM_mode == 2'b00) begin
						      memory[addr] <= WD;
				            $display("@%h: *%h <= %h", pc, A, WD);
						 end
						 else if (DM_mode == 2'b01) begin
						      if ( A[1:0] == 2'b00 ) begin
								     trueout = {trueout[31:8],WD[7:0]};
								end
								else if ( A[1:0] == 2'b01) begin
								     trueout = {trueout[31:16],WD[7:0],trueout[7:0]};
								end
								else if ( A[1:0] == 2'b10) begin
								     trueout = {trueout[31:24],WD[7:0],trueout[15:0]};
								end
								else if ( A[1:0] == 2'b11) begin
								     trueout = {WD[7:0],trueout[23:0]};
								end
								memory[addr] <= trueout;
								$display("@%h: *%h <= %h", pc, A, trueout);
						 end
						 else if ( DM_mode == 2'b10 ) begin
						      if ( A[1]==1'b0) begin
								    trueout = {trueout[31:16],WD[15:0]};
								end
								else if (A[1] == 1'b1) begin
								    trueout =  {WD[15:0],trueout[15:0]};
								end
								memory[addr] <= trueout;
								$display("@%h: *%h <= %h", pc, A, trueout);
						 end
				  end//if we == 1
				  
			end // else end
	 
	 end// always end
endmodule
