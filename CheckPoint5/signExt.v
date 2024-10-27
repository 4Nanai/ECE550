module signExt( // Sign Extention
	imme_num,
	imme_num_ex
);

	input [16:0] imme_num; //17-bit immediate number
	output [31:0] imme_num_ex;
	
	// if MSB is 1, extend to 32-bit neg number
	assign imme_num_ex[31:17] = imme_num[16]?15'h7FFF:15'h0000;
	assign imme_num_ex[16:0] = imme_num;
endmodule
