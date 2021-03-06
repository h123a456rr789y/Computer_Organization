module ALU( result, zero, overflow, aluSrc1, aluSrc2, invertA, invertB, operation );
   
  	output wire[31:0] result;
  	output wire zero;
  	output wire overflow;

  	input wire[31:0] aluSrc1;
  	input wire[31:0] aluSrc2;
  	input wire invertA;
  	input wire invertB;
  	input wire[1:0] operation;
  
  	wire set;
	wire[31:0] carryout_tmp;

	
	genvar i;

  	generate
      		for(i=1;i<=31;i=i+1)
		begin
	  	ALU_1bit alu(
			.result(result[i]),
			.carryOut(carryout_tmp[i]),
			.a(aluSrc1[i]),
			.b(aluSrc2[i]),
			.invertA(invertA),
			.invertB(invertB),
			.operation(operation[1:0]),
			.carryIn(carryout_tmp[i-1]),
			.less(0)
  	  	);
      		end
  	endgenerate

	
	 ALU_1bit alu(
		.result(result[0]),
		.carryOut(carryout_tmp[0]),
		.a(aluSrc1[0]),
		.b(aluSrc2[0]),
		.invertA(invertA),
		.invertB(invertB),
		.operation(operation[1:0]),
		.carryIn(invertB),
		.less(set)
  	);
	
	assign overflow= (operation==2'b10) ? carryout_tmp[30]^carryout_tmp[31] : 0 ;
	/*if(operation==2'b10)
		overflow_check=carryout_tmp[30]^carryout_tmp[31];
	else
		overflow_check=0;
	*/
	assign zero= (result==32'b0) ? 1 : 0 ;
	/*if(result==32'b0)
		zero_check=1;
	else 
		zero_check=0;
	*/
	

	assign set=aluSrc1[31]+aluSrc2[31]+carryout_tmp[30];

	  
endmodule 