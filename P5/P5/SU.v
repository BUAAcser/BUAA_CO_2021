`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:36:42 11/28/2021 
// Design Name: 
// Module Name:    SU 
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
module SU(
    input [31:0] D_instr,
    input [31:0] E_instr,
    input [31:0] M_instr,
    input [31:0] W_instr,
    output  stall 
    );
	 
	 
	 wire [4:0] D_rs_addr , D_rt_addr;
	 wire D_branch , D_calc_r, D_calc_i, D_load, D_store, D_j_rs;
	 wire [1:0] Tuse_rs , Tuse_rt;
	 
	 CU D_CU (
    .instr(D_instr), 
    .rs_addr(D_rs_addr), 
    .rt_addr(D_rt_addr), 
    .branch(D_branch),  
    .calc_r(D_calc_r), 
    .calc_i(D_calc_i), 
    .load(D_load), 
    .store(D_store),  
    .j_rs(D_j_rs)
    );
	 
	 assign Tuse_rs = ( D_calc_r | D_calc_i | D_load | D_store ) ? 2'b01:
                     ( D_branch | D_j_rs )? 2'b00:
							                              2'b11;
    assign Tuse_rt =  D_store ? 2'b10 :
                      D_calc_r  ? 2'b01:
                      D_branch ? 2'b00 :
                                          2'b11;
														
									
	wire [4:0] E_A3;		
   wire E_calc_r , E_calc_i , E_load, E_lui, E_WE;
	wire [1:0] Tnew_E;
	CU E_CU (
    .instr(E_instr), 
    .RFWE(E_WE),  
    .RFaddr(E_A3), 
    .calc_r(E_calc_r), 
    .calc_i(E_calc_i), 
    .load(E_load), 
    .lui(E_lui)
    );						
	 
	 assign Tnew_E = E_load? 2'b10:
	                ( E_calc_r | E_calc_i | E_lui ) ? 2'b01:
						                                          2'b00;
	wire [4:0] M_A3;
   wire M_WE, M_load;	
		
	 CU  M_CU(
    .instr(M_instr), 
    .RFWE(M_WE), 
    .RFaddr(M_A3), 
    .load(M_load)
    );																		

    assign Tnew_M = M_load ? 2'b01:
	                                 2'b00;
												
   wire stall_rs_E ,stall_rs_M , stall_rt_E ,stall_rt_M;
	assign stall_rs_E = ( Tuse_rs < Tnew_E ) && ( D_rs_addr == E_A3 ) && ( E_A3 != 5'd0) && (E_WE == 1'b1);
   assign stall_rs_M = ( Tuse_rs < Tnew_M ) && ( D_rs_addr == M_A3 ) && ( M_A3 != 5'd0) && (M_WE == 1'b1);
	
	assign stall_rt_E = ( Tuse_rt < Tnew_E ) && ( D_rt_addr == E_A3 ) && ( E_A3 != 5'd0) && (E_WE == 1'b1);
   assign stall_rt_M = ( Tuse_rt < Tnew_M ) && ( D_rt_addr == M_A3 ) && ( M_A3 != 5'd0) && (M_WE == 1'b1);
	
	wire  stall_rs = stall_rs_E | stall_rs_M;
	wire  stall_rt = stall_rt_E | stall_rt_M;
	
	assign stall = stall_rs | stall_rt;
	
endmodule
