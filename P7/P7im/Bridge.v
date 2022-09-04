`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:36:43 12/19/2021 
// Design Name: 
// Module Name:    Bridge 
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
module Bridge(
    input [31:0] PrAddr,
    input [31:0] PrWD,
    input PrWE,
    input [3:0] Prbeen,
    input [31:0] m_data_rdata,
    input [31:0] TC0out,
    input [31:0] TC1out,
	 input interrupt_respond,
	 output [31:0] PrRD,
    output [3:0]  m_data_byteen,
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output TC0WE,
    output TC1WE,
	 output [31:0] TC0Addr,
	 output [31:0] TC0WD,
	 output [31:0] TC1Addr,
	 output [31:0] TC1WD
    );
	 wire  HitTC0,HitTC1 ,HitDM;
	 
	 assign  HitDM   =  ( PrAddr >= 32'h0000_0000  && PrAddr <= 32'h0000_2FFF )? 1:0;
	 assign  HitTC0   = ( PrAddr >= 32'h0000_7F00  && PrAddr <= 32'h0000_7F0B )? 1:0; //0x0000_7F10 жа 0x0000_7F1B	
	 assign  HitTC1   = ( PrAddr >= 32'h0000_7F10  && PrAddr <= 32'h0000_7F1B )? 1:0;  
	 
	 
	 assign  TC0WE =  HitTC0 & PrWE;
	 assign  TC1WE =  HitTC1 & PrWE;
	 
	 assign m_data_byteen = interrupt_respond ? 4'b1111:
                            HitDM ? Prbeen:
	                                       4'b0000;
	                          
    assign m_data_addr = interrupt_respond ?  32'h0000_7f20:
	                                                         PrAddr; 
																				
    assign m_data_wdata = PrWD;
	 assign TC0WD = PrWD;
	 assign TC0Addr = PrAddr;
	 assign TC1WD = PrWD;
	 assign TC1Addr = PrAddr;
	 
	 assign PrRD = HitDM  ?  m_data_rdata: 
	               HitTC0 ?   TC0out :
                  HitTC1 ?   TC1out :
						                    32'b0;
	 
endmodule
