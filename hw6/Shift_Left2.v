module Shift_Left2( result, sftSrc );

//I/O ports 
output	[32-1:0] result;

input	[32-1:0] sftSrc ;

//Internal Signals
wire	[32-1:0] result;
  
//Main function
/*your code here*/
assign result = sftSrc<<2;

endmodule