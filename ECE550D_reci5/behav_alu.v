module behav_alu (
    data_operandA, data_operandB, ctrl_ALUopcode,
    ctrl_shiftamt, data_result, isNotEqual,
    isLessThan, overflow
);
    input signed [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output reg [31:0] data_result;
    output reg isNotEqual, isLessThan, overflow;

    localparam ADD = 3'b000,
            SUB = 3'b001,
            AND = 3'b010,
            OR = 3'b011,
            SLL = 3'b100,
            SRA = 3'b101;
	always @(*) begin
    case (ctrl_ALUopcode[2:0])
        ADD: begin
            data_result = data_operandA + data_operandB;
        end 
        SUB: begin
            data_result = data_operandA - data_operandB;
        end
        AND: begin
            data_result = data_operandA & data_operandB;
        end
        OR: begin
            data_result = data_operandA | data_operandB;
        end
        SLL: begin
            data_result = data_operandA << ctrl_shiftamt;
        end
        SRA: begin
            data_result = data_operandA >>> ctrl_shiftamt;
        end
        default: data_result = 32'd0;
    endcase
    
    if (data_operandA != data_operandB) begin
        isNotEqual = 1'b1;
    end
    else begin
        isNotEqual = 1'b0;
    end

    if ($signed(data_operandA) < $signed(data_operandB)) begin
        isLessThan = 1'b1;
    end
    else begin
        isLessThan = 1'b0;
    end
    if (data_operandA[31] == data_operandB[31] && data_result[31] != data_operandA[31]) begin
        overflow = 1'b1;
    end
    else begin
        overflow = 1'b0;
    end
	end
endmodule