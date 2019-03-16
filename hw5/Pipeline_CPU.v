module Pipeline_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles


//modules
///////////////////////
wire [31:0] pc_in_i,pc_out_o, src2_i,instruction_number,instruction;
wire [4:0] Writereg;
wire RegDst_o;
wire [31:0] write_back_ans,aluSrc1,read_data2;
wire RegWrite_o;
wire [2:0] ALUOp_o;
wire ALUSrc_o;
wire [3:0] ALU_operation_o;
wire [1:0] FURslt_o;
wire [31:0] data_Zero_Filled,data_Sign_Extend, aluSrc2, result_alu;
wire zero;
wire overflow;
wire [31:0] result_shifter;
//////////////////////
wire Jump_o;
wire Branch_o;
wire BranchType_o;
wire MemWrite_o;
wire MemRead_o;
wire MemtoReg_o;

wire beq_or_bne;

wire branch;  //////for branch == 1

wire [31:0] addr_i;

wire [31:0] ans_data_mem;
wire [31:0]shift_left_jump;
wire [31:0]shift_left_branch;
wire [31:0] ans_branch_add;
wire [31:0] ans_branch;
wire [31:0] result_adder;

wire Jal_o ;
wire [4:0]JalToReg ;
wire [31:0]write_data ;
wire Jr_o;
wire [31:0]result_jump ;
wire [31:0] jalorwb ;

//			pipeline
wire [31:0] IF_ID_result_adder;
wire [31:0] instruction_ex;
wire [31:0] read_data1;
wire [1:0] WB;
wire [2:0] M;
wire [5:0] EX;
wire [1:0] ID_EX_WB;
wire [2:0] ID_EX_M;
wire [5:0] ID_EX_EX;
wire [31:0] ID_EX_result_adder;
wire [31:0] ID_EX_read_data2;
wire [31:0] ID_EX_data_Sign_Extend;
wire [31:0] ID_EX_data_Zero_Filled;
wire [20:0] ID_EX_instruction;
wire [1:0] EX_MEM_WB;
wire [2:0] EX_MEM_M;
wire [31:0] EX_MEM_ans_branch_add;
wire EX_MEM_beq_or_bne;
wire [31:0] EX_MEM_addr_i;
wire [31:0] EX_MEM_read_data2;
wire [4:0] EX_MEM_Writereg;
wire [1:0] MEM_WB_WB;
wire [31:0] MEM_WB_ans_data_mem;
wire [31:0] MEM_WB_addr_i;
wire [4:0] MEM_WB_Writereg;


Program_Counter PC(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(pc_in_i) ,   
	    .pc_out_o(pc_out_o) 
	    );

Adder Adder1(
        .src1_i(pc_out_o),     
	    .src2_i(32'd4),
	    .sum_o(result_adder)    
	    );
		


pipeline_reg #(.size(32)) IF_ID_1(
			.clk(clk_i),
			.rst(rst_n),
			.data_i(result_adder),
			.data_o(IF_ID_result_adder)
			);
		
		

Instr_Memory IM(
        .pc_addr_i(pc_out_o),  
	    .instr_o(instruction_ex)    
	    );



pipeline_reg #(.size(32)) IF_ID_2(
			.clk(clk_i),
			.rst(rst_n),
			.data_i(instruction_ex),
			.data_o(instruction)
			);
		
		

Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(ID_EX_instruction[20:16]),
        .data1_i(ID_EX_instruction[15:11]),
        .select_i(ID_EX_EX[5]),
        .data_o(Writereg)
        );	
		
		
Reg_File RF(
        .clk_i(clk_i),      
	.rst_n(rst_n) ,     
        .RSaddr_i(instruction[25:21]) ,  
        .RTaddr_i(instruction[20:16]) ,  
        .Wrtaddr_i(MEM_WB_Writereg) ,  		 ///from wb
        .Wrtdata_i(write_back_ans)  ,	 ///write back
        .RegWrite_i(MEM_WB_WB[1]), 	 ///from decoder
        .RSdata_o(read_data1) ,  	//aluSrc1
        .RTdata_o(read_data2)   
        );
		

