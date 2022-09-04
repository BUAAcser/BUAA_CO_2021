`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:39:32 11/28/2021 
// Design Name: 
// Module Name:    E_ALU 
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
module E_ALU(
    input [31:0] dataA,
    input [31:0] dataB,
    input [3:0] ALUctrl,
	 input  ALUcalcROV, 
    input  ALUDMOV,
    output reg [31:0] result,
	 output   E_calcROV,
	 output   E_DMOV
    );
	 wire  [32:0] tempA, tempB;
	 wire  [32:0] addresult, subresult;
	 
	 
	 always@(*) begin
	     case(ALUctrl)
		        4'b0000:begin
		             result = dataA & dataB;
		        end
		        4'b0001: begin
		             result = dataA | dataB;
		        end
		        4'b0010: begin
		             result = dataA + dataB;
		        end
		        4'b0011: begin
		             result = dataA - dataB;
		        end
		        4'b0100: begin
		             result = dataA ^ dataB;
		        end
				  4'b0101: begin
				       result = dataA << dataB;
				  end
				  4'b0110: begin
				       result = dataA >> dataB;
				  end
				  4'b0111: begin
				       result = $signed($signed(dataA) >>> dataB);
				  end
				  4'b1000: begin
				       result =  ~( dataA | dataB );
				  end
				  4'b1001: begin
				       result = ( $signed(dataA) < $signed(dataB) )? 32'd1 : 32'd0;
				  end
				  4'b1010: begin
				       result =  ( dataA < dataB )? 32'd1 : 32'd0;
				  end
		        default: begin
		             result = result;
		        end
		  endcase  
	 end
	  
		 assign  tempA = { dataA[31], dataA };
		 assign  tempB = { dataB[31], dataB };
		 assign  addresult = tempA + tempB;
		 assign  subresult = tempA - tempB;
		  
		 assign  E_calcROV = ( (  ALUcalcROV == 1'b1 &&  ALUctrl == 4'b0010 && addresult[32] !=  addresult[31] ) 
		              || (  ALUcalcROV == 1'b1 &&  ALUctrl == 4'b0011 && subresult[32] !=  subresult[31] ) )? 1 : 0;

       assign  E_DMOV = ( (  ALUDMOV == 1'b1 &&  ALUctrl == 4'b0010 && addresult[32] !=  addresult[31] ) 
		                || (  ALUDMOV == 1'b1 &&  ALUctrl == 4'b0011 && subresult[32] !=  subresult[31] ) ) ? 1 : 0;


	 
endmodule
