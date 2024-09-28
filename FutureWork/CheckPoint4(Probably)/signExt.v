module signExt( // Sign Extention
	imme_num,
	imme_num_ex
);

	input [15:0] imme_num;
	output [31:0] imme_num_ex;
	
	assign imme_num_ex[31:16] = imme_num[15]?16'hFFFF:15'h0000;
	assign imme_num_ex[15:0] = imme_num;
endmodule
