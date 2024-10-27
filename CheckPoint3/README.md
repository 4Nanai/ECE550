# Probably a CheckPoint
## Structure Hierarchy
### **regfile.v - Register File Design**

This project implements a 32-register file with a 5-bit control signal that selects which register to read from or write to. The design utilizes multiple submodules to achieve efficient decoding, register storage, and tristate gate logic.

#### **Top-Level Module: regfile.v**

- The top module, regfile.v, orchestrates the interaction between various submodules to form the complete register file. It includes a 5-bit ctrl_writeReg control signal used to select the write target register. The design leverages a 5-to-32 decoder, a 32-register group, and 32-bit tristate gates to facilitate read and write operations.

#### **Submodules Overview**

- **decoder_5_to_32.v**
  - The decoder_5_to_32.v module implements a 5-to-32 decoder using a hierarchical approach. It begins with a basic 2-to-4 decoder and iteratively adds one bit at a time to create the 5-to-32 decoder. The additional bits are used as Most Significant Bits (MSB) and Last Significant Bits (LSB) to expand the decoding range.

- **reg_group_32.v**
  - The reg_group_32.v module contains 32 individual 32-bit registers. This is achieved through a generate for loop, which creates 32 instances of the dffe.v module. Each dffe instance represents a D flip-flop with enable, providing the ability to store and update data when the appropriate control signals are asserted.

- **tri_32.v**
  - The tri_32.v module implements 32 tristate gates using a generate for loop. These gates are used to control the output of the register file, allowing the selected register’s value to be placed on the bus during read operations.



#### **Operation Flow**

- **Write Operation**:
  - The 5-bit ctrl_writeReg signal, which specifies the register to write to, is passed through the decoder_5_to_32 module. The decoder produces a 32-bit one-hot output, where only one bit is set based on the ctrl_writeReg value. This decoded output is then bitwise ANDed with the ctrl_writeEnable signal to generate the enable signal for the specific register to be written. The enable signals are connected to the reg_group_32 module, ensuring that only the selected register can be updated.

- **Read Operation**:
  - The output of the register file, regFileOut, is a 32-bit bus composed of the outputs from all the register groups. Two separate sets of tristate gates in the tri_32 module control which register’s value is placed on the output bus. The selection is controlled by the decoded values of ctrl_readRegA and ctrl_readRegB. The read operations use the tristate gates to allow only the selected register’s data to be placed on the bus for reading.

----
<img src="Structure Diagram.jpeg" alt="Structure Diagram" style="zoom:3000%;" />



## Testbench
![Testbench Diagram](<tb Diagram.png>)


## Tasks

- [x] Implement register.v
- [x] Add testbench register_tb.v
- [x] Implement decoder_5_to_32.v
- [x] Add testbench decoder_5_to_32_tb.v
- [x] Implement reg_group_32.v
- [x] Add testbench reg_group_32_tb.v
- [x] Implement tri_32.v
- [x] Add testbench tri_32_tb.v
- [x] Implement the regfile.v
- [x] Add testbench regFile_tb.v
- [x] Write README file for CheckPoint
