`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:48:02 11/13/2021 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [31:0] dataA,
    input [31:0] dataB,
    input [2:0] ALUctrl,
    output reg [31:0] result,
    output reg ALUzero,
	 output reg ifgtz
    );
	 always@(*) begin
	     case(ALUctrl)
		  3'b000:begin
		         result = dataA & dataB;
		  end
		  3'b001: begin
		         result = dataA | dataB;
		  end
		  3'b010: begin
		         result = dataA + dataB;
		  end
		  3'b011: begin
		        result =  dataA - dataB ;
		  end
		  3'b100: begin
		        result =  dataA ^ dataB;
		  end
		  3'b101: begin
		        result = dataB << dataA;
		  end
		  default: begin
		          result = result;
		  end
		  endcase
		  ALUzero = (result == 32'b0)?1:0;
		  ifgtz = (dataA > 0)?1:0;
	 end
	 
endmodule
