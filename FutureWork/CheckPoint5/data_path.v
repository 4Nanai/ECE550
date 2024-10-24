module data_path #(parameter DWIDTH = 32)(
	clk,
	
	/* control signal input*/
	rst,
	en_pc,
	sel_alu_dataB,
	sel_writeReg,
	ctrl_sw,
	ctrl_addi,
	is_alu,
	ctrl_Bne,
	ctrl_Blt,
	ctrl_ji,
	ctrl_jal,
	ctrl_jr,
	
	/* pc_out and ins(input) <-> processor.v -> skeleton.v (imem_i) */
	pc_out, //address_imem = pc_out[11:0]
	ins, // q_imem
	
	/* dmem_i */
	dmem_in, //output to processor.v (data)
	dmem_out, // input from processor.v (q_dmem)
	alu_dataOut, //ouput to processor.v (address_dmem)
	
	/* Register Group */
	//en_writeReg, //en_writeReg should be implemented in processor.v
	ctrl_writeReg,
	ctrl_readRegB,
	//ctrl_readRegA = rs
	data_writeReg, //data_writeReg
	data_readRegA, //data_readRegA
	data_readRegB, //data_readRegB
	
	
	/* output from decoder in data_path.v */
	opcode, 
	rs
);

	input clk, rst;
	input [DWIDTH - 1:0] ins; //ins read from upper level imem
	output [DWIDTH - 1:0] dmem_in, alu_dataOut;
	input [DWIDTH - 1:0] dmem_out;
	input en_pc, //enable signal for pc 
		//en_writeReg, //enable write register file (now it is output)
		
		//[opcode -> immediate number] => 
		//sel_alu_dataB = 1
		sel_alu_dataB, //select alu_dataB btwn regDataB(0) & ext_imme_num(1)
		
		//[opcode -> lw] =>
		//sel_writeReg = 1
		sel_writeReg, //select data_writeReg btwn alu_out(0) & dmem_out(1)

		//[opcode -> sw] =>
		//ctrl_sw = 1
		ctrl_sw, //ctrl if handle store word

		//is add immed num?
		//if is ALUopcode = 0;
		ctrl_addi,

		//is handle ALU? (opcode = 00000)
		is_alu,
		
		//[opcode -> bne] =>
		//ctrl_Bne = 1
		ctrl_Bne, //ctrl pc to jump if dataA == dataB
		
		//[opcode -> ji] =>
		//ctrl_ji = 1
		ctrl_ji, //ctrl pc to jump to immediate number[25:0]
		
		//[opcode -> jal && ctrl_ji == 1] =>
		//ctrl_jal = 1
		ctrl_jal, //Japanese airline(x)
		
		//[opcode -> jr] =>
		//ctrl_jr = 1
		ctrl_jr, //jump register $d (ctrl_readRegB = rd)
		
		//[opcode -> bne] =>
		//ctrl_Bne = 1
		ctrl_Blt; //jump to pc = pc + 1 + N if dataA < dataB
		
		
		
	
	output [4:0] opcode, rs;
	output [DWIDTH - 1:0] pc_out; //out to upper level imem
	/* input & output wire for register in processor.v */
	output [4:0] ctrl_writeReg, //ctrl_writeReg
					ctrl_readRegB; //ctrl_readRegB
	output [DWIDTH - 1:0] data_writeReg;
	input [DWIDTH - 1:0] data_readRegA, data_readRegB;
	




	wire [4:0] rd, rt; //declaration of dest reg & targ reg
	wire [DWIDTH - 1: 0] data_writeBack; //data write back to regfile
	wire [26:0] ji_tar; //ji target immed number




	/* instantiate pc */
	wire [DWIDTH - 1:0] pc_in;
	
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
		cndt_branch; 
	wire in_sel_beqJump;
	
	adder_32bit pc_selfAdder_i(
		.a(pc_out), 
		.b(32'd1), 
		.c_in(0), 
		.sum(pcSelfAdd)
		);
	/* end of PC addself */
	
	//implement branch not equal (not used in PC4)
	wire [DWIDTH - 1:0] ext_imme_num;
	adder_32bit pc_immeAdder(
		.a(pcSelfAdd), 
		.b(ext_imme_num), 
		.c_in(0), 
		.sum(pcAddImme_cndt)
	);
	wire in_sel_isBranch; //internal sel signal if is branch
	wire isNotEqual, isLessThan;
	and (in_sel_beqJump, ctrl_Bne, isNotEqual);
	assign cndt_branch = in_sel_isBranch? pcAddImme_cndt: pcSelfAdd;
	//assign pc_in = cndt_branch;
	//end of beq implementation
	
	//implemet branch less than (not used in PC4)
	wire in_sel_bltJump;
	and (in_sel_bltJump, ctrl_Blt, isLessThan);
	or (in_sel_isBranch, in_sel_bltJump, in_sel_beqJump);
	//end of blt
	
	//implement Jump Immed_num[25:0] (not used in PC4)
	wire [DWIDTH - 1:0] ext_ji_imme_num;
	/* Do sign extention for jump imme_number */
	assign ext_ji_imme_num = ji_tar[26]? {{5{1'b1}}, ji_tar}: {5'd0, ji_tar};
	//assign pc_in = ctrl_ji? ext_ji_imme_num: cndt_branch;
	//end of ji implementation
	
	//implement Jal (store pc+1 then ji) (not used in PC4)
	wire overflow, is_add, is_sub; //implement overflow write $rstatus
	assign ctrl_writeReg = ctrl_jal? 5'd31:(overflow & (is_add | is_sub | ctrl_addi))? 5'd30: rd;
	assign data_writeReg = ctrl_jal? pcSelfAdd: data_writeBack;
	//set ctrl_ji = 1 to jump imme_num
	//end of Jal
	
	//implement jr (jump to addr in register $d) (not used in PC4)
	//ctrl_jr also helps in sw(sw needs to read $rd)
	assign ctrl_readRegB = (ctrl_jr | ctrl_sw)? rd: rt;
	assign pc_in = ctrl_jr? data_readRegB: ctrl_ji? ext_ji_imme_num: cndt_branch;
	//end of jr
	

	
	
	
	
	
	
	
	
	
	/* instantiate instr mem */
//	wire en_imem_rd, clk_imem;
//	wire [DWIDTH - 1:0] ins;
//	
//	imem imem_i(
//		.address(pc_out[11:0]),
//		.clock(clk_imem),
//		.rden(en_imem_rd),
//		.q(ins)
//	);
	
	/* end of imem instantiation */

	
	
	
	
	/* instantiate decoder */
	
	wire [16:0] imme_num;
	wire [4:0] ctrl_ALUop, shamt, sel_ALUop;
	
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
	wire [4:0] ctrl_writeReg, ctrl_readRegB;
	wire [DWIDTH - 1:0] data_writeReg, data_readRegA, data_readRegB;
	
//	regfile regfile_i(
//	.clock(clk), 
//	.ctrl_writeEnable(en_writeReg), 
//	.ctrl_reset(rst), 
//	.ctrl_writeReg(ctrl_writeReg), //assigned in jal
//	.ctrl_readRegA(rs), 
//	.ctrl_readRegB(ctrl_readRegB), 
//	.data_writeReg(data_writeReg), 
//	.data_readRegA(data_readRegA),
//	.data_readRegB(data_readRegB)
//	);


	/* mux_5_in_1 was implemented by assign ?: */
	//implement addi (mux_5_in_1 & imme_ext)
	//input sel_Reg_t; //select ctrl_writeReg btwn rd(0) & rt(1)
	
	//	mux_5_in_1 mux_writeReg(
	//		.in0(rd), 
	//		.in1(rt), 
	//		.s(sel_Reg_t), 
	//		.out(ctrl_writeReg)
	//	);

	
	signExt imme_sign_ext(
		.imme_num(imme_num),
		.imme_num_ex(ext_imme_num)
	);
	//end of addi reg part (see alu part)
	
	/* end of regFile instantiation */
	
	
	
	
	
	
	

	/* instantiate alu */
	wire [DWIDTH - 1:0] alu_dataA, alu_dataB, alu_dataOut, alu_dmem_data;
	assign alu_dataA = data_readRegA;
	assign sel_ALUop = ctrl_addi? 5'd0: ctrl_ALUop;

	and is_alu_add(
		is_add,
		is_alu,
		~ctrl_ALUop[0],
		~ctrl_ALUop[1],
		~ctrl_ALUop[2]
	);

	and is_alu_sub(
		is_sub,
		is_alu,
		ctrl_ALUop[0],
		~ctrl_ALUop[1],
		~ctrl_ALUop[2]
	);

	assign data_writeBack = (overflow & ctrl_addi)? 32'd2: (overflow & is_add)? 32'd1: (overflow & is_sub)? 32'd3: alu_dmem_data;
	

	alu alu_i(
		.data_operandA(alu_dataA), 
		.data_operandB(alu_dataB), 
		.ctrl_ALUopcode(sel_ALUop), 
		.ctrl_shiftamt(shamt), 
		.data_result(alu_dataOut), 
		.isNotEqual(isNotEqual), 
		.isLessThan(isLessThan), 
		.overflow(overflow)
		);
	/* Implement bne instead of beq */
//	wire isEqual;
//	not (isEqual, isNotEqual);

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
	wire [DWIDTH - 1:0] dmem_in, dmem_out;
	assign dmem_in = data_readRegB; //write data in register B into dmem
//	dmem dmem_i(
//		.aclr(rst),
//		.address(alu_dataOut),
//		.clock(clk_dmem),
//		.data(dmem_in),
//		.rden(en_dmem_rd),
//		.wren(en_dmem_wr),
//		.q(dmem_out)
//	);
	//implement load instr (mux_alu_dmem)
	mux_32_in_1 mux_alu_dmem(
		.in0(alu_dataOut),
		.in1(dmem_out),
		.s(sel_writeReg),
		.out(alu_dmem_data) //write back to register
	);
	//end of load instr implementation
	/* end of dmem instantiation */
	
	
	
	
endmodule
