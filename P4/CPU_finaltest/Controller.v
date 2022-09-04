`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:28:17 11/14/2021 
// Design Name: 
// Module Name:    Controller 
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
module Controller(
    input [5:0] opcode,
    input [5:0] func,
    output reg  MemtoReg,
    output reg MemWrite,
    output reg [2:0] ALUCtrl,
    output reg ALUSrc,
    output reg RegDst,
    output reg RegWrite,
    output reg jump,
    output reg branch,
    output reg [1:0] EXT,
	 output reg jal,
	 output reg jr,
	 output reg [1:0] DM_mode,
	 output reg bgtz
    );
	 always@(*) begin
	     case(opcode)
		         6'b000000: begin
					              case(func) 
									         6'b100001:begin //addu
												     RegWrite = 1;
													  RegDst = 1 ;
													  ALUSrc = 0;
													  branch = 0;
												     MemWrite = 0;
													  MemtoReg = 0 ;
													  ALUCtrl = 3'b010;
													  jump = 0;
													  EXT = 2'b00;
													  jal = 0;
													  jr = 0;
													  DM_mode = 2'b00;
													  bgtz = 0;
												end
												6'b100011:begin //subu
												     RegWrite = 1;
													  RegDst = 1 ;
													  ALUSrc = 0;
													  branch = 0;
												     MemWrite = 0;
													  MemtoReg = 0 ;
													  ALUCtrl = 3'b011;
													  jump = 0;
													  EXT = 2'b00;
													  jal = 0;
													  jr = 0;
												     DM_mode = 2'b00;
													  bgtz = 0;
												end
												6'b001000: begin //jr
												     RegWrite = 0;
													  RegDst = 0 ;
													  ALUSrc = 0;
													  branch = 0;
												     MemWrite = 0;
													  MemtoReg = 0 ;
													  ALUCtrl = 3'b000;
													  jump = 0;
													  EXT = 2'b00;
													  jal = 0;
													  jr = 1;
													  DM_mode = 2'b00;
													  bgtz = 0;
												end
												6'b000100:begin // sllv
												     RegWrite = 1;
													  RegDst = 1 ;
													  ALUSrc = 0;
													  branch = 0;
												     MemWrite = 0;
													  MemtoReg = 0 ;
													  ALUCtrl = 3'b101;
													  jump = 0;
													  EXT = 2'b00;
													  jal = 0;
													  jr = 0;
												     DM_mode = 2'b00;
													  bgtz = 0;
												end
												default : begin
												     RegWrite = 0;
													  RegDst = 0 ;
													  ALUSrc = 0;
													  branch = 0;
												     MemWrite = 0;
													  MemtoReg = 0 ;
													  ALUCtrl = 3'b000;
													  jump = 0;
													  EXT = 2'b00;
													  jal = 0 ;
													  jr = 0 ;      
													  DM_mode = 2'b00;
													  bgtz = 0;
												end
									  endcase
					              
					end
					6'b100011:begin //lw
					             RegWrite = 1;
									 RegDst = 0 ;
									 ALUSrc = 1;
									 branch = 0;
									 MemWrite = 0;
									 MemtoReg = 1 ;
									 ALUCtrl = 3'b010;
									 jump = 0;
									 EXT = 2'b00;
									 jal = 0;
									 jr = 0;
									 DM_mode = 2'b00;
									 bgtz = 0;
					end
					6'b101011:begin//sw
					             RegWrite = 0;
									 RegDst = 0 ;
									 ALUSrc = 1;
									 branch = 0;
									 MemWrite = 1;
									 MemtoReg = 0 ;
									 ALUCtrl = 3'b010;
									 jump = 0;
									 EXT = 2'b00;
									 jal = 0;
									 jr = 0;
									 DM_mode = 2'b00;
									 bgtz = 0;
					end
					6'b000100:begin//beq
					             RegWrite = 0;
									 RegDst = 0 ;
									 ALUSrc = 0;
									 branch = 1;
									 MemWrite = 0;
									 MemtoReg = 0 ;
									 ALUCtrl = 3'b011;
									 jump = 0;
									 EXT = 2'b00;
									 jal = 0;
									 jr = 0;
									 DM_mode = 2'b00;
									 bgtz = 0;
					end
					6'b001101:begin // ori
					             RegWrite = 1;
									 RegDst = 0 ;
									 ALUSrc = 0;
									 branch = 0;
									 MemWrite = 0;
									 MemtoReg = 0 ;
									 ALUCtrl = 3'b001;
									 jump = 0;
									 EXT = 2'b01;
									 jal = 0;
									 jr = 0;  
                            DM_mode = 2'b00;
									 bgtz = 0;
					end
					6'b001111:begin //lui
					             RegWrite = 1;
									 RegDst = 0 ;
									 ALUSrc = 0 ;
									 branch = 0;
									 MemWrite = 0;
									 MemtoReg = 0 ;
									 ALUCtrl = 3'b100;
									 jump = 0;
									 EXT = 2'b10;
									 jal = 0;
									 jr = 0;
									 DM_mode = 2'b00;
									 bgtz = 0;
					end
					6'b000011:begin//jal
					             RegWrite = 1;
									 RegDst = 0 ;
									 ALUSrc = 0;
									 branch = 0;
									 MemWrite = 0;
									 MemtoReg = 0 ;
									 ALUCtrl = 3'b000;
									 jump = 1 ;
									 EXT = 2'b00;
									 jal = 1 ;
									 jr = 0 ;
									 DM_mode = 2'b00;
									 bgtz = 0;
					end
					6'b000010:begin //j
					             RegWrite = 0;
									 RegDst = 0 ;
									 ALUSrc = 0;
									 branch = 0;
									 MemWrite = 0;
									 MemtoReg = 0 ;
									 ALUCtrl = 3'b000;
									 jump = 1 ;
									 EXT = 2'b00;
									 jal = 0;
									 jr = 0;
									 DM_mode = 2'b00;
									 bgtz = 0;
					             
					end
					6'b100000:begin   //lb
					             RegWrite = 1;
									 RegDst = 0 ;
									 ALUSrc = 1;
									 branch = 0;
									 MemWrite = 0;
									 MemtoReg = 1 ;
									 ALUCtrl = 3'b010;
									 jump = 0;
									 EXT = 2'b00;
									 jal = 0;
									 jr = 0;
									 DM_mode = 2'b01;	
									 bgtz = 0;
					end
					6'b101000:begin    //sb
					             RegWrite = 0;
									 RegDst = 0 ;
									 ALUSrc = 1;
									 branch = 0;
									 MemWrite = 1;
									 MemtoReg = 0 ;
									 ALUCtrl = 3'b010;
									 jump = 0;
									 EXT = 2'b00;
									 jal = 0;
									 jr = 0;
									 DM_mode = 2'b01;
									 bgtz = 0;
					end
					6'b100001:begin    //lh
					             RegWrite = 1;
									 RegDst = 0 ;
									 ALUSrc = 1;
									 branch = 0;
									 MemWrite = 0;
									 MemtoReg = 1 ;
									 ALUCtrl = 3'b010;
									 jump = 0;
									 EXT = 2'b00;
									 jal = 0;
									 jr = 0;
									 DM_mode = 2'b10;
									 bgtz = 0;
					end
					6'b101001:begin  // sh
					             RegWrite = 0;
									 RegDst = 0 ;
									 ALUSrc = 1;
									 branch = 0;
									 MemWrite = 1;
									 MemtoReg = 0 ;
									 ALUCtrl = 3'b010;
									 jump = 0;
									 EXT = 2'b00;
									 jal = 0;
									 jr = 0;
									 DM_mode = 2'b10;
									 bgtz = 0;
					end
					6'b000111: begin 					//bgtz
					             RegWrite = 0;
									 RegDst = 0 ;
									 ALUSrc = 0;
									 branch = 0;
									 MemWrite = 0;
									 MemtoReg = 0 ;
									 ALUCtrl = 3'b000;
									 jump = 0;
									 EXT = 2'b00;
									 jal = 0;
									 jr = 0;
									 DM_mode = 2'b00;
									 bgtz = 1;
					end
					default : begin //
					             RegWrite = 0;
									 RegDst = 0 ;
									 ALUSrc = 0;
									 branch = 0;
									 MemWrite = 0;
									 MemtoReg = 0 ;
									 ALUCtrl = 3'b000;
									 jump = 0 ;
									 EXT = 2'b00;
									 jal = 0;
									 jr = 0;
									 DM_mode = 2'b00;
									 bgtz = 0;
					end
					            
		  endcase
	 end
endmodule
