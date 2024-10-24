module decoder_5_to_32(in, out);
	input [4:0] in;
	output [31:0] out;
	
	wire in_MSB_n;//stands for MSB of input wire [3:0] in

	not (in_MSB_n, in[4]);

	decoder_4_to_16 decoder_LSB(
		.in(in[3:0]), 
		.en(in_MSB_n), 
		.out(out[15:0])
		);

	decoder_4_to_16 decoder_MSB(
		.in(in[3:0]), 
		.en(in[4]), 
		.out(out[31:16])
		);
endmodule
