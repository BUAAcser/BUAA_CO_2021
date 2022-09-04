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
    input [2:0] ALUctrl,
    output reg [31:0] result
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
		             result = dataA - dataB ;
		        end
		        3'b100: begin
		             result = dataA ^ dataB;
		        end
		        default: begin
		             result = result;
		        end
		  endcase
	 end
endmodule
