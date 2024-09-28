// Isn't needed in 1 ins/cycle cpu
// Prepared for pipeline

module ir #(parameter DWIDTH = 32)( // Instruction Register
	clk,
	rst,
	en_ir,
	ins,
	ir_out
);

	input clk, rst, en_ir;
	input [DWIDTH - 1: 0] ins;
	output [DWIDTH - 1: 0] ir_out;
	
	genvar i;
	generate
		for (i = 0; i < 32; i = i + 1) begin: ins_reg_gen
			dffe_ref ins_reg32(
				.q(ir_out[i]), 
				.d(ins[i]), 
				.clk(clk), 
				.en(en_ir), 
				.clr(rst)
			);
		end
		
	endgenerate
	
endmodule


