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
	 input D_cmpresult,
	 input E_cmpresult,
	 input M_cmpresult,	
	 input  HILO_busy,
    output  stall 
    );
	 
	 
	 wire [4:0] D_rs_addr , D_rt_addr;
	 wire  D_calc_r, D_calc_i, D_load, D_store, D_j_rs, D_shifts, D_shiftv, branch_link_D ;
	 wire  D_md, D_mf, D_mt;
	 wire  D_mtc0, D_eret;
	 wire [1:0] Tuse_rs , Tuse_rt;
	 wire  branch_t_s, branch_t_d;
	 
	 CU D_CU (
    .instr(D_instr), 
	 .cmp_result(D_cmpresult),
    .rs_addr(D_rs_addr), 
    .rt_addr(D_rt_addr),   
    .calc_r(D_calc_r), 
    .calc_i(D_calc_i), 
    .load(D_load), 
    .store(D_store),  
    .j_rs(D_j_rs),
	 .branch_link(branch_link_D),
	 .shifts( D_shifts ), 
    .shiftv( D_shiftv ),
	 .md(D_md), 
	 .mf(D_mf), 
    .mt(D_mt),
	 .branch_t_s(branch_t_s), 
    .branch_t_d(branch_t_d),
	 .eret(D_eret), 
    .mtc0(D_mtc0)
 
    );
	 
	 assign Tuse_rs = ( D_calc_r |  D_calc_i | D_load | D_store | D_shiftv | D_md | D_mt) ? 2'b01:
                     ( branch_t_d | branch_t_s | D_j_rs | branch_link_D)? 2'b00:
							                              2'b11;
    assign Tuse_rt = ( D_store | D_mtc0 )? 2'b10 ://  差点做错了， mtc0 的Tuse是2
                      ( D_calc_r | D_shifts | D_shiftv | D_md ) ? 2'b01:
                      branch_t_d? 2'b00 :
							                    2'b11;              // 课上的Branch_link指令rt tuse可能是0
														
									
	wire [4:0] E_A3, E_rd_addr;		
   wire E_calc_r , E_calc_i , E_load, E_lui, E_WE, E_shifts, E_shiftv ,E_mf, E_mfc0, E_mtc0;
	wire [1:0] Tnew_E;
	CU E_CU (
    .instr(E_instr), 
	 .rd_addr(E_rd_addr), 	
	 .cmp_result(E_cmpresult),
    .RFWE(E_WE),  
    .RFaddr(E_A3),
    .calc_r(E_calc_r), 
    .calc_i(E_calc_i), 
    .load(E_load), 
    .lui(E_lui),
	 .shifts( E_shifts ), 
    .shiftv( E_shiftv ),
	 .mf(E_mf),
	 .mtc0(E_mtc0), 
	 .mfc0(E_mfc0)
    );						
	 
	 assign Tnew_E =( E_load | E_mfc0 )? 2'b10:
	                ( E_calc_r | E_calc_i | E_lui | E_shifts | E_shiftv | E_mf ) ? 2'b01:
	                                                                                     2'b00;
																													 
																													 
	wire [4:0] M_A3, M_rd_addr;
   wire M_WE, M_load, M_mtc0;
   wire M_mfc0;	
		
	 CU  M_CU(
    .instr(M_instr), 
	  .rd_addr(M_rd_addr), 
	 .cmp_result(M_cmpresult),
    .RFWE(M_WE), 
    .RFaddr(M_A3), 
    .load(M_load),
	 .mtc0(M_mtc0), 
	 .mfc0(M_mfc0)
    );																		

    assign Tnew_M = ( M_load | M_mfc0 ) ? 2'b01:
	                                 2'b00;
												
   wire stall_rs_E ,stall_rs_M , stall_rt_E ,stall_rt_M, stall_erret;
	
	assign stall_rs_E = ( Tuse_rs < Tnew_E ) && ( D_rs_addr == E_A3 ) && ( E_A3 != 5'd0) && (E_WE == 1'b1);
   assign stall_rs_M = ( Tuse_rs < Tnew_M ) && ( D_rs_addr == M_A3 ) && ( M_A3 != 5'd0) && (M_WE == 1'b1);
	
	assign stall_rt_E = ( Tuse_rt < Tnew_E ) && ( D_rt_addr == E_A3 ) && ( E_A3 != 5'd0) && (E_WE == 1'b1);
   assign stall_rt_M = ( Tuse_rt < Tnew_M ) && ( D_rt_addr == M_A3 ) && ( M_A3 != 5'd0) && (M_WE == 1'b1);
	
	wire  stall_rs = stall_rs_E | stall_rs_M;
	wire  stall_rt = stall_rt_E | stall_rt_M;
	wire  stall_HILO = HILO_busy & ( D_md | D_mf | D_mt );
	
	wire  stall_eret = D_eret & (  ( E_mtc0 & ( E_rd_addr == 5'd14 ) ) || (  M_mtc0 & ( M_rd_addr == 5'd14) ) );
	
	assign stall = stall_rs | stall_rt |  stall_HILO | stall_eret  ;
	
endmodule
