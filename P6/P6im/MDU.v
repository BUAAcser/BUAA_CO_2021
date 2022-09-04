`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:54:15 12/12/2021 
// Design Name: 
// Module Name:    MDU 
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
module MDU(
    input clk,
    input reset,
    input [31:0] dataA,
    input [31:0] dataB,
    input [3:0] MDUtype,
	 output reg  busy,
    output start,
    output [31:0] dataout
    );
	 
	 wire mult =  ( MDUtype == 4'd1 )? 1 : 0;
	 wire multu = ( MDUtype == 4'd2 )? 1 : 0;
	 wire div =   ( MDUtype == 4'd3 )? 1 : 0;
	 wire divu =  ( MDUtype == 4'd4 )? 1 : 0;
	 wire mfhi =  ( MDUtype == 4'd5 )? 1 : 0;
	 wire mflo =  ( MDUtype == 4'd6 )? 1 : 0;
	 wire mthi =  ( MDUtype == 4'd7 )? 1 : 0;
	 wire mtlo =  ( MDUtype == 4'd8 )? 1 : 0;

	 reg [31:0] HI, LO;
	 reg [31:0 ] temp_hi, temp_lo;
	 reg [3:0] counter ;
	 
	 
	 assign start = mult | multu | div |divu ;

	 assign dataout = ( mfhi == 1'b1 ) ? HI :
	                  ( mflo == 1'b1 ) ? LO :
							                        32'b0;
	 

	 initial begin
	    counter <= 4'd0;
		 HI <= 32'd0;
		 LO <= 32'd0;
	 end
	 					                      
	 
	 always@( posedge clk ) begin
	      if ( reset == 1'b1 ) begin
			      busy <= 1'b0;
			      counter <= 4'd0;
		         HI <= 32'd0;
		         LO <= 32'd0;
			end
			else begin
			      if ( counter == 4'd0 ) begin
					      if ( mult == 1'b1 ) begin
							     busy <= 1'b1;
								  counter <= 4'd5;
								  { temp_hi ,temp_lo } <= $signed(dataA) * $signed(dataB);
							end
							else if ( multu == 1'b1 ) begin
							     busy <= 1'b1;
								  counter <= 4'd5;
								  { temp_hi ,temp_lo } <= dataA * dataB ;
							end
							else if ( div == 1'b1 ) begin
							    busy <= 1'b1;
								 counter <= 4'd10;
							    temp_lo <= $signed(dataA) / $signed(dataB);
								 temp_hi <= $signed(dataA) % $signed(dataB);
							end 
							else if ( divu == 1'b1 ) begin
							    busy <= 1'b1;
								 counter <= 4'd10;
							    temp_lo <= dataA / dataB;
								 temp_hi <= dataA % dataB;
							end
							else if ( mthi == 1'b1 ) begin
							     HI <= dataA ;
								  counter <= 4'd0;
							end
							else if ( mtlo == 1'b1 ) begin
							     LO <= dataA ;
								  counter <= 4'd0;
							end
					
					end
					else if  ( counter == 4'd1 ) begin
					           busy <= 1'b0;
								  counter <= 4'd0;
								  HI <= temp_hi;
								  LO <= temp_lo; 
					end
					else begin
					       counter <= counter -1 ;
					end
			end // else end
	 end // always end


endmodule
