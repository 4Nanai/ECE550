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
	
	input [31:0] ins;
	output [5:0] opcode;
	output [5:0] ctrl_ALUop;
	output [4:0] rd, rs, rt;
	output [4:0] shamt;
	output [15:0] imme_num;
	output [25:0] ji_tar;
	
	assign opcode = ins[31:26];
	assign ctrl_ALUop = ins[5:0];
	assign rs = ins[25:21];
	assign rt = ins[20:16];
	assign rd = ins[15:11];
	assign shamt = ins[10:6];
	assign imme_num = ins[15:0];
	assign ji_tar = ins[25:0];
	
endmodule

	
	
	