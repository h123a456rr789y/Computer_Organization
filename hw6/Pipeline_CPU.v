module Pipeline_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
wire [31:0] pc_str,pc_next;
wire [31:0] ins_spilt;
wire RegWrite,ALUsrc;
wire RegDst;
wire [3:0] ALUop;
wire RegWrite_mux,ALUsrc_mux;
wire RegDst_mux;
wire [3:0] ALUop_mux;
wire [4:0] ALUoperation;
wire [1:0] FURslt;
wire [31:0] signOut,zeroOut;
wire [31:0] mux2to1_2;
wire [31:0] ALU_res;
wire ALU_zero,ALU_over;
wire [31:0] Shift_res;
wire [31:0] Write_data;
wire [31:0] add1_o;
wire branch,memWrite,memRead,mem2Reg;
wire branchType,jump;
wire branch_mux,memWrite_mux,memRead_mux,mem2Reg_mux;
wire branchType_mux,jump_mux;

wire [31:0] DM_o;
wire and2,PCSrc;
wire [31:0] SL2_o;
wire [31:0] add2_o;
wire PC_w;
wire IF_IDsta;
wire [1:0] rs_sel;
wire [1:0] rt_sel;
wire [31:0] FW_rs_o;
wire [31:0] FW_rt_o;
wire [5:0] mux_ctrl_o;
wire X_Branch_o, X_MemWrite_o, X_MemRead_o, X_Mem2Reg_o, X_RegWrite_o, X_jump_o;
wire [31:0] ori_addr;
wire [31:0] m_o;

    //IF
wire [31:0] W_ins;
wire [31:0] W_PC;
wire [31:0] E_rs1;
wire [31:0] E_rt2;
    //ID
wire [31:0] X_PC;
wire [31:0] X_rs1;
wire [31:0] X_rt2;
wire [31:0] X_signEx;
wire [31:0] X_zero;
wire [31:0] X_instr;
wire X_ALUSrc;
wire [3:0] X_ALUOp;
wire X_RegDst;
wire X_BranchType;
wire X_Branch, X_MemWrite, X_MemRead, X_Mem2Reg, X_RegWritem,X_jump;
wire [4:0] D_addr;
wire [31:0] M_mux;
    //EX
wire [31:0] Y_PC;
wire [31:0] Y_rs1;
wire [31:0] Y_rt2;
wire [4:0] Y_addr;
wire Y_zero, Y_branch,Y_MemWrite, Y_MemRead,Y_jump, Y_Mem2Reg, Y_RegWrite;
wire [31:0] Y_m;
    //MEM
wire [4:0] Z_wrAddr;
wire Z_RegWrite;
wire [31:0] Z_rs1;
wire [31:0] Z_rt2;
wire Z_Mem2Reg;

///flush
wire IF_flush_o,ID_flush_o,EX_flush_o;

//modules

Program_Counter PC(    
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(pc_next) ,   
	    .pc_out_o(pc_str),
      .PC_write(PC_w) 
	    );
	
Adder Adder1(  
        .src1_i(pc_str),     
	    .src2_i(32'd4),
	    .sum_o(add1_o)    
	    );
	
Instr_Memory IM(        
        .pc_addr_i(pc_str),  
	    .instr_o(ins_spilt)    
	    );

IF_Reg IF_ID ( .clk_i(clk_i),   
               .rst_n(rst_n&&IF_flush_o), 
               .instr_i(ins_spilt), 
               .PC_i(add1_o), 
               .instr_o(W_ins), 
               .PC_o(W_PC),
               .IF_stall(IF_IDsta) 
             );

Mux2to1 #(.size(32)) Mux3(       
        .data0_i(add1_o),
        .data1_i(Y_PC),
        .select_i(PCSrc),
        .data_o(ori_addr)
        );  

Mux2to1 #(.size(32)) jump_mux4(       
        .data0_i(ori_addr),
        .data1_i(Y_m),
        .select_i(Y_jump),
        .data_o(pc_next)
        );



		
Reg_File RF(          
        .clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i(W_ins[25:21]) ,  
        .RTaddr_i(W_ins[20:16]) ,  
        .Wrtaddr_i(Z_wrAddr) ,  
        .Wrtdata_i(Write_data)  , 
        .RegWrite_i(Z_RegWrite),
        .RSdata_o(E_rs1) ,  
        .RTdata_o(E_rt2)   
        );
	
