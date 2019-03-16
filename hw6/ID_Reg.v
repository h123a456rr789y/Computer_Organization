module ID_Reg( clk_i, rst_n, PC_i, PC_o, rs1_i, rs1_o, rt2_i, rt2_o, signEx_i, signEx_o, zero_i, zero_o, instr_i, instr_o, ALUSrc_i, ALUSrc_o, ALUOp_i, ALUOp_o, RegDst_i, RegDst_o, BranchType_i, BranchType_o, Branch_i, Branch_o, MemWrite_i, MemWrite_o, MemRead_i, MemRead_o, Jump_i, Jump_o, Mem2Reg_i, Mem2Reg_o, RegWrite_i, RegWrite_o );

//I/O ports
input           clk_i;
input           rst_n;
input  [32-1:0] PC_i;
input  [32-1:0] rs1_i;
input  [32-1:0] rt2_i;
input  [32-1:0] signEx_i;
input  [32-1:0] zero_i;
input  [32-1:0] instr_i;

	//EX
input  ALUSrc_i;
input  [3:0] ALUOp_i;
input  RegDst_i;
input  BranchType_i;
	//M
input  Branch_i;
input  MemWrite_i;
input  MemRead_i;
input  Jump_i;
	//WB
input  Mem2Reg_i;
input  RegWrite_i;


output reg [32-1:0] PC_o;
output reg [32-1:0] rs1_o;
output reg [32-1:0] rt2_o;
output reg [32-1:0] signEx_o;
output reg [32-1:0] zero_o;
output reg [32-1:0] instr_o;
	//EX
output reg ALUSrc_o;
output reg [3:0] ALUOp_o;
output reg RegDst_o;
output reg BranchType_o;
	//M
output reg Branch_o;
output reg MemWrite_o;
output reg MemRead_o;
output reg Jump_o;
	//WB
output reg Mem2Reg_o;
output reg RegWrite_o;   

//Writing data when postive edge clk_i was set.
always @( posedge clk_i  ) begin
    if(rst_n == 0) begin
	    PC_o <= 0;
		rs1_o <= 0;
		rt2_o <= 0;
		signEx_o <= 0;
		zero_o <= 0;
		instr_o <= 0; 
			//EX
		ALUSrc_o <= 0;
		ALUOp_o <= 0;
		RegDst_o <= 0;
		BranchType_o <= 0;
			//M
		Branch_o <= 0;
		MemWrite_o <= 0;
		MemRead_o <= 0;
		Jump_o <= 0;
			//WB
		Mem2Reg_o <= 0;
		RegWrite_o <= 0; 
	end
    else begin
	    PC_o <= PC_i;
		rs1_o <= rs1_i;
		rt2_o <= rt2_i;
		signEx_o <= signEx_i;
		zero_o <= zero_i;
		instr_o <= instr_i;
			//EX
		ALUSrc_o <= ALUSrc_i;
		ALUOp_o <= ALUOp_i;
		RegDst_o <= RegDst_i;
		BranchType_o <= BranchType_i;
			//M
		Branch_o <= Branch_i;
		MemWrite_o <= MemWrite_i;
		MemRead_o <= MemRead_i;
		Jump_o <= Jump_i;
			//WB
		Mem2Reg_o <= Mem2Reg_i;
		RegWrite_o <= RegWrite_i;  
	end
end

endmodule
