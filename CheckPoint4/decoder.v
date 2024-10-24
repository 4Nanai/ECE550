module decoder(
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
	
	input [31:0] ins; //32-bit instr
	output [4:0] opcode; //5-bit opcode
	output [4:0] ctrl_ALUop; //5-bit Alu opcade
	output [4:0] rd, rs, rt; //5-bit rd(dest), rs(src), rt(target)
	output [4:0] shamt; //5-bit shift amount
	output [16:0] imme_num; //17-bit immediate number
	output [26:0] ji_tar; //27-bit jump immediate (may not used in PC4)
	
	assign opcode = ins[31:27];
	assign ctrl_ALUop = ins[6:2];
	assign rd = ins[26:22];
	assign rs = ins[21:17];
	assign rt = ins[16:12];
	assign shamt = ins[11:7];
	assign imme_num = ins[16:0];
	assign ji_tar = ins[26:0];
	
endmodule

	
	
	