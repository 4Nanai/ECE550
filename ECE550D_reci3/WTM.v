module WTM(
	input [4:0] A, B,
	output [9:0] mul,
	output cout
);
// Stage 1: A&B
	wire A0B4,A0B3,A0B2,A0B1,A0B0,
	A1B4,A1B3,A1B2,A1B1,A1B0,
	A2B4,A2B3,A2B2,A2B1,A2B0,
	A3B4,A3B3,A3B2,A3B1,A3B0,
	A4B4,A4B3,A4B2,A4B1,A4B0;
	stage1 stage_1(
		.x(A),
		.y(B),
		.x0y4(A0B4),
		.x0y3(A0B3),
		.x0y2(A0B2),
		.x0y1(A0B1),
		.x0y0(A0B0),
		.x1y4(A1B4),
		.x1y3(A1B3),
		.x1y2(A1B2),
		.x1y1(A1B1),
		.x1y0(A1B0),
		.x2y4(A2B4),
		.x2y3(A2B3),
		.x2y2(A2B2),
		.x2y1(A2B1),
		.x2y0(A2B0),
		.x3y4(A3B4),
		.x3y3(A3B3),
		.x3y2(A3B2),
		.x3y1(A3B1),
		.x3y0(A3B0),
		.x4y4(A4B4),
		.x4y3(A4B3),
		.x4y2(A4B2),
		.x4y1(A4B1),
		.x4y0(A4B0)
	);
	
