module HazardDetectionUnit( ID_memRead, Q_branch, Y_jumpSelect, IF_rs, IF_rt, ID_rt, IF_flush, ID_flush, EX_flush, IF_stall,PC_write );

//I/O ports 
input	ID_memRead;
input	Q_branch;
input	Y_jumpSelect;
input [4:0]	IF_rs;
input [4:0]	IF_rt;
input [4:0]	ID_rt;

output  IF_flush;
output	ID_flush;
output  EX_flush;
output	IF_stall;
output	PC_write;


//Main function
assign  IF_flush = (Q_branch==1)||(Y_jumpSelect==1) ?0 :1;
assign  ID_flush = (Q_branch==1)||(Y_jumpSelect==1) ?1 :0;
assign  EX_flush = (Q_branch==1)||(Y_jumpSelect==1) ?1 :0;
assign  IF_stall = (ID_memRead && (ID_rt==IF_rt || ID_rt==IF_rs)) ?0 :1;
assign  PC_write = (ID_memRead && (ID_rt==IF_rt || ID_rt==IF_rs)) ?0 :1;


endmodule
