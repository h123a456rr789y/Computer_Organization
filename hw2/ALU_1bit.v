module ALU_1bit( result, carryOut, a, b, invertA, invertB, operation, carryIn, less ); 
  
  	output wire result;
  	output wire carryOut;
  
  	input wire a;
  	input wire b;
  	input wire invertA;
  	input wire invertB;
  	input wire[1:0] operation;
  	input wire carryIn;
  	input wire less;
	
	
	wire  aa,bb,add_sum,result_tmp;

	assign aa= (invertA==1'b0) ? a : ~a;
	assign bb = (invertB==1'b0) ? b : ~b;
	/*
  	case(invertA)
	1'b0:aa=a;
	1'b1:aa=~a;
	endcase

  	case(invertB)
	1'b0:bb=b;
	1'b1:bb=~b;
  	endcase
	*/

	
 	Full_adder add(
		.sum(add_sum),
		.carryOut(carryOut),
		.carryIn(carryIn),
		.input1(aa),
		.input2(bb)
  	);


	assign result= (operation==2'b10) ? add_sum :
			   (operation==2'b00) ? aa & bb:
			   (operation==2'b01) ? aa | bb:
			   (operation==2'b11) ? less :
			   0;
	/*		
	case(operation)
	2'b10:result_tmp=add_sum;
	2'b00:result_tmp=aa&bb;
	2'b01:result_tmp=aa|bb;
	2'b11:result_tmp=less;
	*/
  
  
  
endmodule 