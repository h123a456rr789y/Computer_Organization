module ALU_last( result, overflow, set, a, b, invertA, invertB, operation, carryIn, less );
  
  output wire result;
  output wire overflow;
	output wire set;
  
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

	/* Add/subtract */
	wire carryOut;
	Full_adder g1(add_sum, carryOut, carryIn, aa, bb);

	assign result= (operation==2'b10) ? add_sum :
			   (operation==2'b00) ? aa & bb:
			   (operation==2'b01) ? aa | bb:
			   (operation==2'b11) ? less :
			   0;

	/* Overflow & set */
	xor g2(overflow, carryIn, carryOut);
	xor g3(set, add_sum, overflow);

endmodule