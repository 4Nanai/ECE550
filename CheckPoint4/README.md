# ECE550 Project Checkpoint 4: Simple Processor
**Student Name:** Toshiko Li **NetID:** jl1355
**Student Name:** Yangfan Ye **NetID:** yy465

## Top-Level File Skeleton.v

- **Clock Divider Module Implementation**:
  - Designed and implemented a clock divider to convert the input high-speed clock signal into a lower frequency clock signal.
  - This module uses a counter to achieve frequency division, ensuring that other modules in the system operate stably at the appropriate clock frequency.

- **Top-Level Module Structure Construction**:
  - Built the top-level structure of the entire design, integrating various submodules.
  - The clock divider module serves as an important part, working in conjunction with other modules to form a complete system.

- **Signal Connection and Management**:
  - Defined and managed signal connections between submodules in the top-level file to ensure correct transmission and processing of data and control signals.
  - This includes clock signal distribution, reset signal management, etc.

## processor.v

- **Control Signals**:
  - Used to coordinate operations between various modules within the processor.
  - Determine the path of data flow, ALU (Arithmetic Logic Unit) operation types, register file read/write operations, etc.
  - Control signals are generated based on instruction decoding results to ensure each instruction is executed correctly.
  - All signals are eventually connected to the instantiated `data_path` module to control multiplexers.

- **Key Control Signals**:
  - **ALU Operation Code (ALUOp)**: Used to select the specific operation type executed by the ALU, such as addition, subtraction, logical AND, OR, etc.
  - **Register Write Enable (RegWrite)**: Controls write operations to the register file, allowing data to be written to a specified register when activated.
  - **Memory Read Enable (MemRead)**: Controls whether data is read from data memory.
  - **Memory Write Enable (MemWrite)**: Controls whether data is written to data memory.
  - **Memory to Register (MemToReg)**: Determines whether data read from memory is written into the register file.
  - **Branch Signal (Branch)**: Used to control program counter updates, triggering a jump when conditions are met.
  - **Jump Signal (Jump)**: Handles unconditional jump instructions by directly updating the program counter.
  - **ALU Source Select Signal (ALUSrc)**: Determines whether the second operand of the ALU comes from a register or an immediate value extension.

## data_path.v

- **Arithmetic Logic Unit (ALU)**:
  - **Function**: Performs various arithmetic and logic operations such as addition, subtraction, AND, OR, etc.
  - **Control Signals**: `ALUOp` determines the specific operation type; `sel_alu_dataB` determines the source of operands.

- **Multiplexer (MUX)**:
  - **Function**: Selects different data sources as output, typically used for selecting ALU operands or determining the source of data written back to registers.

- **Extender Unit**:
  - **Function**: Extends immediate values from instructions to the processor's standard internal data width for operations.
  - **Control Signals**: Typically not directly driven by control signals but its output is used by other modules.

- **Program Counter (PC)**:
  - **Function**: Holds the current instruction address and updates each clock cycle to point to the next instruction.
  - **Control Signals**: `Branch` and `Jump` signals are used to decide how the PC is updated for handling branches and jumps.