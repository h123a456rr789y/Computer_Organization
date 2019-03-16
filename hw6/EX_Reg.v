module EX_Reg( clk_i, rst_n, PC_i, PC_o, rs1_i, rs1_o, rt2_i, rt2_o, instr_i, instr_o, ALU_zero, ALU_zero_o, jumpAddr_i, jumpAddr_o, Branch_i, Branch_o, MemWrite_i, MemWrite_o, MemRead_i, MemRead_o, Jump_i, Jump_o, Mem2Reg_i, Mem2Reg_o, RegWrite_i, RegWrite_o );

//I/O ports
input           clk_i;
input           rst_n;
input  [32-1:0] PC_i;
input  [32-1:0] rs1_i;
input  [32-1:0] rt2_i;
input  [4:0] instr_i;
input ALU_zero;
input [31:0] jumpAddr_i;
	//M
input  Branch_i;
input  MemWrite_i;
input  MemRead_i;
input	Jump_i;
	//WB
input  Mem2Reg_i;
input  RegWrite_i;


output reg [32-1:0] PC_o;
output reg [32-1:0] rs1_o;
output reg [32-1:0] rt2_o;
output reg [4:0] instr_o;
output reg ALU_zero_o;
output reg [31:0] jumpAddr_o;
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
		instr_o <= 0;
		ALU_zero_o <= 0;
		jumpAddr_o <= 0;
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
		instr_o <= instr_i;
		ALU_zero_o <= ALU_zero;
		jumpAddr_o <= jumpAddr_i;
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
