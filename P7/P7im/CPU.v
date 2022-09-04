`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:46:41 12/19/2021 
// Design Name: 
// Module Name:    CPU 
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

module CPU(
    input clk,
	 input reset,
	 input [5:0] HWInt,
	 input  [31:0]  i_inst_rdata ,   // I	i_inst_addr 对应的 32 位指令
	 output [31:0] i_inst_addr ,
	 input [31:0] PrRD,
	 output [31:0] PrAddr,
    output [31:0] PrWD,
	 output [3:0]  Prbeen,
	 output PrWE,
    output [31:0] m_inst_addr,	// O	M 级 PC
	 
	 output [31:0]macroscopic_pc,
	 output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr,
	 output interrupt_respond
    );
	 
	 // F级连线
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
	 wire [2:0]  btype;
	 wire D_branch_link ;
	 wire D_eret;

	 
	 // E级连线
	 wire [31:0] E_rs, E_rt;
	 wire [31:0] E_imm;
	 wire [4:0] E_rs_addr, E_rt_addr;
    wire [4:0] RFaddr_E;
	 wire [2:0] RFWDtype_E;
	 wire  RFWR_E;
	 wire [31:0] E_WD;
	 wire [3:0] E_AlUctrl;
	 wire [31:0] E_ALUresult;
	 wire  ALUdataAsrc;
    wire  [1:0] ALUdataBsrc;	 
	 wire [31:0] E_HILO;
	 wire [3:0] E_MDUtype;
	 wire E_busy; 
    wire E_start; 
	 wire ALUcalcROV, ALUDMOV;
	
	 
	 //M级连线
	 wire [31:0] M_rt ;
	 wire [31:0] M_ALUresult;
	 wire [4:0] M_rt_addr;
	 wire [4:0] M_rd_addr;
	 wire [4:0] RFaddr_M; 
	 wire [2:0] RFWDtype_M;
	 wire  RFWR_M;
	 wire [31:0] M_WD;
	 wire DM_WE;
	 wire [31:0] M_dm ;
	 wire [31:0] M_HILO;
	 wire [1:0] s_type;
    wire [2:0] EXT_op;
	 wire [31:0] M_CP0;
	 wire M_CP0WE;
	 wire M_eret;
	 wire M_store;
	 wire M_load;
	 
	 
	 // W级连线
	 wire [4:0] RFaddr_W;
	 wire [2:0] RFWDtype_W;
	 wire  RFWR_W;
	 wire [31:0] W_WD;
	 wire [31:0] W_ALUresult;
	 wire [31:0] W_dm;
	 wire [31:0] W_HILO;
	 wire [31:0] W_CP0;

	 wire stall;
	 wire Req;
    wire [31:0] EPC;  // Req、 EPC 设置完成 
	 
	 wire F_AdEL ,D_RI , E_calcROV, E_DMOV, M_DMOV, M_AdEL, M_AdES;
	 
	 wire [4:0] F_EXCcode,  D_pre_EXCcode,  D_EXCcode,  E_pre_EXCcode,  E_EXCcode ,
	            M_pre_EXCcode,  M_EXCcode ;
					
	  wire F_BD, D_BD, E_BD, M_BD, W_BD;
	 
	 wire E_cmpresult, M_cmpresult ,W_cmpresult;
	 
	 assign F_EXCcode =  F_AdEL ? 5'd4: 5'd0;
	 
	 assign D_EXCcode = (  D_pre_EXCcode != 5'd0 )? D_pre_EXCcode :
	                    D_RI ? 5'd10:
	                                 5'd0;
	 assign E_EXCcode =  ( E_pre_EXCcode != 5'd0 )? E_pre_EXCcode :
	                     E_calcROV ? 5'd12 :
								                    5'd0;
	 assign M_EXCcode =  (  M_pre_EXCcode !=  5'd0 )? M_pre_EXCcode:
	                      M_AdEL? 5'd4:
								 M_AdES? 5'd5:
								              5'd0;
	assign macroscopic_pc = M_pc;
	
	 assign F_BD =  ( branch |  jump | jrtype )? 1:0; /// 改到BD
	 
	 SU main_su (
    .D_instr(D_instr), 
    .E_instr(E_instr), 
    .M_instr(M_instr), 
    .W_instr(W_instr), 
	 .D_cmpresult(cmp_result), 
    .E_cmpresult(E_cmpresult), 
    .M_cmpresult(M_cmpresult), 
	 .HILO_busy( E_busy | E_start ), 
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
	 .D_eret(D_eret), 
	 .EPC(EPC), 
	 .Req(Req), 
    .F_pc(F_pc),
	 .F_AdEL(F_AdEL)
    );
	 

   
	 assign F_instr = ( F_AdEL == 1'b1 ) ? 32'd0 : i_inst_rdata;
	
	 assign  i_inst_addr = F_pc ;
	  
	 
	 D_reg main_D_reg (
    .F_instr(F_instr), 
    .F_pc(F_pc), 
    .en(Dreg_en), 
    .clk(clk), 
    .reset(reset), 
	 .F_BD(F_BD), 
	 .F_EXCcode(F_EXCcode), 
	 .Req(Req), 
    .D_instr(D_instr), 
    .D_pc(D_pc),
	 .D_BD(D_BD), 
    .D_EXCcode(D_pre_EXCcode)
    );
	 
	
	
	 wire [31:0] FW_rs_D = ( D_rs == 5'd0 )? 32'd0:
	                       ( D_rs == RFaddr_E &&  RFWR_E == 1'b1 )?  E_WD:
	                       ( D_rs == RFaddr_M &&  RFWR_M == 1'b1 )?  M_WD:
	                       ( D_rs == RFaddr_W &&  RFWR_W == 1'b1 )?  W_WD: 
								                                                  RD1;
	 wire [31:0] FW_rt_D = ( D_rt == 5'd0 )? 32'd0:
	                       ( D_rt == RFaddr_E &&  RFWR_E == 1'b1 )?  E_WD:
	                       ( D_rt == RFaddr_M &&  RFWR_M == 1'b1 )?  M_WD:
	                       ( D_rt == RFaddr_W &&  RFWR_W == 1'b1 )?  W_WD: 
								                                                  RD2;
    
	 
     CU ID_CU (
    .instr(D_instr), 
	 .cmp_result(cmp_result), 
    .rs_addr(D_rs), 
    .rt_addr(D_rt), 
    .imm(imm), 
    .EXT(EXT), 
    .branch(branch), 
    .jump(jump), 
    .jrtype(jrtype),
	 .btype(btype),
	 .branch_link(D_branch_link),
	 .eret(D_eret),
	 .RI(D_RI)
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
	 .D_branch_link(D_branch_link), 
	 .Req(Req), 
	 .D_eret(D_eret),	 //到这
	 .EPC(EPC), 
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
	 .btype(btype), 
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
	 .D_EXCcode(D_EXCcode),
	 .D_BD(D_BD), 
	 .Req(Req), 
	 .stall_D_pc(D_pc), 
	 .stall(stall),
	 .D_cmpresult(cmp_result), 
    .E_instr(E_instr), 
    .E_rs(E_rs), 
    .E_rt(E_rt), 
    .E_IMM(E_imm), 
    .E_pc(E_pc),
	 .E_EXCcode(E_pre_EXCcode), //
    .E_BD(E_BD), //
	 .E_cmpresult(E_cmpresult)
    );   //E reg端口设置完成  
	
	
	
	 assign E_WD =( RFWDtype_E == 3'b010 )? E_pc+8:
	                                             	32'b0;
																	
	 CU main_EXCU (
    .instr(E_instr), 
	 .cmp_result(E_cmpresult),  
	 .rs_addr(E_rs_addr), 
    .rt_addr(E_rt_addr), 
    .RFWE(RFWR_E), 
    .ALUctrl(E_AlUctrl), 
    .RFWD_Type(RFWDtype_E), 
    .RFaddr( RFaddr_E),
	 .ALUdataAsrc(ALUdataAsrc), 
    .ALUdataBsrc(ALUdataBsrc),
	 .MDUop(E_MDUtype),
	 .ALUcalcROV(ALUcalcROV), 
    .ALUDMOV(ALUDMOV)
    );		 //  E级CU端口设置完成									 
		
		
	 wire [31:0] FW_rs_E = ( E_rs_addr == 5'd0 )? 32'd0:
	                       ( E_rs_addr == RFaddr_M &&  RFWR_M == 1'b1 )?  M_WD:
	                       ( E_rs_addr == RFaddr_W &&  RFWR_W == 1'b1 )?  W_WD: 
								                                                  E_rs;
	 wire [31:0] FW_rt_E = ( E_rt_addr == 5'd0 )? 32'd0:            
	                       ( E_rt_addr == RFaddr_M &&  RFWR_M == 1'b1 )?  M_WD:
	                       ( E_rt_addr == RFaddr_W &&  RFWR_W == 1'b1 )?  W_WD: 
								                                                  E_rt;

	 wire [31:0] E_dataB = ( ALUdataBsrc == 2'b11 )? {{27{1'b0}},E_instr[10:6]} :
	                       ( ALUdataBsrc == 2'b10 )? {{27{1'b0}},FW_rs_E[4:0]} :
	                       ( ALUdataBsrc == 2'b01 )?  E_imm:                       
	                                                        FW_rt_E; 
	

	
	 wire [31:0] E_dataA = ( ALUdataAsrc == 1'b1 )? FW_rt_E:
	                                                        FW_rs_E;
	 
	 E_ALU main_EALU (
    .dataA(E_dataA), 
    .dataB(E_dataB), 
    .ALUctrl(E_AlUctrl), 
	 .ALUcalcROV(ALUcalcROV), 
    .ALUDMOV(ALUDMOV),
    .result(E_ALUresult),
	 .E_calcROV(E_calcROV), 
    .E_DMOV(E_DMOV)
    ); // E_ALU端口设置完成
	 

	
	 
    MDU main_mdu (
    .clk(clk), 
    .reset(reset), 
    .dataA(FW_rs_E), 
    .dataB(FW_rt_E), 
    .MDUtype(E_MDUtype), 
	 .Req(Req), 
    .busy(E_busy), 
    .start(E_start), 
    .dataout(E_HILO)
    );
	 
	 //// 修改	Mreg
	 M_reg main_Mreg (
    .clk(clk), 
    .reset(reset), 
    .E_instr(E_instr), 
    .E_ALUresult(E_ALUresult), 
    .E_rt(FW_rt_E), 
    .E_pc(E_pc), 
	 .E_HILO(E_HILO), 
	 .E_EXCcode(E_EXCcode), 
    .E_BD(E_BD), 
    .Req(Req), 
    .E_DMOV(E_DMOV), 
	 .E_cmpresult(E_cmpresult), 
    .M_instr(M_instr), 
    .M_ALUresult(M_ALUresult), 
    .M_rt(M_rt), 
    .M_pc(M_pc),
	 .M_HILO(M_HILO), 
	 .M_EXCcode(M_pre_EXCcode), //
    .M_BD(M_BD), //
    .M_DMOV(M_DMOV),
	 .M_cmpresult(M_cmpresult)
	 
    );
	 /////////////////////////////////////////////////////////////////////////////////////////////////

	 
	 assign M_WD = ( RFWDtype_M == 3'b000 )? M_ALUresult:
	               ( RFWDtype_M == 3'b010 )? M_pc+8:
						( RFWDtype_M == 3'b011 )? M_HILO:
						                                 32'b0;
																 
	
	 
	  CU main_DMCU (
    .instr(M_instr), 
	 .rd_addr(M_rd_addr), 
	 .cmp_result(M_cmpresult),  
    .rt_addr(M_rt_addr), 
    .RFWE(RFWR_M), 
    .RFWD_Type(RFWDtype_M), 
    .RFaddr(RFaddr_M),
	 .load(M_load), 
    .store(M_store), 
	 .s_type(s_type), 
    .EXT_op(EXT_op),
	 .eret(M_eret), 
	 .CP0WE(M_CP0WE)
    ); /// M_级差不多改好了  

	 
	 
	 wire [31:0] FW_rt_M = ( M_rt_addr == 5'd0 )? 32'd0:            
	                       ( M_rt_addr == RFaddr_W &&  RFWR_W == 1'b1 )?  W_WD: 
								                                                      M_rt;
																										
	 assign PrAddr = M_ALUresult;	
	 assign PrWE = ( M_store & ! Req ) ? 1 : 0 ;
	 assign m_inst_addr = M_pc ;
	 
	 M_BE main_M_BE (
    .indata( FW_rt_M ), 
    .s_type(s_type), 
    .A(M_ALUresult),
	 .M_DMOV(M_DMOV),
    .load(M_load), 
    .store(M_store),    
    .EXTop(EXT_op),
	 .Req(Req), 
    .BE(Prbeen),  //BE完成
    .outdata(PrWD), ////////////
	 .M_AdEL(M_AdEL), 
    .M_AdES(M_AdES)
    );
    // BE模块修改完成
	
 
	 
	 M_data_ext main_Mdataext (
    .A(M_ALUresult), 
    .Din(PrRD), //// m_data_rdata[31:0]	
    .Op(EXT_op), 
    .Dout(M_dm)
    );
    
	 CP0 main_M_CP0 (
    .A1(M_rd_addr), 
    .A2(M_rd_addr), 
    .DIn(FW_rt_M), 
    .PC(M_pc), 
    .ExcCodeIn(M_EXCcode), 
    .HWInt(HWInt), 
    .We(M_CP0WE), 
    .EXLClr(M_eret), 
    .clk(clk), 
    .reset(reset), 
    .BDin(M_BD), 
    .IntReq(Req), //总信号就为 Req
    .EPCout(EPC), 
    .DOut(M_CP0),
	 .interrupt_respond(interrupt_respond)
    );
	 // CP0端口设置好
	 
	 
	 W_reg main_W_reg (
    .clk(clk), 
    .reset(reset), 
	 .Req(Req), 
    .M_instr(M_instr), 
    .M_dm(M_dm), 
    .M_ALUresult(M_ALUresult), 
    .M_pc(M_pc), 
	 .M_HILO(M_HILO), 
	 .M_CP0(M_CP0), 
	 .M_cmpresult(M_cmpresult), 
    .W_instr(W_instr), 
    .W_dm(W_dm), 
    .W_ALUresult(W_ALUresult), 
    .W_pc(W_pc),
	 .W_HILO(W_HILO), 
	 .W_CP0(W_CP0), 
	 .W_cmpresult(W_cmpresult)
    ); // w级reg端口设置完成
	 
	 
	 assign W_WD = ( RFWDtype_W == 3'b000 )? W_ALUresult:
	               ( RFWDtype_W == 3'b010 )? W_pc+8:
						( RFWDtype_W == 3'b001 )? W_dm: 
                  ( RFWDtype_W == 3'b011 )? W_HILO: 
				      ( RFWDtype_W == 3'b100 )? W_CP0: 
						                              32'b0;	 	
  
	  CU main_WBCU (
    .instr(W_instr), 
	 .cmp_result(W_cmpresult),
    .RFWE(RFWR_W), 
    .RFWD_Type(RFWDtype_W), 
    .RFaddr(RFaddr_W)
    );
	 
	 assign  w_grf_we = RFWR_W;
    assign  w_grf_addr = RFaddr_W;
    assign  w_grf_wdata = W_WD ;
    assign  w_inst_addr = W_pc;
	
endmodule
