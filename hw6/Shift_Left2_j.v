module Shift_Left2_j( result, sftSrc, old_PC );

//I/O ports 
output	[32-1:0] result;

input	[25:0] sftSrc ;
input	[3:0] old_PC;

//Internal Signals
wire	[32-1:0] result;
wire	[25:0] sftSrc ;
wire	[3:0] old_PC;
  
//Main function
/*your code here*/
assign result = { old_PC, sftSrc, {2{1'b0}} };


endmodule