module IF_Reg( clk_i, rst_n, instr_i, PC_i, instr_o, PC_o, IF_stall );

//I/O ports
input           clk_i;
input           rst_n;
input  [32-1:0] instr_i;
input  [32-1:0] PC_i;
input			IF_stall;

output reg [32-1:0] instr_o;
output reg [32-1:0] PC_o;   

//Writing data when postive edge clk_i was set.
always @( posedge clk_i  ) begin
    if(rst_n == 0) begin
	    instr_o <= 0;
	    PC_o <= 0;
	end
	else if(IF_stall == 0) begin
	    instr_o <= instr_o;
	    PC_o <= PC_o;
	end
    else begin
    	instr_o <= instr_i;
	    PC_o <= PC_i;
	end
end

endmodule
