module ALU( aluSrc1, aluSrc2, ALU_operation_i, result, zero, overflow );

//I/O ports 
input	[32-1:0] aluSrc1;
input	[32-1:0] aluSrc2;
input	 [4-1:0] ALU_operation_i;

output	[32-1:0] result;
output			 zero;
output			 overflow;

//Internal Signals
wire			 zero;
wire			 overflow;
wire	[32-1:0] result;

//Main function
wire invertA;
wire invertB;
wire[1:0] operation;
wire[31:1]carryout_tmp;
wire less;

assign invertA = ALU_operation_i[3];
assign invertB = ALU_operation_i[2];
assign operation = ALU_operation_i[1:0];


ALU_1bit alu(result[0], carryout_tmp[1], aluSrc1[0], aluSrc2[0], invertA, invertB, operation, invertB, less);
genvar i;
generate
      	for(i=1;i<31;i=i+1)
	begin
		ALU_1bit alu(result[i], carryout_tmp[i+1], aluSrc1[i], aluSrc2[i], invertA, invertB, operation, carryout_tmp[i], 1'b0);
      	end
endgenerate
ALU_last alu31(result[31], overflow, less, aluSrc1[31], aluSrc2[31], invertA, invertB, operation, carryout_tmp[31], 1'b0);

assign overflow= (operation==2'b10) ? carryout_tmp[30]^carryout_tmp[31] : 0 ;
assign zero= (result==32'b0) ? 1 : 0 ;



endmodule