Decoder Decoder(     ////new decoder
        	.instr_op_i(instruction[31:26]),
		.Jump_o(Jump_o),
	    	.RegWrite_o(RegWrite_o), 
	    	.ALUOp_o(ALUOp_o),   
	    	.ALUSrc_o(ALUSrc_o),
		.Branch_o(Branch_o),
		.BranchType_o(BranchType_o),
		.MemWrite_o(MemWrite_o),
		.MemRead_o(MemRead_o),
		.MemtoReg_o(MemtoReg_o),
	    	.RegDst_o(RegDst_o),
        	.Jal_o(Jal_o)		
	);
		

assign WB={RegWrite_o,MemtoReg_o};					
assign M={Branch_o,MemRead_o,MemWrite_o};				
assign EX={RegDst_o,BranchType_o,ALUOp_o,ALUSrc_o};	


/////////////    ID/EX

pipeline_reg #(.size(2)) ID_EX_1(
			.clk(clk_i),
			.rst(rst_n),
			.data_i(WB),
			.data_o(ID_EX_WB)
			);
			
pipeline_reg #(.size(3)) ID_EX_2(
			.clk(clk_i),
			.rst(rst_n),
			.data_i(M),
			.data_o(ID_EX_M)
			);
			
pipeline_reg #(.size(6)) ID_EX_3(
			.clk(clk_i),
			.rst(rst_n),
			.data_i(EX),
			.data_o(ID_EX_EX)
			);


pipeline_reg #(.size(32)) ID_EX_4(                   
			.clk(clk_i),
			.rst(rst_n),
			.data_i(IF_ID_result_adder),
			.data_o(ID_EX_result_adder)
			);
pipeline_reg #(.size(32)) ID_EX_5(                 
			.clk(clk_i),
			.rst(rst_n),
			.data_i(read_data1),
			.data_o(aluSrc1)
			);
pipeline_reg #(.size(32)) ID_EX_6(                  
			.clk(clk_i),
			.rst(rst_n),
			.data_i(read_data2),
			.data_o(ID_EX_read_data2)
			);
pipeline_reg #(.size(32)) ID_EX_7(            
			.clk(clk_i),
			.rst(rst_n),
			.data_i(data_Sign_Extend),
			.data_o(ID_EX_data_Sign_Extend)
			);
pipeline_reg #(.size(32)) ID_EX_8(                 
			.clk(clk_i),
			.rst(rst_n),
			.data_i(data_Zero_Filled),
			.data_o(ID_EX_data_Zero_Filled)
			);
			
			
pipeline_reg #(.size(21)) ID_EX_9(
			.clk(clk_i),
			.rst(rst_n),
			.data_i(instruction[20:0]),
			.data_o(ID_EX_instruction)
			);


 		

ALU_Ctrl AC(
        .funct_i(ID_EX_instruction[5:0]),   
        .ALUOp_i(ID_EX_EX[3:1]),   
        .ALU_operation_o(ALU_operation_o),
	.FURslt_o(FURslt_o),
	.Jr_o(Jr_o)
        );
		
Sign_Extend SE(
        .data_i(instruction[15:0]),
        .data_o(data_Sign_Extend)
        );
		
Zero_Filled ZF(
        .data_i(instruction[15:0]),
        .data_o(data_Zero_Filled)
        );
		

Mux2to1 #(.size(32)) ALU_src2Src(    //////before alu
        .data0_i(ID_EX_read_data2),
        .data1_i(ID_EX_data_Sign_Extend),
        .select_i(ID_EX_EX[0]),
        .data_o(aluSrc2)
        );	
		
Mux2to1 #(.size(1)) beq(    //////after alu
        .data0_i(zero),
        .data1_i(~zero),
        .select_i(ID_EX_EX[4]),
        .data_o(beq_or_bne)
        );	
		



assign branch = EX_MEM_M[2] && EX_MEM_beq_or_bne;


Mux2to1 #(.size(32)) ex_pc(    ////// pc
        .data0_i(result_adder),
        .data1_i(EX_MEM_ans_branch_add),
        .select_i(branch),
        .data_o(pc_in_i)
        );



ALU ALU(
		.aluSrc1(aluSrc1),
	    	.aluSrc2(aluSrc2),
	    	.ALU_operation_i(ALU_operation_o),
		.result(result_alu),
		.zero(zero),
		.overflow(overflow)
	  );
		

