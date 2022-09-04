`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:46:31 12/19/2021 
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
    input clk,                       // 时钟信号
    input reset,                     // 同步复位信号
    input interrupt,                 // 外部中断信号
    output [31:0] macroscopic_pc,    // 宏观 PC（见下文）

    output [31:0] i_inst_addr ,       // 取指 PC
    input  [31:0] i_inst_rdata,      // i_inst_addr 对应的 32 位指令
	                                   //  output [31:0] i_inst_addr,       // 取指 PC
                                      // input  [31:0] i_inst_rdata, 

    output [31:0] m_data_addr,       // 数据存储器待写入地址
    input  [31:0] m_data_rdata,      // m_data_addr 对应的 32 位数据
    output [31:0] m_data_wdata,      // 数据存储器待写入数据
    output [3 :0] m_data_byteen,     // 字节使能信号

    output [31:0] m_inst_addr,       // M 级PC

    output w_grf_we,                 // grf 写使能信号
    output [4 :0] w_grf_addr,        // grf 待写入寄存器编号
    output [31:0] w_grf_wdata,       // grf 待写入数据

    output [31:0] w_inst_addr        // W 级 PC
    );

    wire [31:0] PrAddr, PrWD, PrRD;
	 wire PrWE;
	 wire [3:0] Prbeen;
	 wire [31:0] TC0out ,TC1out;
	 wire TC0WE, TC1WE;
	 wire [31:0] TC0Addr, TC0WD, TC1Addr, TC1WD;
	 wire IRQ0,IRQ1;
	 wire [5:0] HWInt;
	 wire interrupt_respond;
	 
	 assign HWInt = {{3{1'b0}} ,interrupt, IRQ1, IRQ0 };
	 
   CPU mips_CPU (
    .clk(clk), 
    .reset(reset), 
    .HWInt(HWInt), 
    .i_inst_rdata(i_inst_rdata), 
    .i_inst_addr(i_inst_addr), 
    .PrRD(PrRD), 
    .PrAddr(PrAddr), 
    .PrWD(PrWD), 
    .Prbeen(Prbeen), 
    .PrWE(PrWE), 
    .m_inst_addr(m_inst_addr), 
    .macroscopic_pc(macroscopic_pc), 
    .w_grf_we(w_grf_we), 
    .w_grf_addr(w_grf_addr), 
    .w_grf_wdata(w_grf_wdata), 
    .w_inst_addr(w_inst_addr),
	 .interrupt_respond(interrupt_respond)
    );
	 
	 Bridge mips_Bridge (
    .PrAddr(PrAddr),  //√
    .PrWD(PrWD), //√
    .PrWE(PrWE), //√
    .Prbeen(Prbeen), //√
    .m_data_rdata(m_data_rdata), //√
    .TC0out(TC0out), //√
    .TC1out(TC1out),//√
	 .interrupt_respond(interrupt_respond), 
    .PrRD(PrRD), //√
    .m_data_byteen(m_data_byteen), //√
    .m_data_addr(m_data_addr), //√
    .m_data_wdata(m_data_wdata), //√
    .TC0WE(TC0WE), //√
    .TC1WE(TC1WE), //√
    .TC0Addr(TC0Addr), 
    .TC0WD(TC0WD), 
    .TC1Addr(TC1Addr), 
    .TC1WD(TC1WD)
    ); // Bridge整完了

    TC mips_TC0 (
    .clk(clk), 
    .reset(reset), 
    .Addr(TC0Addr[31:2]), 
    .WE(TC0WE), 
    .Din(TC0WD), 
    .Dout(TC0out), 
    .IRQ(IRQ0)
    );
	 
	 TC mips_TC1 (
    .clk(clk), 
    .reset(reset), 
    .Addr(TC1Addr[31:2]), 
    .WE(TC1WE), 
    .Din(TC1WD), 
    .Dout(TC1out), 
    .IRQ(IRQ1)
    );


endmodule
