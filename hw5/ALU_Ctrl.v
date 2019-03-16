module ALU_Ctrl( funct_i, ALUOp_i, ALU_operation_o, FURslt_o,Jr_o);

//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALU_operation_o;  
output     [2-1:0] FURslt_o;
output		Jr_o;       
//Internal Signals
wire		[4-1:0] ALU_operation_o;
wire		[2-1:0] FURslt_o;
wire		Jr_o;

//Main function


assign	FURslt_o = 			(ALUOp_i == 3'b101) ? 2:		//lui
					({ALUOp_i,funct_i} == 9'b010_000000) ? 1://sll
					({ALUOp_i,funct_i} == 9'b010_000010) ? 1://srl
					({ALUOp_i,funct_i} == 9'b010_000110) ? 1://sllv
					({ALUOp_i,funct_i} == 9'b010_000110) ? 1://srlv
					0;//lui

assign	ALU_operation_o = ({ALUOp_i,funct_i} == 9'b010_010010 || ALUOp_i == 3'b100) ? 4'b0010://add
				({ALUOp_i,funct_i} == 9'b010_010000) ? 4'b0110://sub
				({ALUOp_i,funct_i} == 9'b010_010100) ? 4'b0000://and
				({ALUOp_i,funct_i} == 9'b010_010110) ? 4'b0001://or
				({ALUOp_i,funct_i} == 9'b010_010101) ? 4'b1100://nor
				({ALUOp_i,funct_i} == 9'b010_100000) ? 4'b0111://slt
				({ALUOp_i,funct_i} == 9'b010_000000) ? 4'b0001://sll
				({ALUOp_i,funct_i} == 9'b010_000010) ? 4'b0000://srl
				({ALUOp_i,funct_i} == 9'b010_000110) ? 4'b0011://sllv
				(ALUOp_i==3'b001||ALUOp_i==3'b110)?4'b0110:	//beq bne
				(ALUOp_i == 3'b000) ? 4'b0010:			//lw sw
				4'b0010;					//srlv


assign Jr_o = (ALUOp_i==3'b010 && funct_i==6'b001000)?1:0;



endmodule     
