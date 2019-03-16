module pipeline_reg(clk,rst,data_i,data_o);



input clk;
input rst;

parameter size = 0;


input wire	[size-1:0] data_i;
output [size-1:0] data_o;
reg [size-1:0] data_o;

always @(posedge clk,negedge rst) 
begin
	if(rst)
	   data_o<=data_i;
	else
	   data_o<=0; 
end

endmodule