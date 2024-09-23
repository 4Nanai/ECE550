module FSM_mealy(
	input w,
	input clk, rst_n,
	output reg [2:0] STATE,
	output reg count
);//Mealy Machine

	reg [2:0] current_state, next_state;
	
	localparam A = 3'd0;
	localparam B = 3'd1;
	localparam C = 3'd2;
	localparam D = 3'd3;
	localparam E = 3'd4;
	localparam F = 3'd5;
	localparam G = 3'd6;
	localparam H = 3'd7;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			current_state <= A;
		end
		else begin
			current_state <= next_state;
		end
	end
	
	always @(current_state, w) begin
		next_state = current_state;
		case(current_state)
			A: begin
				if(w) begin
					next_state = B;
					STATE = B;
					count = 1'b0;
				end
				else begin
					STATE = A;
					count = 1'b0;
				end
			end
			
			B: begin
				if(w) begin
					next_state = C;
					STATE = C;
				end
				else begin
					STATE = B;
				end
			end
			
			C: begin
				if(w) begin
					next_state = D;
					STATE = D;
				end
				else begin
					STATE = C;
				end
			end
			
			D: begin
				if(w) begin
					count = 1'b1;
					next_state = E;
					STATE = E;
				end
				else begin
					STATE = D;
				end
			end
			
			E: begin
				if(w) begin
					next_state = A;
					count = 1'b0;
					STATE = A;
				end
				else begin
					count = 1'b1;
					STATE = E;
				end
				
			end
			default: next_state = A;
		endcase
	end
endmodule

			
			
			
			