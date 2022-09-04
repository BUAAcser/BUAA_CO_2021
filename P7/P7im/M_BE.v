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
	 input [31:0] A ,
	 input M_DMOV,
	 input load,
	 input store,
	 input [2:0] EXTop,
	 input Req,
    output reg [3:0] BE,
    output reg [31:0] outdata,
	 output M_AdEL,
	 output M_AdES
    
    );
	 
	 wire lwAlign;
	 wire lhAligh;
	 wire lhlbTimer;
	 wire loadOV;
	 wire loadOutofrange;
	 
	 wire swAlign;
	 wire shAligh;
	 wire shsbTimer;
	 wire storeOV;
	 wire storeOutofrange;
	 wire storeCounter;

    always@(*) begin
	 
	      if ( s_type == 2'b00 || Req == 1'b1 ) begin
			        BE = 4'b0000;
					  outdata = indata;
			end
	      else if ( s_type == 2'b01 ) begin
			        BE = 4'b1111;
				     outdata =  indata;
         end  // 01 end
         else if ( s_type == 2'b10 ) begin
			    if ( A[1] == 1'b0 ) begin
				       BE = 4'b0011;
						 outdata = { {16{1'b0}}, indata[15:0]}	;	 
				 end
				 else if ( A[1] == 1'b1 ) begin
				       BE = 4'b1100;
						 outdata = { indata[15:0],{16{1'b0}} }	;	
				 end
         end // 10 end
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
			end // 11 end
			
	 end
	 
	 wire HitTimer ,HitCounter;
	 wire NotHit;
	
	assign HitTimer  =  ( ( A >= 32'h0000_7F00 && A <= 32'h0000_7F0B ) ||
                      	( A >= 32'h0000_7F10 && A <= 32'h0000_7F1B ) ) ? 1:0;
	
	assign HitCounter = ( ( A >= 32'h0000_7F08 && A <= 32'h0000_7F0B ) ||
                      	( A >= 32'h0000_7F18 && A <= 32'h0000_7F1B ) ) ? 1:0;
								
	assign  NotHit = !( 	(  A >= 32'h0000_0000 && A <= 32'h0000_2FFF ) ||  HitTimer  );
                      						
	 
	assign lwAlign = ( load == 1'b1 && EXTop == 3'b000 &&  A[1:0] != 2'b00 )? 1:0;
   assign lhAligh = ( ( EXTop == 3'b011 || EXTop == 3'b100 ) && A[0] != 1'b0 )? 1:0;
   assign lhlbTimer = ( ( EXTop == 3'b011 || EXTop == 3'b100 || EXTop == 3'b001 || EXTop == 3'b010  ) && HitTimer ) ? 1:0;
	assign loadOV = ( load & M_DMOV )? 1:0;
	assign  loadOutofrange = ( load & NotHit ) ?  1:0;
	
	assign swAlign  = ( s_type == 2'b01 &&  A[1:0] != 2'b00 ) ? 1:0;
	assign shAligh  = ( s_type == 2'b10 &&  A[0] != 1'b0 )? 1:0;
	assign shsbTimer =  ( ( s_type == 2'b10 ||  s_type == 2'b11 ) && HitTimer )? 1:0;
	assign storeOV = ( store & M_DMOV ) ? 1:0;
	assign storeOutofrange = ( store &  NotHit )? 1:0;
	assign storeCounter = ( store & HitCounter )? 1:0;
	
	assign  M_AdEL = lwAlign | lhAligh | lhlbTimer | loadOV | loadOutofrange;
	 
	assign  M_AdES = swAlign | shAligh | shsbTimer | storeOV | storeOutofrange | storeCounter;
	
endmodule
