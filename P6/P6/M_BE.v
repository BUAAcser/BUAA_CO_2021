`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:29:49 12/12/2021 
// Design Name: 
// Module Name:    M_BE 
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
module M_BE(
    input [31:0] indata,
    input [1:0] s_type,
	 input [31:0] A,
    output reg [3:0] BE,
    output reg [31:0] outdata
    
    );

    always@(*) begin
	      if ( s_type == 2'b01 ) begin
			     BE = 4'b1111;
				  outdata =  indata;
         end
         else if ( s_type == 2'b10 ) begin
			    if ( A[1] == 1'b0 ) begin
				       BE = 4'b0011;
						 outdata = { {16{1'b0}}, indata[15:0]}	;	 
				 end
				 else if ( A[1] == 1'b1 ) begin
				       BE = 4'b1100;
						 outdata = { indata[15:0],{16{1'b0}} }	;	
				 end
         end
         else if ( s_type == 2'b11 ) begin
			     if ( A[1:0] == 2'b00 ) begin
				       BE = 4'b0001;
						 outdata = { {24{1'b0}}, indata[7:0] };	
				  end
				  else if ( A[1:0] == 2'b01 ) begin
				       BE = 4'b0010;
						 outdata = { {16{1'b0}}, indata[7:0], {8{1'b0}} };	
				  end
				  else if ( A[1:0] == 2'b10 ) begin
				       BE = 4'b0100;
						 outdata = { {8{1'b0}}, indata[7:0], {16{1'b0}} };	
				  end
				  else if ( A[1:0] == 2'b11 ) begin
				       BE = 4'b1000;
						 outdata = { indata[7:0], {24{1'b0}} };	 
				  end
			end
			else if ( s_type == 2'b00 ) begin
			        BE = 4'b0000;
					  outdata = indata;
			end

	 end

endmodule
