module Simple_Single_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
wire	[31:0]instruction,regWriteData,readData1,readData2,Alu_result,Shifter_result;
wire	RegWrite,AluSrc,RegDst;
wire	[2:0]AluOp;
wire	[31:0]signExtend_tmp,zeroFilled_tmp;
//modules
wire [31:0]pc,pc_next;
Program_Counter PC(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(pc_next) ,   
	    .pc_out_o(pc) 
	    );
	
Adder Adder1(
        .src1_i(pc),     
	    .src2_i(32'd4),
	    .sum_o(pc_next)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc),  
	    .instr_o(instruction)    
	    );

wire [4:0]writeReg_addr;
Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instruction[20:16]),
        .data1_i(instruction[15:11]),
        .select_i(RegDst),
        .data_o(writeReg_addr)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i(instruction[25:21]) ,  
        .RTaddr_i(instruction[20:16]) ,  
        .RDaddr_i(writeReg_addr) ,  
        .RDdata_i(regWriteData)  , 
        .RegWrite_i(RegWrite),
        .RSdata_o(readData1) ,  
        .RTdata_o(readData2)   
        );
	
Decoder Decoder(
        .instr_op_i(instruction[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALUOp_o(AluOp),   
	    .ALUSrc_o(AluSrc),   
	    .RegDst_o(RegDst)   
		);

wire	[3:0]Alu_op;
wire	[1:0]FURslt;
ALU_Ctrl AC(
        .funct_i(instruction[5:0]),   
        .ALUOp_i(AluOp),   
        .ALU_operation_o(Alu_op),
		.FURslt_o(FURslt)
        );
	
Sign_Extend SE(
        .data_i(instruction[15:0]),
        .data_o(signExtend_tmp)
        );

Zero_Filled ZF(
        .data_i(instruction[15:0]),
        .data_o(zeroFilled_tmp)
        );

wire [31:0]Alu_input;	
Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(readData2),
        .data1_i(signExtend_tmp),
        .select_i(AluSrc),
        .data_o(Alu_input)
        );	
		
ALU ALU(
		.aluSrc1(readData1),
	    .aluSrc2(Alu_input),
	    .ALU_operation_i(Alu_op),
		.result(Alu_result),
		.zero(),
		.overflow()
	    );
wire	[4:0]shift_tmp;
Mux2to1 #(.size(5)) Mux_Shift_v(
        .data0_i(instruction[10:6]),
        .data1_i(readData1),
        .select_i(Alu_op[1]),
        .data_o(shift_tmp)
        );
Shifter shifter( 
		.result(Shifter_result), 
		.leftRight(Alu_op[0]),
		.shamt(shift_tmp),
		.sftSrc(Alu_input) 
		);
		
Mux3to1 #(.size(32)) RDdata_Source(
        .data0_i(Alu_result),
        .data1_i(Shifter_result),
		.data2_i(zeroFilled_tmp),
        .select_i(FURslt),
        .data_o(regWriteData)
        );			


endmodule




