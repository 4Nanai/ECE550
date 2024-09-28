module data_path #(parameter DWIDTH = 32)(
	clk,
	clk_imem, //clk for imem
	clk_dmem, //clk for dmem
	rst,
	en_pc,
	en_imem_rd,
	en_dmem_rd,
	en_dmem_wr,
	en_writeReg,
	sel_Reg_t,
	sel_alu_dataB,
	sel_writeReg,
	ctrl_Beq,
	ctrl_Blt,
	ctrl_ji,
	ctrl_jal,
	ctrl_jr
);

	input clk, rst, clk_imem ,clk_dmem;
	input en_pc, //enable signal for pc 
		en_imem_rd, //enable instr mem read
		en_dmem_rd, //enable data mem read
		en_dmem_wr, //enable data mem write
		en_writeReg, //enable write register file
		
		//[opcode -> immediate number] => 
		//sel_Reg_t & sel_alu_dataB = 1
		sel_Reg_t, //select ctrl_writeReg btwn rd(0) & rt(1)
		sel_alu_dataB, //select alu_dataB btwn regDataB(0) & ext_imme_num(1)
		
		//[opcode -> lw] =>
		//sel_writeReg = 1
		sel_writeReg, //select data_writeReg btwn alu_out(0) & dmem_out(1)
		
		//[opcode -> beq] =>
		//ctrl_Beq = 1
		ctrl_Beq, //ctrl pc to jump if dataA == dataB
		
		//[opcode -> ji] =>
		//ctrl_ji = 1
		ctrl_ji, //ctrl pc to jump to immediate number[25:0]
		
		//[opcode -> jal && ctrl_ji == 1] =>
		//ctrl_jal = 1
		ctrl_jal, //Japanese airline(x)
		
		//[opcode -> jr] =>
		//ctrl_jal = 1
		ctrl_jr, //jump register $d (ctrl_readRegB = rd)
		
		//[opcode -> beq] =>
		//ctrl_Beq = 1
		ctrl_Blt; //jump to pc = pc + 1 + N if dataA < dataB
		
		
		
		
		
	
	
	
	
	/* instantiate pc */
	wire [DWIDTH - 1:0] pc_in, pc_out;
	
	pc pc_i(
		.clk(clk),
		.rst(rst),
		.en_pc(en_pc),
		.pc_in(pc_in),
		.pc_out(pc_out)
	);
	/* end of pc instantiation */
	
	//PC addself by 1
	wire [DWIDTH - 1: 0] pcSelfAdd,
		pcAddImme_cndt, //conditional branch jump to 16-bit imme_num
		cndt_jump; 
	wire in_sel_beqJump;
	
	adder_32bit pc_selfAdder_i(
		.a(pc_out), 
		.b(32'd1), 
		.c_in(0), 
		.sum(pcSelfAdd)
		);
	/* end of PC addself */
	
	//implement branch equal
	adder_32bit pc_immeAdder(
		.a(pcSelfAdd), 
		.b(ext_imme_num), 
		.c_in(0), 
		.sum(pcAddImme_cndt)
	);
	and (in_sel_beqJump, ctrl_Beq, isEqual);
	assign cndt_jump = in_sel_isBranch? pcAddImme_cndt: pcSelfAdd;
	//assign pc_in = cndt_jump;
	//end of beq implementation
	
	//implemet branch less than
	wire in_sel_bltJump, in_sel_isBranch;
	and (in_sel_bltJump, ctrl_Blt, isLessThan);
	or (in_sel_isBranch, in_sel_bltJump, in_sel_beqJump);
	//end of blt
	
	//implement Jump Immed_num[25:0]
	wire [DWIDTH - 1:0] ext_ji_imme_num;
	assign ext_ji_imme_num = ji_tar[25]? {{6{1'b1}}, ji_tar}: {6'd0, ji_tar};
	//assign pc_in = ctrl_ji? ext_ji_imme_num: cndt_jump;
	//end of ji implementation
	
	//implement Jal (store pc+1 then ji)
	assign ctrl_writeReg = ctrl_jal? 5'd31: sel_Reg_t? rt: rd;
	assign data_writeReg = ctrl_jal? pcSelfAdd: data_writeBack;
	//end of Jal
	
	//implement jr (jump to addr in register $d)
	assign ctrl_readRegB = ctrl_jr? rd: rt;
	assign pc_in = ctrl_jr? data_readRegB: ctrl_ji? ext_ji_imme_num: cndt_jump;
	//end of jr
	

	
	
	
	
	
	
	
	
	
	/* instantiate instr mem */
	wire en_imem_rd, clk_imem;
	wire [DWIDTH - 1:0] ins;
	
	imem imem_i(
		.address(pc_out[11:0]),
		.clock(clk_imem),
		.rden(en_imem_rd),
		.q(ins)
	);
	
	/* end of imem instantiation */

	
	
	
	
	/* instantiate decoder */
	wire [5:0] opcode;
	wire [4:0] ctrl_ALUop, rd, rs, rt, shamt;
	wire [15:0] imme_num;
	wire [25:0] ji_tar;
	
	decoder decoder_i(
		/* Input ports */
		ins,
		/* Output ports */
		opcode,
		ctrl_ALUop,
		rd,
		rs,
		rt,
		shamt,
		imme_num,
		ji_tar
	);
	
	/* end of decoder instantiation*/

	
	
	
	
	
	/* instantiate regFile */
	wire en_writeReg;
	wire [4:0] ctrl_writeReg, ctrl_readRegB;
	wire [DWIDTH - 1:0] data_writeReg, data_readRegA, data_readRegB;
	
	regfile regfile_i(
	.clock(clk), 
	.ctrl_writeEnable(en_writeReg), 
	.ctrl_reset(rst), 
	.ctrl_writeReg(ctrl_writeReg), //assigned in jal
	.ctrl_readRegA(rs), 
	.ctrl_readRegB(ctrl_readRegB), 
	.data_writeReg(data_writeReg), 
	.data_readRegA(data_readRegA),
	.data_readRegB(data_readRegB)
	);
	//implement addi (mux_5_in_1 & imme_ext)
	//input sel_Reg_t; //select ctrl_writeReg btwn rd(0) & rt(1)
	
	//	mux_5_in_1 mux_writeReg(
	//		.in0(rd), 
	//		.in1(rt), 
	//		.s(sel_Reg_t), 
	//		.out(ctrl_writeReg)
	//	);

	wire [DWIDTH - 1:0] ext_imme_num;
	signExt imme_sign_ext(
		.imme_num(imme_num),
		.imme_num_ex(ext_imme_num)
	);
	//end of addi reg part (see alu part)
	
	/* end of regFile instantiation */
	
	
	
	
	
	
	

	/* instantiate alu */
	wire isNotEqual, isLessThan, overflow;
	wire [DWIDTH - 1:0] alu_dataA, alu_dataB, alu_dataOut;
	assign alu_dataA = data_readRegA;
	alu alu_i(
		.data_operandA(alu_dataA), 
		.data_operandB(alu_dataB), 
		.ctrl_ALUopcode(ctrl_ALUop), 
		.ctrl_shiftamt(shamt), 
		.data_result(alu_dataOut), 
		.isNotEqual(isNotEqual), 
		.isLessThan(isLessThan), 
		.overflow(overflow)
		);
	wire isEqual;
	not (isEqual, isNotEqual);
	//implement addi
	//input sel_alu_dataB; //select alu dataB port
	mux_32_in_1 mux_alu_dataB(
		.in0(data_readRegB),
		.in1(ext_imme_num),
		.s(sel_alu_dataB),
		.out(alu_dataB)
	);
	//end of addi part alu
	/* end of alu instantiation */
	
	
	
	
	
	
	/* instantiate data memory */
	wire [DWIDTH - 1:0] dmem_in, dmem_out, data_writeBack;
	assign dmem_in = data_readRegB;
	dmem dmem_i(
		.aclr(rst),
		.address(alu_dataOut),
		.clock(clk_dmem),
		.data(dmem_in),
		.rden(en_dmem_rd),
		.wren(en_dmem_wr),
		.q(dmem_out)
	);
	//implement load instr (mux_alu_dmem)
	mux_32_in_1 mux_alu_dmem(
		.in0(alu_dataOut),
		.in1(dmem_out),
		.s(sel_writeReg),
		.out(data_writeBack) //write back to register
	);
	//end of load instr implementation
	/* end of dmem instantiation */
	
	
	
	
	
endmodule