Decoder Decoder(        //F
        .instr_op_i(W_ins[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALUOp_o(ALUop),   
	    .ALUSrc_o(ALUsrc),   
	    .RegDst_o(RegDst),
            .Jump_o(jump),
            .Branch_o(branch),
            .BranchType_o(branchType),
            .MemWrite_o(memWrite),
            .MemRead_o(memRead), 
            .MemtoReg_o(mem2Reg)   
		);

HazardDetectionUnit hazard( .ID_memRead(X_MemRead), 
                            .Q_branch(PCSrc), 
                            .Y_jumpSelect(Y_jump),
                            .IF_rs(W_ins[25:21]), 
                            .IF_rt(W_ins[20:16]), 
                            .ID_rt(X_instr[20:16]), 
                            .IF_flush(IF_flush_o), 
                            .ID_flush(ID_flush_o), 
                            .EX_flush(EX_flush_o), 
                            .IF_stall(IF_IDsta),
                            .PC_write(PC_w)
                             );




Sign_Extend SE(         //H
        .data_i(W_ins[15:0]),
        .data_o(signOut)
        );

Zero_Filled ZF(         //I
        .data_i(W_ins[15:0]),
        .data_o(zeroOut)
        );

Mux2to1 #(.size(13)) control_i(       
        .data0_i({RegWrite,ALUsrc,RegDst,ALUop,branch,memWrite,memRead,mem2Reg,branchType,jump}),
        .data1_i(13'd0),
        .select_i(ID_flush_o),
        .data_o({RegWrite_mux,ALUsrc_mux,RegDst_mux,ALUop_mux,branch_mux,memWrite_mux,memRead_mux,mem2Reg_mux,branchType_mux,jump_mux})
        );  

ID_Reg ID_EX( .clk_i(clk_i),     //X
              .rst_n(rst_n), 
              .PC_i(W_PC), .PC_o(X_PC), 
              .rs1_i(E_rs1), .rs1_o(X_rs1), 
              .rt2_i(E_rt2), .rt2_o(X_rt2), 
              .signEx_i(signOut), .signEx_o(X_signEx), 
              .zero_i(zeroOut), .zero_o(X_zero), 
              .instr_i(W_ins), .instr_o(X_instr), 
              .ALUSrc_i(ALUsrc_mux), .ALUSrc_o(X_ALUSrc), 
              .ALUOp_i(ALUop_mux), .ALUOp_o(X_ALUOp), 
              .RegDst_i(RegDst_mux), .RegDst_o(X_RegDst), 
              .BranchType_i(branchType_mux), .BranchType_o(X_BranchType), 
              .Branch_i(branch_mux), .Branch_o(X_Branch), 
              .MemWrite_i(memWrite_mux), .MemWrite_o(X_MemWrite), 
              .MemRead_i(memRead_mux), .MemRead_o(X_MemRead),
              .Jump_i(jump_mux), .Jump_o(X_jump), 
              .Mem2Reg_i(mem2Reg_mux), .Mem2Reg_o(X_Mem2Reg), 
              .RegWrite_i(RegWrite_mux), .RegWrite_o(X_RegWrite) 
             );

Mux2to1 #(.size(6)) EX_signal_i(       
        .data0_i({X_jump,X_Branch,X_MemWrite,X_MemRead,X_Mem2Reg,X_RegWrite}),
        .data1_i(6'd0),
        .select_i(EX_flush_o),
        .data_o({X_jump_o,X_Branch_o,X_MemWrite_o,X_MemRead_o,X_Mem2Reg_o,X_RegWrite_o})
        );  

Forwarding forward(  .rs2521_alu(X_instr[25:21]), 
                .rt2016_alu(X_instr[20:16]), 
                .rd_ex(Y_addr), 
                .rd_mem(Z_wrAddr), 
                .RW_ex(Y_RegWrite), 
                .RW_wb(Z_RegWrite), 
                .rs_select(rs_sel), 
                .rt_select(rt_sel)
                 );


Mux3to1 #(.size(32)) FW_rt(      
        .data0_i(X_rt2),
        .data1_i(Y_rs1),
        .data2_i(Write_data),
        .select_i(rt_sel),
        .data_o(FW_rt_o)
        );

Mux2to1 #(.size(5)) MuxD(      
        .data0_i(X_instr[20:16]),
        .data1_i(X_instr[15:11]),
        .select_i(X_RegDst),
        .data_o(D_addr)
        );  



