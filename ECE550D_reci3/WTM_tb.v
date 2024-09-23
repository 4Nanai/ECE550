`timescale 1ns / 100ps
module WTM_tb();

	reg [4:0] A, B;
	reg clk;
	wire [9:0] mul;
	wire cout;
	
	WTM dut(
		.A(A),
		.B(B),
		.mul(mul),
		.cout(cout)
	);
	
	
	initial begin
	
	clk = 1'b0;
	
	@(posedge clk);
	A = 5'd0;
	B = 5'd20;
	
	@(posedge clk);
	A = 5'd25;
	B = 5'd16;
	
	@(posedge clk);
	A = 5'd31;
	B = 5'd1;
	
	@(posedge clk);
	$stop;
	end
	
	always
	#10 clk = ~clk;
	
endmodule
