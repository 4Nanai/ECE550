# ECE550D Full ALU CheckPoint 2
**Student Name:** Toshiko Li
**NetID:** jl1355

## CP2 Structure Hierarchy

The **alu** module integrates several submodules to perform various arithmetic and logic operations. Based on the input **ctrl_ALUopcode[2:0]**, the **dataResultSelect** unit selects the appropriate operation result for output.

#### 1. dataResultSelect (Main Operation Selector)

- Contains **32 mux_8_in_3** instances, one for each bit of the 32-bit result.
- Each **mux_8_in_3** selects one bit of the final result based on the **ctrl_ALUopcode[2:0]**:
  
  | Operation              | Opcode[2:0] | Function                       |
  | ---------------------- | ----------- | ------------------------------ |
  | ADD                    | 000         | data_operandA + data_operandB  |
  | SUB                    | 001         | data_operandA - data_operandB  |
  | AND (bitwise)          | 010         | data_operandA & data_operandB  |
  | OR (bitwise)           | 011         | data_operandA \| data_operandB |
  | Shift Left Logical      | 100         | data_operandA << ctrl_shiftamt |
  | Shift Right Arithmetic  | 101         | data_operandA >>> ctrl_shiftamt |

#### 2. SLL_32bit (Shift Left Logical)

- Implements a 32-bit logical left shift operation.
- Built using a **cascade of mux_2_in_1** instances to perform the shifting.

#### 3. SRA_32bit (Shift Right Arithmetic)

- Implements a 32-bit arithmetic right shift operation.
- Built using a **cascade of mux_2_in_1** instances to perform the shifting, with extension from the most significant bit.

#### 4. or_32bit (Bitwise OR)

- Implements the bitwise OR operation across two 32-bit operands.
- Consists of **32 instances of OR gates**, each OR gate computing the OR of corresponding bits from data_operandA and data_operandB.

#### 5. and_32bit (Bitwise AND)

- Implements the bitwise AND operation across two 32-bit operands.
- Consists of **32 instances of AND gates**, each AND gate computing the AND of corresponding bits from data_operandA and data_operandB.

#### 6. isLessThan_i (Comparison: Less Than)

- Determines if data_operandA is less than data_operandB when performing subtraction.
- Uses an **XOR gate** to check the sign bit (Most Significant Bit) in combination with overflow to determine if the result is negative, indicating A < B.

#### 7. isNotEqual_i (Comparison: Not Equal)

- Determines if data_operandA is not equal to data_operandB when performing subtraction.
- Consists of a **cascade of OR gates** that check if any bit of the subtraction result is '1'. If any bit is non-zero, the operands are not equal.