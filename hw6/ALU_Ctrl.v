module ALU_Ctrl( funct_i, ALUOp_i, ALU_operation_o, FURslt_o );

//I/O ports 
input      [6-1:0] funct_i;
input      [4-1:0] ALUOp_i;

output     [5-1:0] ALU_operation_o;  
output     [2-1:0] FURslt_o;

     
//Internal Signals
wire		[5-1:0] ALU_operation_o;
wire		[2-1:0] FURslt_o;



//Main function
/*your code here*/
assign FURslt_o = (ALUOp_i==7) ?3 :((ALUOp_i==5) ?2:((ALUOp_i==2)&&((funct_i==0)||(funct_i==2))?1:0));
assign ALU_operation_o = (ALUOp_i==4) ?8: //addi
						(ALUOp_i==5) ?9: //lui
						(ALUOp_i==2)&&(funct_i==18) ?0: //add
						(ALUOp_i==2)&&(funct_i==16) ?1: //sub
						(ALUOp_i==2)&&(funct_i==20) ?2: //and
						(ALUOp_i==2)&&(funct_i==22) ?3: //or
						(ALUOp_i==2)&&(funct_i==21) ?4: //nor
						((ALUOp_i==2)&&(funct_i==32))||(ALUOp_i==8) ?5: //slt, blt
						(ALUOp_i==2)&&(funct_i==0) ?6: //sll
						(ALUOp_i==2)&&(funct_i==2) ?7: //srl
						(ALUOp_i==2)&&(funct_i==6) ?10: //sllv
						(ALUOp_i==2)&&(funct_i==4) ?11: //srlv
						(ALUOp_i==0) ?12: //lw, sw
						(ALUOp_i==1)||(ALUOp_i==6) ?13: //beq, bne
						(ALUOp_i==3) ?14: //bnez
						(ALUOp_i==9) ?15: //bgez
						(ALUOp_i==2)&&(funct_i==8) ?16: //jr
						0;

endmodule     