//Stage 2: Carry Save Adder
	wire hA_0_Cout;
	assign mul[0] = A0B0;
	full_adder hA_0(
		.a(A1B0), 
		.b(A0B1), 
		.carry_in(1'b0),
		.sum(mul[1]), 
		.carry_out(hA_0_Cout)
	);
	
	wire fA_0_Sum, fA_0_Cout;
	full_adder fA_0(
		.a(A2B0), 
		.b(A1B1), 
		.carry_in(A0B2),
		.sum(fA_0_Sum), 
		.carry_out(fA_0_Cout)
	);
	
	wire fA_1_Sum, fA_1_Cout;
	full_adder fA_1(
		.a(A3B0), 
		.b(A2B1), 
		.carry_in(A1B2),
		.sum(fA_1_Sum), 
		.carry_out(fA_1_Cout)
	);
	
	wire fA_2_Sum, fA_2_Cout;
	full_adder fA_2(
		.a(A4B0), 
		.b(A3B1), 
		.carry_in(A2B2),
		.sum(fA_2_Sum), 
		.carry_out(fA_2_Cout)
	);
	
	wire hA_1_Sum, hA_1_Cout;
	full_adder hA_1(
		.a(A4B1), 
		.b(A3B2), 
		.carry_in(1'b0),
		.sum(hA_1_Sum), 
		.carry_out(hA_1_Cout)
	);
	
	//A4B2 remained
	
	//A0B3 remained
	
	wire hA_2_Sum, hA_2_Cout;
	full_adder hA_2(
		.a(A1B3), 
		.b(A0B4), 
		.carry_in(1'b0),
		.sum(hA_2_Sum), 
		.carry_out(hA_2_Cout)
	);
	
	wire hA_3_Sum, hA_3_Cout;
	full_adder hA_3(
		.a(A2B3), 
		.b(A1B4), 
		.carry_in(1'b0),
		.sum(hA_3_Sum), 
		.carry_out(hA_3_Cout)
	);
	
	wire hA_4_Sum, hA_4_Cout;
	full_adder hA_4(
		.a(A3B3), 
		.b(A2B4), 
		.carry_in(1'b0),
		.sum(hA_4_Sum), 
		.carry_out(hA_4_Cout)
	);
	
	wire hA_5_Sum, hA_5_Cout;
	full_adder hA_5(
		.a(A4B3), 
		.b(A3B4), 
		.carry_in(1'b0),
		.sum(hA_5_Sum), 
		.carry_out(hA_5_Cout)
	);
	
	//A4B4 remained
	
//Stage 3: Cascade Carry Save Adder
	wire hA_6_Cout;
	full_adder hA_6(
		.a(hA_0_Cout), 
		.b(fA_0_Sum), 
		.carry_in(1'b0),
		.sum(mul[2]), 
		.carry_out(hA_6_Cout)
	);
	
	wire fA_3_Sum, fA_3_Cout;
	full_adder fA_3(
		.a(fA_1_Sum), 
		.b(fA_0_Cout), 
		.carry_in(A0B3),
		.sum(fA_3_Sum), 
		.carry_out(fA_3_Cout)
	);
	
	wire fA_4_Sum, fA_4_Cout;
	full_adder fA_4(
		.a(fA_2_Sum), 
		.b(fA_1_Cout), 
		.carry_in(hA_2_Sum),
		.sum(fA_4_Sum), 
		.carry_out(fA_4_Cout)
	);
	
	wire fA_5_Sum, fA_5_Cout;
	full_adder fA_5(
		.a(hA_1_Sum), 
		.b(fA_2_Cout), 
		.carry_in(hA_3_Sum),
		.sum(fA_5_Sum), 
		.carry_out(fA_5_Cout)
	);
	
	wire fA_6_Sum, fA_6_Cout;
	full_adder fA_6(
		.a(A4B2), 
		.b(hA_1_Cout), 
		.carry_in(hA_4_Sum),
		.sum(fA_6_Sum), 
		.carry_out(fA_6_Cout)
	);
	
//Stage 4: more Cascade Carry Save Adder
	wire hA_7_Cout;
	full_adder hA_7(
		.a(fA_3_Sum), 
		.b(hA_6_Cout), 
		.carry_in(1'b0),
		.sum(mul[3]), 
		.carry_out(hA_7_Cout)
	);
	
	wire hA_8_Sum, hA_8_Cout;
	full_adder hA_8(
		.a(fA_4_Sum), 
		.b(fA_3_Cout), 
		.carry_in(1'b0),
		.sum(hA_8_Sum), 
		.carry_out(hA_8_Cout)
	);
	
	wire fA_7_Sum, fA_7_Cout;
	full_adder fA_7(
		.a(fA_5_Sum), 
		.b(fA_4_Cout), 
		.carry_in(hA_2_Cout),
		.sum(fA_7_Sum), 
		.carry_out(fA_7_Cout)
	);
	
	wire fA_8_Sum, fA_8_Cout;
	full_adder fA_8(
		.a(fA_6_Sum), 
		.b(fA_5_Cout), 
		.carry_in(hA_3_Cout),
		.sum(fA_8_Sum), 
		.carry_out(fA_8_Cout)
	);
	
	wire fA_9_Sum, fA_9_Cout;
	full_adder fA_9(
		.a(hA_5_Sum), 
		.b(fA_6_Cout), 
		.carry_in(hA_4_Cout),
		.sum(fA_9_Sum), 
		.carry_out(fA_9_Cout)
	);
	
	wire hA_9_Sum, hA_9_Cout;
	full_adder hA_9(
		.a(A4B4), 
		.b(hA_5_Cout), 
		.carry_in(1'b0),
		.sum(hA_9_Sum), 
		.carry_out(hA_9_Cout)
	);
	
//stage 5: Get result
	wire hA_10_Cout;
	full_adder hA_10(
		.a(hA_7_Cout), 
		.b(hA_8_Sum), 
		.carry_in(1'b0),
		.sum(mul[4]), 
		.carry_out(hA_10_Cout)
	);
	
	wire fA_10_Cout;
	full_adder fA_10(
		.a(fA_7_Sum), 
		.b(hA_8_Cout), 
		.carry_in(hA_10_Cout),
		.sum(mul[5]), 
		.carry_out(fA_10_Cout)
	);
	
	wire fA_11_Cout;
	full_adder fA_11(
		.a(fA_8_Sum), 
		.b(fA_7_Cout), 
		.carry_in(fA_10_Cout),
		.sum(mul[6]), 
		.carry_out(fA_11_Cout)
	);
	
	wire fA_12_Cout;
	full_adder fA_12(
		.a(fA_9_Sum), 
		.b(fA_8_Cout), 
		.carry_in(fA_11_Cout),
		.sum(mul[7]), 
		.carry_out(fA_12_Cout)
	);
	
	wire fA_13_Cout;
	full_adder fA_13(
		.a(hA_9_Sum), 
		.b(fA_9_Cout), 
		.carry_in(fA_12_Cout),
		.sum(mul[8]), 
		.carry_out(fA_13_Cout)
	);
	
	wire hA_11_Cout;
	full_adder hA_11(
		.a(hA_9_Cout), 
		.b(fA_13_Cout), 
		.carry_in(1'b0),
		.sum(mul[9]),
		.carry_out(cout)
	);
	
endmodule
