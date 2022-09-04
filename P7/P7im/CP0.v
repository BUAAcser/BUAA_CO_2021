`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:14:56 12/19/2021 
// Design Name: 
// Module Name:    CP0 
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
module CP0(
    input [4:0] A1,
    input [4:0] A2,
    input [31:0] DIn,
    input [31:0] PC,
    input [6:2] ExcCodeIn,
    input [5:0] HWInt,
    input We,
    input EXLClr,
    input clk,
    input reset,
	 input BDin,
    output IntReq,
    output [31:0] EPCout,
    output [31:0] DOut,
	 output interrupt_respond
    );
	 
	 reg [31:0] SR, Cause,  PRId;
	 reg [31:0] EPCReg;
	 
    assign DOut = (  A1 == 5'd12 ) ? SR :
	               (  A1 == 5'd13 ) ? Cause :
						(  A1 == 5'd14 ) ? EPCout  :
						(  A1 == 5'd15 ) ? PRId :
	                                   32'b0;
								
	 assign interrupt_respond = 	HWInt[2] & SR[12] & IE & !EXL  ;
			
	 wire [7:2] IM;
	 wire IE, EXL;
	 
	 assign IM = SR[15:10];
	 assign IE = SR[0];
	 assign EXL = SR[1];
	 /////
	 
	 wire IReq , EReq;
	 assign IReq = |( HWInt & IM ) & IE & !EXL ;
	 assign Ereq = ( | ExcCodeIn  ) & !EXL;
	 
	 assign IntReq = IReq | Ereq;
	 assign EPCout = ( IntReq & BDin )? PC-4:
	                 ( IntReq & !BDin ) ? PC :
						                           EPCReg;
	 
	 
	 
	 initial begin
	       SR <=32'b0;
			 Cause <= 32'b0;
			 EPCReg <= 32'b0;
			 PRId <= 32'h1234_5678;
	 end
	 
	 always@(posedge clk) begin
	       if ( reset == 1'b1 ) begin
			      SR <=32'b0;
			      Cause <= 32'b0;
			      EPCReg <= 32'b0;
			      PRId <= 32'h1234_5678;
			 end
			 else begin
			     if ( IntReq == 1'b1 ) begin
				        SR[1] <= 1'b1;  // EXL  SR[1] 赋为1
						  Cause[31] <=  BDin;                // BD = BDin;
						  EPCReg  <= EPCout;
						  if ( IReq == 1'b1 ) begin
						       Cause[6:2] <= 5'd0 ; 
                    end
                    else begin
						       Cause[6:2] <= ExcCodeIn;
                    end						  									 //ExcCode = Cause[6:2];
				  end
				  else if ( We == 1'b1 ) begin //排除了中断写入的情况
				         if (  A2 == 5'd12 ) begin
							     SR <= DIn;
							end
							else if (  A2 == 5'd14 ) begin
							     EPCReg <= DIn ;
							end
							
				  end
				  
				  if ( EXLClr == 1'b1 ) begin
				       SR[1] <= 1'b0;
				  end     // EXLClr
				  
				  Cause[15:10] <= HWInt;
				  
			 end // else if end
			 
			 
	 end// alwasy end
	 
    
endmodule
