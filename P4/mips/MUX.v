`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:52:26 11/19/2021 
// Design Name: 
// Module Name:    MUX 
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
module RegA_MUX(
     input [4:0] rt,
	  input [4:0] rd,
	  input RegDst,
	  input jal,
	  output reg [4:0] A3
	 
    );
     always@(*) begin
				if(jal == 1'b1) begin
				     A3 = 5'b11111;
				end
				else if ( RegDst == 1'b0) begin
				     A3 = rt;
				end
				else if ( RegDst == 1'b1) begin
				     A3 = rd ;
				end
	  end

endmodule
module ALUdataB_MUX(
     input [31:0] RD2,
	  input [15:0] imm,
	  input ALUSrc,
	  input [1:0] EXT,
	  output reg [31:0]  ALUdataB
         );
			
	 always@(*)begin
	      if ( EXT == 2'b00 ) begin
			     if ( ALUSrc == 1'b0 ) begin
				       ALUdataB =  RD2;
				  end
				  else  begin
				       ALUdataB = {{16{imm[15]}},imm};
				  end
			end
	      else if ( EXT == 2'b01 ) begin
			        ALUdataB  = {{16{1'b0}},imm};
			end
			else if ( EXT == 2'b10 ) begin
			        ALUdataB  = {imm,{16{1'b0}}};
			end
			else begin
			        ALUdataB  = ALUdataB;
			end   	  
    end	 
			
endmodule 
module RegD_MUX(
       input [31:0] ALUresult,
		 input [31:0] RD,
		 input [31:0] pc,
		 input  MemtoReg,
		 input  jal,
       output reg [31:0] WriteData
      );
		always@(*) begin
		     if ( jal == 1'b1 ) begin
			      WriteData = pc + 4;
			  end
			  else begin
			      if ( MemtoReg == 1'b0 ) begin
					      WriteData = ALUresult;
					end
					else begin
						   WriteData = RD;
					end
			  end
		    
		end
endmodule 