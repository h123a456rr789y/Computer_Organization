//`include "ALU_1bit.v"
module ALU( aluSrc1, aluSrc2, ALU_operation_i, result, zero, overflow );

//I/O ports 
input	[32-1:0] aluSrc1;	//rs
input	[32-1:0] aluSrc2;
input	 [5-1:0] ALU_operation_i;

output	[32-1:0] result;
output			 zero;
output			 overflow;

//Internal Signals
wire			 zero;
wire			 overflow;
wire	[32-1:0] result;

// me
wire[31:0] carryOut;
wire carryIn;
reg temp;
wire res;

//Main function
/*your code here*/

assign result = (ALU_operation_i==0)||(ALU_operation_i==8)||(ALU_operation_i==12) ? aluSrc1 + aluSrc2 :
    (ALU_operation_i==1)||(ALU_operation_i==13) ? aluSrc1 - aluSrc2 :
    (ALU_operation_i==2) ? aluSrc1 & aluSrc2 :
    (ALU_operation_i==3) ? aluSrc1 | aluSrc2 :
    (ALU_operation_i==4) ? ~(aluSrc1 | aluSrc2) :
    (ALU_operation_i==5) ? (aluSrc1[31]^aluSrc2[31]) ?(aluSrc1[31]>aluSrc2[31] ?1:0) :(aluSrc1<aluSrc2?1:0) :
    (ALU_operation_i==10) ? aluSrc2 << aluSrc1 :
    (ALU_operation_i==11) ? aluSrc2 >> aluSrc1 :
	(ALU_operation_i==14) ? aluSrc1 :
	(ALU_operation_i==15) ? (aluSrc1[31]==1) ?0 :1 :
	(ALU_operation_i==16) ? 0:
    0;

assign overflow = ((aluSrc1[31]==0 && aluSrc2[31]==0 && result[31]==1 ) || (aluSrc1[31]==1 && aluSrc2[31]==1 && result[31]==0 )) ?1:0;

nor G33(zero,result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7],result[8],result[9],result[10],result[11],result[12],result[13],result[14],result[15],result[16],result[17],result[18],result[19],result[20],result[21],result[22],result[23],result[24],result[25],result[26],result[27],result[28],result[29],result[30],result[31]);

endmodule
