`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:02:04 11/28/2021 
// Design Name: 
// Module Name:    CU 
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
module CU(
    input [31:0] instr,
    output [4:0] rs_addr,
    output [4:0] rt_addr,
	 output [4:0] rd_addr,
    output [25:0] imm,
	 
	 output [1:0] EXT,
	 output branch,
	 output jump,
	 output jrtype,
	 output ALUSrc,
	 output RFWE,
	 output DM_WE,
	 output [2:0] ALUctrl,
	 output [1:0] RFWD_Type , // д��Ĵ�������ѡ��
	 output [4:0] RFaddr,   //  A3 ��д���ַ //�����ź�,��ʱû��jal�Ŀ����źţ�jal�����ź���������A3��ѡ�񣬺�������ͨ�����ⷽʽʵ��
	 
	 output calc_r,
	 output calc_i,
	 output load,
	 output store,
	 output lui,
	 output j_imm,
	 output j_rs,
	 output j_link
	 
	 
    );
	 
	 wire [5:0] opcode;
    wire [5:0] func;
	 assign opcode = instr [31:26];
	 assign func = instr [5:0];
	 
	 assign rs_addr = instr [25:21];
	 assign rt_addr = instr [20:16];
	 assign rd_addr = instr [15:11];
	 assign imm = instr [25:0];
	 
	 wire addu = ( opcode == 6'b000000 && func == 6'b100001 )? 1:0;
    wire subu = ( opcode == 6'b000000 && func == 6'b100011 )? 1:0; 
	 wire ori  = ( opcode == 6'b001101 )? 1:0;
	 wire lw   = ( opcode == 6'b100011 ) ? 1:0;
	 wire sw   = ( opcode == 6'b101011 )? 1:0;
	 wire beq  = ( opcode == 6'b000100 )? 1:0;
	 wire j    = ( opcode == 6'b000010 )? 1:0;
	 wire jal  = ( opcode == 6'b000011 )? 1:0;
	 wire jr   = ( opcode == 6'b000000 && func == 6'b001000 )? 1:0;
	 assign  lui  = ( opcode == 6'b001111 )? 1:0;
	 
	 assign EXT = ( ori == 1'b1 )? 2'b01 :
	              ( lui == 1'b1 )? 2'b10 :
					                          2'b00;
	 
	 
    assign jump = j|jal;
    assign ALUSrc = lw | sw | ori | lui ;
	 assign RFWE = addu | subu | lw | ori | lui | jal ;
	 assign DM_WE = sw;
	 assign jrtype = jr;
	 
	 assign ALUctrl = ( addu == 1'b1 || sw == 1'b1 || lw ==1'b1 )? 3'b010:
	                  ( subu == 1'b1 ) ? 3'b011 :
							( ori == 1'b1 )? 3'b001 :
						   ( lui == 1'b1 )? 3'b100 :
							                         3'b000 ;
	 
	 assign calc_r = addu | subu;
	 assign calc_i = ori;
	 assign load = lw;
	 assign store = sw;
	 assign branch = beq;
	 assign j_imm = j | jal;
	 assign j_rs = jr;
	 assign j_link = jal;
    
	 assign RFaddr = calc_r ? instr[15:11]:
	                  ( calc_i | lui | load)? instr[20:16]:
							 jal ? 5'd31 :
							              5'd0;
	 assign RFWD_Type =  load ? 2'b01:
								j_link ? 2'b10:
								              2'b00 ;
	                                   
											  
	
  
  
endmodule
