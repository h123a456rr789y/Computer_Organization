module Decoder( instr_op_i, RegWrite_o,	ALUOp_o, ALUSrc_o, RegDst_o, Jump_o, Branch_o, BranchType_o, MemWrite_o, MemRead_o, MemtoReg_o );
     
//I/O ports
input	[6-1:0] instr_op_i;

output			RegWrite_o;
output	[4-1:0] ALUOp_o;
output			ALUSrc_o;
output			RegDst_o;

output      Jump_o;
output      Branch_o;
output  	BranchType_o;
output      MemWrite_o;
output      MemRead_o; 
output      MemtoReg_o;
 
//Internal Signals
wire	[4-1:0] ALUOp_o;
wire			ALUSrc_o;
wire			RegWrite_o;
wire			RegDst_o;

wire      Jump_o;
wire      Branch_o;
wire   	  BranchType_o;
wire      MemWrite_o;
wire      MemRead_o; 
wire      MemtoReg_o;

assign ALUOp_o = (instr_op_i==63) ?2: //R-type
                 (instr_op_i==55) ?4: //addi
                 (instr_op_i==48) ?5: //lui
                 (instr_op_i==33) ?0: //lw
                 (instr_op_i==35) ?0: //sw
                 (instr_op_i==59) ?1: //beq
                 (instr_op_i==37) ?6: //bne
                 0;
assign ALUSrc_o = ((instr_op_i==55)||(instr_op_i==48)||(instr_op_i==33)||(instr_op_i==35)) ?1 :0;
assign BranchType_o = (instr_op_i==37) ?1 :0;
assign MemWrite_o = (instr_op_i==35) ?1 :0;
assign RegWrite_o = ((instr_op_i==63)||(instr_op_i==55)||(instr_op_i==48)||(instr_op_i==33)) ?1 :0;
assign RegDst_o = (instr_op_i==63) ?1 :0;
assign MemtoReg_o = (instr_op_i==33) ?1 :0;
assign MemRead_o = (instr_op_i==33) ?1 :0;
assign Jump_o = (instr_op_i==34) ?1 :0;
assign Branch_o = ((instr_op_i==59)||(instr_op_i==37)) ?1 :0;

endmodule
   