`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:28:53 11/13/2021 
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
	 wire [4:0] rs,rt,rd,A3;
	 wire [31:0] WD3;
	 wire [15:0] imm;
	 wire [25:0] index;
	 wire [5:0] opcode,func;
	 wire [31:0] pc,npc;
    wire  MemtoReg, MemWrite, ALUSrc, RegDst, RegWrite, jump, branch, jal,jr;
    wire [1:0] EXT;
	 wire [2:0] ALUCtrl;
	 wire [31:0] instr;
	 wire [31:0] RD1, RD2, dataB, ALUresult;
	 wire ALUzero;
	 wire [31:0] RD;
	 wire [1:0] DM_mode;
	 wire ifgtz;
	 wire bgtz;
	 
	 IFU main_ifu (
    .clk(clk), 
    .reset(reset), 
    .npc(npc), 
    .pc(pc), 
    .instr(instr), 
    .op(opcode), 
    .rs(rs), 
    .rt(rt), 
    .rd(rd), 
    .func(func), 
    .imm(imm), 
    .index(index)
    );
	 
	 Controller main_controller (
    .opcode(opcode), 
    .func(func), 
    .MemtoReg(MemtoReg), 
    .MemWrite(MemWrite), 
    .ALUCtrl(ALUCtrl), 
    .ALUSrc(ALUSrc), 
    .RegDst(RegDst), 
    .RegWrite(RegWrite), 
    .jump(jump), 
    .branch(branch), 
    .EXT(EXT), 
    .jal(jal), 
    .jr(jr),
	 .DM_mode(DM_mode),
	 .bgtz(bgtz) 
    );
	 
	 NPC main_npc (
    .pc(pc), 
    .imm(imm), 
    .index(index), 
    .RD1(RD1), 
    .branch(branch), 
    .ALUzero(ALUzero), 
    .jump(jump), 
    .jr(jr), 
    .npc(npc),
	 .ifgtz(ifgtz),
    .bgtz(bgtz)   
	 );

	 
    RegA_MUX main_A3MUX (
    .rt(rt), 
    .rd(rd), 
    .RegDst(RegDst), 
    .jal(jal), 
    .A3(A3)
    );
	 
	 RegD_MUX main_WD3MUX (
    .ALUresult(ALUresult), 
    .RD(RD), 
    .pc(pc), 
    .MemtoReg(MemtoReg), 
    .jal(jal), 
    .WriteData(WD3)
    );

    
	 GRF main_grf (
    .A1(rs), 
    .A2(rt), 
    .A3(A3), 
    .WD3(WD3), 
    .pc(pc), 
    .RD1(RD1), 
    .RD2(RD2), 
    .WE(RegWrite), 
    .clk(clk), 
    .reset(reset)
    );
	 
	 ALUdataB_MUX main_dataBMUX (
    .RD2(RD2), 
    .imm(imm), 
    .ALUSrc(ALUSrc), 
    .EXT(EXT), 
    .ALUdataB(dataB)
    );
	  
	 ALU main_alu (
    .dataA(RD1), 
    .dataB(dataB), 
    .ALUctrl(ALUCtrl), 
    .result(ALUresult), 
    .ALUzero(ALUzero),
	 .ifgtz(ifgtz)
    );
	 
	 DM main_dm (
    .clk(clk), 
    .reset(reset), 
    .WD(RD2), 
    .A(ALUresult), 
    .WE(MemWrite), 
    .pc(pc), 
    .RD(RD),
	 .DM_mode(DM_mode)
    );

	 
 

endmodule
