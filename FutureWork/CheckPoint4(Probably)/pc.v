module pc #(parameter DWIDTH = 32)( //program counter
	clk,
	rst,
	en_pc,
	pc_in,
	pc_out
);
	input clk, rst, en_pc;
   input [DWIDTH - 1:0] pc_in;
   output [DWIDTH - 1:0] pc_out;
	
	genvar i;
	generate
		for (i = 0; i < 32; i = i + 1) begin: pc_reg_gen
			dffe_ref pc_reg32(
				.q(pc_out[i]), 
				.d(pc_in[i]), 
				.clk(clk), 
				.en(en_pc), 
				.clr(rst)
			);
		end
		
	endgenerate
	
endmodule
