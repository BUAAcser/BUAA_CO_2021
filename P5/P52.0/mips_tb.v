`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:33:12 11/29/2021
// Design Name:   mips
// Module Name:   C:/Users/jinshenghao/P5CPU/mips_tb.v
// Project Name:  P5CPU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mips
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mips_tb;

	// Inputs
	reg clk;
	reg reset;

	// Instantiate the Unit Under Test (UUT)
	mips uut (
		.clk(clk), 
		.reset(reset)
	);

	initial begin
		reset = 1;
		clk = 0;
		# 10
		reset=0 ;
	end
	
	
    always  #5 clk = ~ clk ;
	 
	 
endmodule

