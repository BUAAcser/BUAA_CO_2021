`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:56:34 11/28/2021 
// Design Name: 
// Module Name:    mips 
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

module mips(
    input clk,
	 input reset
    );
	 
	 wire [31:0] F_instr, D_instr, E_instr, M_instr, W_instr;
	 wire [31:0] npc, D_pc, E_pc, W_pc, M_pc;
	 wire [31:0] F_pc;
	 
	 // D级连线
	 wire [4:0] D_rs ,D_rt;
	 wire [25:0] imm;
	 wire [1:0] EXT;
	 wire branch ,jrtype,jump;
	 wire [31:0] D_imm;
	 wire [31:0] RD1, RD2; 
	 wire  cmp_result;
	 
	 // E级连线
	 wire [31:0] E_rs, E_rt;
	 wire [31:0] E_imm;
	 wire [4:0] E_rs_addr, E_rt_addr;
    wire [4:0] RFaddr_E;
	 wire [1:0] RFWDtype_E;
	 wire  RFWR_E;
	 wire [31:0] E_WD;
	 wire [2:0] E_AlUctrl;
	 wire E_ALUsrc;
	 wire [31:0] E_ALUresult;
	 
	 //M级连线
	 wire [31:0] M_rt ;
	 wire [31:0] M_ALUresult;
	 wire [4:0] M_rt_addr;
	 wire [4:0] RFaddr_M; 
	 wire [1:0] RFWDtype_M;
	 wire  RFWR_M;
	 wire [31:0] M_WD;
	 wire DM_WE;
	 wire [31:0] M_dm ;
	 
	 // W级连线
	 wire [4:0] RFaddr_W;
	 wire [1:0] RFWDtype_W;
	 wire  RFWR_W;
	 wire [31:0] W_WD;
	 wire [31:0] W_ALUresult;
	 wire [31:0] W_dm;
	 

	 wire stall;
	 
	 
	 
	 
	 SU main_su (
    .D_instr(D_instr), 
    .E_instr(E_instr), 
    .M_instr(M_instr), 
    .W_instr(W_instr), 
    .stall(stall)
    );
	 
	 wire pc_en = !stall;
	 wire Dreg_en = !stall;
	 wire E_reset = stall;
	 
	 
	 IFU main_IFU (
    .en(pc_en),
    .clk(clk), 
    .reset(reset), 
    .npc(npc), 
    .F_instr(F_instr), 
    .F_pc(F_pc)
    );
	 
	 D_reg main_D_reg (
    .F_instr(F_instr), 
    .F_pc(F_pc), 
    .en(Dreg_en), 
    .clk(clk), 
    .reset(reset), 
    .D_instr(D_instr), 
    .D_pc(D_pc)
    );
	 
	
	 wire [31:0] FW_rs_D = ( D_rs == 5'd0 )? 5'd0:
	                       ( D_rs == RFaddr_E &&  RFWR_E == 1'b1 )?  E_WD:
	                       ( D_rs == RFaddr_M &&  RFWR_M == 1'b1 )?  M_WD:
	                       ( D_rs == RFaddr_W &&  RFWR_W == 1'b1 )?  W_WD: 
								                                                  RD1;
	 wire [31:0] FW_rt_D = ( D_rt == 5'd0 )? 5'd0:
	                       ( D_rt == RFaddr_E &&  RFWR_E == 1'b1 )?  E_WD:
	                       ( D_rt == RFaddr_M &&  RFWR_M == 1'b1 )?  M_WD:
	                       ( D_rt == RFaddr_W &&  RFWR_W == 1'b1 )?  W_WD: 
								                                                  RD2;
    
	 
     CU ID_CU (
    .instr(D_instr), 
    .rs_addr(D_rs), 
    .rt_addr(D_rt), 
    .imm(imm), 
    .EXT(EXT), 
    .branch(branch), 
    .jump(jump), 
    .jrtype(jrtype)
    ); // ID_CU端口设置完成

    D_NPC mian_DNPC (
    .D_pc(D_pc), 
    .F_pc(F_pc), 
    .imm(imm), 
    .FW_D_rs(FW_rs_D), 
    .branch(branch), 
    .jump(jump), 
    .jr(jrtype), 
    .cmp_result(cmp_result), 
    .npc(npc)
    );
	 // NPC端口设置完成
	 D_EXT instance_name (
    .imm(imm), 
    .EXT(EXT), 
    .D_imm(D_imm)
    ); //EXT 端口设置完成
	 
	
	 
	 D_GRF main_DGRF (
    .A1(D_rs), 
    .A2(D_rt), 
    .A3(RFaddr_W), 
    .WD(W_WD), 
    .en(RFWR_W), 
    .clk(clk), 
    .reset(reset), 
    .W_pc(W_pc), 
    .RD1(RD1), 
    .RD2(RD2)
    );// GRF 端口设置完成
	 
	 D_CMP main_DCMP (
    .rs(FW_rs_D), 
    .rt(FW_rt_D), 
    .cmp_result(cmp_result)
    );  // CMP端口设置完成

	 
	 
	 
	 E_reg main_Ereg (
    .clk(clk), 
    .reset(reset || E_reset), 
    .D_instr(D_instr), 
    .D_rs(FW_rs_D), 
    .D_rt(FW_rt_D), 
    .D_IMM(D_imm), 
    .D_pc(D_pc), 
    .E_instr(E_instr), 
    .E_rs(E_rs), 
    .E_rt(E_rt), 
    .E_IMM(E_imm), 
    .E_pc(E_pc)
    );   //E reg端口设置完成
	
	 
	 assign E_WD =( RFWDtype_E == 2'b10 )? E_pc+8:
						                               32'b0;
	 CU main_EXCU (
    .instr(E_instr), 
	 .rs_addr(E_rs_addr), 
    .rt_addr(E_rt_addr), 
    .ALUSrc(E_ALUsrc), 
    .RFWE(RFWR_E), 
    .ALUctrl(E_AlUctrl), 
    .RFWD_Type(RFWDtype_E), 
    .RFaddr( RFaddr_E) 
    );		 //  E级CU端口应该设置完成了吧													 
																 																											 
	 wire [31:0] FW_rs_E = ( E_rs_addr == 5'd0 )? 5'd0:
	                       ( E_rs_addr == RFaddr_M &&  RFWR_M == 1'b1 )?  M_WD:
	                       ( E_rs_addr == RFaddr_W &&  RFWR_W == 1'b1 )?  W_WD: 
								                                                  E_rs;
	 wire [31:0] FW_rt_E = ( E_rt_addr == 5'd0 )? 5'd0:            
	                       ( E_rt_addr == RFaddr_M &&  RFWR_M == 1'b1 )?  M_WD:
	                       ( E_rt_addr == RFaddr_W &&  RFWR_W == 1'b1 )?  W_WD: 
								                                                  E_rt;

	 wire [31:0] E_dataB = ( E_ALUsrc == 1'b1 )? E_imm :
	                                                    FW_rt_E; 
	
	 
	 E_ALU main_EALU (
    .dataA(FW_rs_E), 
    .dataB(E_dataB), 
    .ALUctrl(E_AlUctrl), 
    .result(E_ALUresult)
    ); // E_ALU端口设置完成
	 

    
	 
	 M_reg main_Mreg (
    .clk(clk), 
    .reset(reset), 
    .E_instr(E_instr), 
    .E_ALUresult(E_ALUresult), 
    .E_rt(FW_rt_E), 
    .E_pc(E_pc), 
    .M_instr(M_instr), 
    .M_ALUresult(M_ALUresult), 
    .M_rt(M_rt), 
    .M_pc(M_pc)
    );
	 
	 
	 
	 assign M_WD = ( RFWDtype_M == 2'b00 )? M_ALUresult:
	               ( RFWDtype_M == 2'b10 )? M_pc+8:
						                               32'b0;
																 
	
	 
	  CU main_DMCU (
    .instr(M_instr), 
    .rt_addr(M_rt_addr), 
    .RFWE(RFWR_M), 
    .DM_WE(DM_WE), 
    .RFWD_Type(RFWDtype_M), 
    .RFaddr(RFaddr_M)
    ); /// M_级差不多改好了
	 
	 wire [31:0] FW_rt_M = ( M_rt_addr == 5'd0 )? 5'd0:            
	                       ( M_rt_addr == RFaddr_W &&  RFWR_W == 1'b1 )?  W_WD: 
								                                                       M_rt; 
	 
	 
	 
	 M_DM main_MDM (
    .clk(clk), 
    .reset(reset), 
    .en(DM_WE), 
    .M_pc(M_pc), 
    .A(M_ALUresult), 
    .WD(FW_rt_M), 
    .RD(M_dm)
    );    //dm端口设置完成
	 
	 W_reg main_W_reg (
    .clk(clk), 
    .reset(reset), 
    .M_instr(M_instr), 
    .M_dm(M_dm), 
    .M_ALUresult(M_ALUresult), 
    .M_pc(M_pc), 
    .W_instr(W_instr), 
    .W_dm(W_dm), 
    .W_ALUresult(W_ALUresult), 
    .W_pc(W_pc)
    ); // w级reg端口设置完成
	 
	 
	 assign W_WD = ( RFWDtype_W == 2'b00 )? W_ALUresult:
	               ( RFWDtype_W == 2'b10 )? W_pc+8:
						( RFWDtype_W == 2'b01 )? W_dm:                          
						                              32'b0;	 	
  
	  CU main_WBCU (
    .instr(W_instr), 
    .RFWE(RFWR_W), 
    .RFWD_Type(RFWDtype_W), 
    .RFaddr(RFaddr_W)
    );
	 // W级端口差不多改好了
endmodule
