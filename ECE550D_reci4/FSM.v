module FSM(
	input w,
	input clk, rst_n,
	output reg [2:0] STATE,
	output reg count
);//Moore Machine

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
	
	always @(*) begin
		case (current_state)
			A: begin
				count = 1'b0;
				STATE = A;
				if(w) begin
					next_state = B;
				end
				else begin
					next_state = current_state;
				end
			end
			
			B: begin
				STATE = B;
				if(w) begin
					next_state = C;
				end
				else begin
					next_state = current_state;
				end
			end
			
			C: begin
				STATE = C;
				if(w) begin
					next_state = D;
				end
				else begin
					next_state = current_state;
				end
			end
			
			D: begin
				STATE = D;
				if (w) begin
					next_state = E;
				end
				else begin
					next_state = current_state;
				end
			end
			
			E: begin
				STATE = E;
				count = 1'b1;
				if (w) begin
					next_state = A;
				end
				else begin
					next_state = E;
				end
			end
			
			F: begin
					next_state = A;
					count = 1'b0;
					STATE = A;
				end
				
			G: begin
					next_state = A;
					count = 1'b0;
					STATE = A;
				end
				
			H: begin
					next_state = A;
					count = 1'b0;
					STATE = A;
				end
			
			default: next_state = current_state;
			
		endcase
	end
endmodule

			
			
			
			