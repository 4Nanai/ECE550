`timescale 1ns/100ps	

module FSM_tb();
	reg clk, rst_n, w;
	wire [2:0] STATE;
	wire count;
	
	FSM_mealy dut(
		.w(w), 
		.clk(clk), 
		.rst_n(rst_n), 
		.STATE(STATE), 
		.count(count)
		);
	
	initial begin 
		clk = 1'b0;
		rst_n = 1'b1;
		@(posedge clk)
		w = 1'b0;
		@(posedge clk)
		w = 1'b1;
		@(posedge clk)
		w = 1'b0;
		rst_n = 1'b0;
		@(posedge clk)
		w = 1'b0;
		rst_n = 1'b1;
		@(posedge clk)
		w = 1'b1;
		@(posedge clk)
		w = 1'b0;
		@(posedge clk)
		w = 1'b0;
		@(posedge clk)
		w = 1'b1;
		@(posedge clk)
		w = 1'b1;
		@(posedge clk)
		w = 1'b1;
		@(posedge clk)
		w = 1'b0;
		@(posedge clk)
		w = 1'b1;
		@(posedge clk)
		w = 1'b1;
		@(posedge clk)
		w = 1'b1;
		#100 w = 1'b0;
		#40 w = 1'b1;
		@(posedge clk)
		$stop;
	end
	always
		#10 clk = ~clk;
endmodule
