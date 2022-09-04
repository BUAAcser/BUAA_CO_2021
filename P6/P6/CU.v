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
	 input cmp_result,
    output [4:0] rs_addr,
    output [4:0] rt_addr,
	 output [4:0] rd_addr,
    output [25:0] imm,
	 
	 output [1:0] EXT,
	 output branch,
	 output jump,
	 output jrtype,
	 output RFWE,
	 output [3:0] ALUctrl,
	 output [1:0] RFWD_Type , // 写入寄存器数据选择
	 output [4:0] RFaddr,  
    output [2:0] btype,
                            	 //  A3 的写入地址 //控制信号,暂时没加jal的控制信号，jal控制信号用来控制A3的选择，后续可以通过另外方式实现
	 
	 output calc_r,
	 output calc_i,
	 output load,
	 output store,
	 output lui,
	 output j_imm,
	 output j_rs,
	 output j_link,
	 output branch_link,
	 output shifts,
	 output shiftv,
	 output md,
	 output mf,
	 output mt,
	 output branch_t_s,
	 output branch_t_d,
	 
    output ALUdataAsrc,
	 output [1:0] ALUdataBsrc,
	 output [3:0] MDUop, //加在E级CU上
	 output [1:0] s_type,
    output [2:0] EXT_op
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
	 wire jalr   = ( opcode == 6'b000000 && func == 6'b001001 )? 1:0;
	 assign  lui  = ( opcode == 6'b001111 )? 1:0;
	 
	 wire add = ( opcode == 6'b000000 && func == 6'b100000 )?1:0;
	 wire sub = ( opcode == 6'b000000 && func == 6'b100010 )?1:0;
	 wire AND = ( opcode == 6'b000000 && func == 6'b100100 )? 1:0;
	 wire OR  = ( opcode == 6'b000000 && func == 6'b100101 )? 1:0;
	 wire XOR = ( opcode == 6'b000000 && func == 6'b100110 )? 1:0;
	 wire NOR = ( opcode == 6'b000000 && func == 6'b100111 )? 1:0;
	 wire slt = ( opcode == 6'b000000 && func == 6'b101010 )? 1:0;
	 wire sltu = ( opcode == 6'b000000 && func == 6'b101011 )? 1:0;
	 
	 wire addi = ( opcode  == 6'b001000 )? 1:0;
	 wire addiu = ( opcode == 6'b001001 )? 1:0;
	 wire andi = ( opcode == 6'b001100 )? 1:0;
	 wire xori = ( opcode == 6'b001110 )? 1:0;
	 wire slti = ( opcode == 6'b001010 )? 1:0;
	 wire sltiu = ( opcode == 6'b001011 )? 1:0;
	 
	 wire sll = ( opcode == 6'b000000 && func == 6'b000000 && rt_addr != 5'd0 )? 1:0;
	 wire srl = ( opcode == 6'b000000 && func == 6'b000010 )? 1:0;
	 wire sra = ( opcode == 6'b000000 && func == 6'b000011 )? 1:0;
	 wire sllv = ( opcode == 6'b000000 && func == 6'b000100 )? 1:0;
	 wire srlv = ( opcode == 6'b000000 && func == 6'b000110 )? 1:0 ;
	 wire srav = ( opcode == 6'b000000 && func == 6'b000111 )? 1:0;
	 
	 wire mult = ( opcode == 6'b000000 && func == 6'b011000 )? 1:0;
	 wire multu = ( opcode == 6'b000000 && func == 6'b011001 )?1:0;
	 wire div =  ( opcode == 6'b000000 && func == 6'b011010 )? 1:0; 
	 wire divu = ( opcode == 6'b000000 && func == 6'b011011 )? 1:0;
	 wire mfhi = ( opcode == 6'b000000 && func == 6'b010000 )? 1:0;
	 wire mflo = ( opcode == 6'b000000 && func == 6'b010010 )? 1:0;
	 wire mthi = ( opcode == 6'b000000 && func == 6'b010001 )? 1:0;
	 wire mtlo = ( opcode == 6'b000000 && func == 6'b010011 )? 1:0;
	 
	 wire lb =  ( opcode == 6'b100000 )? 1:0;
	 wire lbu = ( opcode == 6'b100100 )? 1:0;
	 wire lh =  ( opcode == 6'b100001 )? 1:0;
	 wire lhu = ( opcode == 6'b100101 )? 1:0;
	 wire sb  = ( opcode == 6'b101000 )? 1:0;
	 wire sh =  ( opcode == 6'b101001 )? 1:0;
	 
	 wire bne  = ( opcode == 6'b000101 )? 1:0;
	 wire blez = ( opcode == 6'b000110 )? 1:0;
	 wire bgtz = ( opcode == 6'b000111 )? 1:0;
	 wire bltz = ( opcode == 6'b000001 &&  rt_addr == 5'b00000 ) ? 1:0;
	 wire bgez = ( opcode == 6'b000001 &&  rt_addr == 5'b00001 ) ? 1:0;
	 
	 wire   blztal = ( opcode == 6'b000001 &&  rt_addr == 5'b10000 )? 1:0;
	 
	 
	 
	 assign EXT = ( ori | andi | xori )? 2'b01 :
	              ( lui == 1'b1 )? 2'b10 :
	                           		     2'b00;
    assign jump = j | jal;
	 
	 			
	 assign jrtype = jr | jalr ;
	 
	 assign ALUctrl = ( AND | andi  )? 4'b0000 :
	                  ( OR | ori )? 4'b0001 :
	                  ( addu | store | load | add | addi | addiu )? 4'b0010:
	                  ( subu | sub ) ? 4'b0011 :
						   ( lui | XOR | xori )? 4'b0100 :
							( sll | sllv )? 4'b0101 :
							( srl | srlv )? 4'b0110 :
							( sra | srav )? 4'b0111 :
						    NOR? 4'b1000 :
							( slt | slti )? 4'b1001 :
							( sltu | sltiu )? 4'b1010 :
                 							            4'b0000 ; //P5控制信号用指令定义
															 
	 assign branch = beq | bne | blez | bgtz | bltz | bgez ; // branch 既是模块控制信号，6个 branch类信号
	 
	 
	 assign calc_r = addu | subu | add | sub | AND | OR | XOR | NOR | slt | sltu ; // 10个 R指令 齐活
	 assign calc_i = ori | addi | addiu | andi | xori | slti | sltiu ;  //7个I指令加lui齐了
	 assign load = lw | lb | lbu | lh | lhu ;
	 assign store = sw | sb | sh ;            // 8个访存类指令，齐了
	 assign shifts = 	sll | srl | sra ; 
	 assign shiftv =  sllv | srlv | srav ; // 6个位移指令
	 
	 assign md = mult |  multu | div | divu ;
	 assign mf = mfhi | mflo ;
	 assign mt = mthi |  mtlo ;
	 
	 assign branch_t_s = blez | bgtz | bltz | bgez ;
	 assign branch_t_d = beq | bne ;                 //branch分类信号用于控制Tuse
	 
	 assign j_imm = j | jal;
	 assign j_rs = jr | jalr;
	 assign j_link = jal | jalr ;
	 
	 assign branch_link = blztal;
	 
	 
	 assign RFWE =  calc_r | calc_i | lui | shifts | shiftv | mf | load | jal | jalr | 
	                (branch_link & cmp_result) ;
	 
    
	 assign RFaddr =  ( calc_r | shifts | shiftv | jalr | mf ) ? instr[15:11]:    //写入Rd寄存器
	                  ( calc_i | lui | load)? instr[20:16]:    // 写入Rt寄存器
							( jal == 1'b1 ||( branch_link == 1'b1 && cmp_result == 1'b1) ) ? 5'd31 : // jalr指令这里不存31号寄存器
							                                                                        5'd0;
																															
																															
	 assign RFWD_Type =  load ? 2'b01:
							   ( j_link | branch_link  )? 2'b10:
								 mf ?                       2'b11:
								                                 2'b00 ;        
																			
	// 写使能 写入地址 写入类型，这三个要改得一起改
	                                   
	 assign btype =  beq ? 3'b001:
	                 bne ? 3'b010:
						  blez ? 3'b011:
						  bgtz ? 3'b100:
						  bltz ? 3'b101:
						  bgez ? 3'b110 :
                    branch_link ?  3'b111 :                 
 						                                3'b000;	  // 加 branch类指令 时要大改
																  
																  
	  assign  ALUdataAsrc =  ( shifts |  shiftv )? 1:0;
	  assign  ALUdataBsrc =  shifts ? 2'b11 :
	                         shiftv ? 2'b10 :
									 ( calc_i | lui |  load | store ) ? 2'b01 :
									                                           2'b00;
   
     assign  MDUop = mult ?  4'd1:
	                  multu ? 4'd2:
							div?    4'd3:
							divu ?  4'd4:
							mfhi ?  4'd5:
							mflo ?  4'd6:
  							mthi ?  4'd7:
              			mtlo ?  4'd8:
  							           4'd0;
	 
	  assign  s_type = sw? 2'b01:
	                   sh? 2'b10:
							 sb? 2'b11:
							           2'b00;
	  
	  assign  EXT_op = lbu? 3'b001:
	                   lb?  3'b010:
							 lhu? 3'b011:
							 lh?  3'b100:
							             3'b000;
endmodule