Shifter shifter( 
		.result(result_shifter), 
		.leftRight(~ID_EX_instruction[1]),
		.shamt(ID_EX_instruction[10:6]),
		.sftSrc(aluSrc2) 
		);

Mux3to1 #(.size(32)) RDdata_Source(
        .data0_i(result_alu),
        .data1_i(result_shifter),
	.data2_i(ID_EX_data_Zero_Filled),
        .select_i(FURslt_o),
        .data_o(addr_i)
        );
		

///////////               EX/MEM

pipeline_reg #(.size(2)) EX_MEM_1(                   
			.clk(clk_i),
			.rst(rst_n),
			.data_i(ID_EX_WB),
			.data_o(EX_MEM_WB)
			);
pipeline_reg #(.size(3)) EX_MEM_2(                 
			.clk(clk_i),
			.rst(rst_n),
			.data_i(ID_EX_M),
			.data_o(EX_MEM_M)
			);



pipeline_reg #(.size(32)) EX_MEM_3(                  
			.clk(clk_i),
			.rst(rst_n),
			.data_i(ans_branch_add),
			.data_o(EX_MEM_ans_branch_add)
			);

pipeline_reg #(.size(1)) EX_MEM_4(             
			.clk(clk_i),
			.rst(rst_n),
			.data_i(beq_or_bne),
			.data_o(EX_MEM_beq_or_bne)
			);
pipeline_reg #(.size(32)) EX_MEM_5(                 
			.clk(clk_i),
			.rst(rst_n),
			.data_i(addr_i),
			.data_o(EX_MEM_addr_i)
			);
			
			
pipeline_reg #(.size(32)) EX_MEM_6(
			.clk(clk_i),
			.rst(rst_n),
			.data_i(ID_EX_read_data2),
			.data_o(EX_MEM_read_data2)
			);
pipeline_reg #(.size(5)) EX_MEM_7(                 
			.clk(clk_i),
			.rst(rst_n),
			.data_i(Writereg),
			.data_o(EX_MEM_Writereg)
			);
			
			



Data_Memory DM(	
		.clk_i(clk_i),
		.addr_i(EX_MEM_addr_i), 
		.data_i(EX_MEM_read_data2), 
		.MemRead_i(EX_MEM_M[1]), 
		.MemWrite_i(EX_MEM_M[0]), 
		.data_o(ans_data_mem)
		);
		
		
//////////             MEM/WB


pipeline_reg #(.size(2)) MEM_WB_1(                   
			.clk(clk_i),
			.rst(rst_n),
			.data_i(EX_MEM_WB),
			.data_o(MEM_WB_WB)
			);

pipeline_reg #(.size(32)) MEM_WB_2(                 
			.clk(clk_i),
			.rst(rst_n),
			.data_i(ans_data_mem),
			.data_o(MEM_WB_ans_data_mem)
			);

pipeline_reg #(.size(32)) MEM_WB_3(                  
			.clk(clk_i),
			.rst(rst_n),
			.data_i(EX_MEM_addr_i),
			.data_o(MEM_WB_addr_i)
			);

pipeline_reg #(.size(5)) MEM_WB_4(             
			.clk(clk_i),
			.rst(rst_n),
			.data_i(EX_MEM_Writereg),
			.data_o(MEM_WB_Writereg)
			);





Mux2to1 #(.size(32)) after_data_mem(    		//////after datamemeory
        .data0_i(MEM_WB_addr_i),                                         
        .data1_i(MEM_WB_ans_data_mem),
        .select_i(MEM_WB_WB[0]),
        .data_o(write_back_ans)
        );	
		


assign shift_left_jump = {{result_adder[31:28]},{ID_EX_instruction[25:0]},{2'b00}};



Shifter branch_Shifter( 
		.result(shift_left_branch), 
		.leftRight(1'b1),
		.shamt(5'd2),
		.sftSrc(ID_EX_data_Sign_Extend) 
		);



Adder Adder2(
        .src1_i(ID_EX_result_adder),     
	    .src2_i(shift_left_branch),
	    .sum_o(ans_branch_add)    //ans_branch_add 
	    );














endmodule