Mux3to1 #(.size(32)) FW_rs(      
        .data0_i(X_rs1),
        .data1_i(Y_rs1),
        .data2_i(Write_data),
        .select_i(rs_sel),
        .data_o(FW_rs_o)
        );



ALU_Ctrl AC(           
        .funct_i(X_instr[5:0]),   
        .ALUOp_i(X_ALUOp),   
        .ALU_operation_o(ALUoperation),
    .FURslt_o(FURslt)
        );
		
Mux2to1 #(.size(32)) ALU_src2Src(       
        .data0_i(FW_rt_o),
        .data1_i(X_signEx),
        .select_i(X_ALUSrc),
        .data_o(mux2to1_2)
        );	
		
ALU ALU(      
		.aluSrc1(FW_rs_o),
	  .aluSrc2(mux2to1_2),
	  .ALU_operation_i(ALUoperation),
		.result(ALU_res),
		.zero(ALU_zero),
		.overflow(ALU_over)
	    );
		
Shifter shifter(    
		.result(Shift_res), 
		.leftRight(ALUoperation[3]),
		.shamt(X_instr[10:6]),
		.sftSrc(mux2to1_2) 
		);

Mux3to1 #(.size(32)) Mux_Write_Reg(      
        .data0_i(ALU_res),
        .data1_i(Shift_res),
        .data2_i(X_zero),
        .select_i(FURslt),
        .data_o(M_mux)
        );	

assign and2 = (X_BranchType==0) ?ALU_zero :~ALU_zero;      

Shift_Left2 SL2(       
        .result(SL2_o),
        .sftSrc(X_signEx)
        );


Shift_Left2_j SL2j (       
        .result(m_o),
        .sftSrc(X_instr[25:0]),
        .old_PC(X_PC[31:28])
        );

Adder Adder2(   
        .src1_i(X_PC),     
            .src2_i(SL2_o),
            .sum_o(add2_o)    
            );	



EX_Reg EX_MEM( .clk_i(clk_i),    
               .rst_n(rst_n), 
               .PC_i(add2_o), .PC_o(Y_PC), 
               .rs1_i(M_mux), .rs1_o(Y_rs1), 
               .rt2_i(FW_rt_o), .rt2_o(Y_rt2), 
               .instr_i(D_addr), .instr_o(Y_addr), 
               .ALU_zero(and2), .ALU_zero_o(Y_zero),
               .jumpAddr_i(m_o), .jumpAddr_o(Y_m), 
               .Branch_i(X_Branch_o), .Branch_o(Y_branch), 
               .MemWrite_i(X_MemWrite_o), .MemWrite_o(Y_MemWrite), 
               .MemRead_i(X_MemRead_o), .MemRead_o(Y_MemRead),
               .Jump_i(X_jump_o), .Jump_o(Y_jump),  
               .Mem2Reg_i(X_Mem2Reg_o), .Mem2Reg_o(Y_Mem2Reg), 
               .RegWrite_i(X_RegWrite_o), .RegWrite_o(Y_RegWrite) 
             );

MEM_Reg MEM_WB( .clk_i(clk_i),   
                .rst_n(rst_n), 
                .rs1_i(DM_o), .rs1_o(Z_rs1), 
                .rt2_i(Y_rs1), .rt2_o(Z_rt2), 
                .instr_i(Y_addr), .instr_o(Z_wrAddr), 
                .Mem2Reg_i(Y_Mem2Reg), .Mem2Reg_o(Z_Mem2Reg), 
                .RegWrite_i(Y_RegWrite), .RegWrite_o(Z_RegWrite) 
              );


and G1(PCSrc,Y_branch,Y_zero);     



Data_Memory DM(      
        .clk_i(clk_i),
        .addr_i(Y_rs1),
        .data_i(Y_rt2),
        .MemRead_i(Y_MemRead),
        .MemWrite_i(Y_MemWrite),
        .data_o(DM_o)
        );



Mux2to1 #(.size(32)) lastMux(       
        .data0_i(Z_rt2),
        .data1_i(Z_rs1),
        .select_i(Z_Mem2Reg),
        .data_o(Write_data)
        );

endmodule



