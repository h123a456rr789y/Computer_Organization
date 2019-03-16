module Forwarding( rs2521_alu, rt2016_alu, rd_ex, rd_mem, RW_ex, RW_wb, rs_select, rt_select );

//I/O ports 
input [4:0] rs2521_alu;
input [4:0] rt2016_alu;
input [4:0] rd_ex;
input [4:0] rd_mem;
input RW_ex;
input RW_wb;


output [1:0] rs_select;
output [1:0] rt_select;

//Main function



assign rt_select = ((RW_wb)&&(rd_mem==rt2016_alu)) ?2 :(((RW_ex)&&(rd_ex==rt2016_alu))?1 :0);
assign rs_select = ((RW_wb)&&(rd_mem==rs2521_alu)) ?2 :(((RW_ex)&&(rd_ex==rs2521_alu))?1 :0);


endmodule
