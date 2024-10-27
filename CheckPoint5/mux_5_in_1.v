module mux_5_in_1(
	in0,
	in1,
	s,
	out
);
	input [4:0] in0, in1;
	input s;
	output [4:0] out;
	
	genvar i;
	generate
		for (i = 0; i < 5; i = i + 1) begin: mux_writeReg_gen
			mux_2_in_1 mux_writeReg(
				.in0(in0[i]), 
				.in1(in1[i]), 
				.s(s), 
				.out(out[i])
			);
		end
	endgenerate

endmodule

