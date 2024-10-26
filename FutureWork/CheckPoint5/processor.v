/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile
);
		
	 localparam DWIDTH = 32;
    localparam opWIDTH = 5;
	 localparam addrWIDTH = 12;
	 
    // Control signals
    input clock, reset;

    // Imem
    output [addrWIDTH - 1:0] address_imem;
    input [DWIDTH - 1:0] q_imem;

    // Dmem
    output [addrWIDTH - 1:0] address_dmem;
    output [DWIDTH - 1:0] data;
    output wren;
    input [DWIDTH - 1:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [opWIDTH - 1:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [DWIDTH - 1:0] data_writeReg;
    input [DWIDTH - 1:0] data_readRegA, data_readRegB;

    /* YOUR CODE STARTS HERE */



    wire [opWIDTH - 1:0] opcode; //operation code from decoder in data_path.v

    /* Control Signal */
    wire en_pc, //enable signal for programme counter
        ctrl_writeEnable, // enable signal for register write
        wren, //enable signle for dmem write

        //[opcode -> immediate number] => 
		//sel_alu_dataB = 1
        sel_alu_dataB, //select alu_dataB btwn regDataB(0) & ext_imme_num(1)
        
        //[opcode -> lw] =>
		//sel_writeReg = 1
		sel_writeReg, //select data_writeReg btwn alu_out(0) & dmem_out(1)

		//[opcode -> sw] =>
		//ctrl_sw = 1
		ctrl_sw, //ctrl if handle store word
		
		//is add immed num?
		//if is ALUopcode = 0;
		ctrl_addi,
    
		//is handle ALU? (opcode = 00000)
		is_alu,

		//[opcode -> beq] =>
		//ctrl_Bne = 1
		ctrl_Bne, //ctrl pc to jump if dataA == dataB
		
		//[opcode -> ji] =>
		//ctrl_ji = 1
		ctrl_ji, //ctrl pc to jump to immediate number[25:0]
		
		//[opcode -> jal && ctrl_ji == 1] =>
		//ctrl_jal = 1
		ctrl_jal, //Japanese airline(x)
		
		//[opcode -> jr] =>
		//ctrl_jr = 1
		ctrl_jr, //jump register $d (ctrl_readRegB = rd)
		
		//[opcode -> blt] =>
		//ctrl_Blt = 1
		ctrl_Blt; //jump to pc = pc + 1 + N if dataA < dataB

    data_path data_path_i(
        .clk(clock),
	
        /* control signal input*/
        .rst(reset),
        .en_pc(en_pc),
        .sel_alu_dataB(sel_alu_dataB),
        .sel_writeReg(sel_writeReg),
        .ctrl_sw(ctrl_sw),
        .ctrl_addi(ctrl_addi),
        .is_alu(is_alu),
        .ctrl_Bne(ctrl_Bne),
        .ctrl_Blt(ctrl_Blt),
        .ctrl_ji(ctrl_ji),
        .ctrl_jal(ctrl_jal),
        .ctrl_jr(ctrl_jr),
        
        /* pc_out and ins(input) <-> processor.v -> skeleton.v (imem_i) */
        .address_imem(address_imem), //address_imem = pc_out[11:0]
        .ins(q_imem), // q_imem
        
        /* dmem_i */
        .dmem_in(data), //output to processor.v (data)
        .dmem_out(q_dmem), // input from processor.v (q_dmem)
        .alu_dataOut(address_dmem), //ouput to processor.v (address_dmem)
        
        /* Register Group */
        //en_writeReg, //en_writeReg should be implemented in processor.v
        .ctrl_writeReg(ctrl_writeReg),
        .ctrl_readRegB(ctrl_readRegB),
        .ctrl_readRegA(ctrl_readRegA),
        //ctrl_readRegA = rs
        .data_writeReg(data_writeReg), //data_writeReg
        .data_readRegA(data_readRegA), //data_readRegA
        .data_readRegB(data_readRegB), //data_readRegB
        
        
        /* output from decoder in data_path.v */
        .opcode(opcode)
        
    );


    //implementation of wires needed
    


    //implement decoder_5_to_32 for opcode
    wire [DWIDTH - 1:0] opcode_extend;
    decoder_5_to_32 opcode_decoder(
        .in(opcode),
        .out(opcode_extend)
    );

    //implement signal en_pc
    assign en_pc = clock;

    //implement signal ctrl_writeEnable
    or regWrite(
        ctrl_writeEnable, //enable signal to write regFile
        opcode_extend[0], //All R type ins
        opcode_extend[3], //jal T
        opcode_extend[5], //addi $rd, $rs, N 
        opcode_extend[8] //lw $rd, N($rs) 
        //opcode_extend[21] //setx (JI type) not implemented
    );


    //implement signal wren
    assign wren = opcode_extend[7];

    //implement signal sel_alu_dataB
    or sel_alu_inB(
        sel_alu_dataB,
        opcode_extend[5], //addi $rd, $rs, N 
        opcode_extend[7], //sw $rd, N($rs) 
        opcode_extend[8]  //lw $rd, N($rs) 
    );
    
    //implement signal sel_writeReg
    assign sel_writeReg = opcode_extend[8]; //lw $rd, N($rs) 

    //implement signal ctrl_addi
    or sel_ctrl_addi(
        ctrl_addi,
        opcode_extend[5], //addi $rd, $rs, N 
        opcode_extend[7], //sw $rd, N($rs) 
        opcode_extend[8] //lw $rd, N($rs) 
    );

    assign is_alu = opcode_extend[0]; //All R type ins

    //implement signal ctrl_Bne
    assign ctrl_Bne = opcode_extend[2]; //bne $rd, $rs, N 

    //implement signal ctrl_Blt
    assign ctrl_Blt = opcode_extend[6]; //blt $rd, $rs, N 

    //implement signal ctrl_ji
    assign ctrl_ji = opcode_extend[1]; //j T (PC = T)

    //implement signal ctrl_jal
    assign ctrl_jal = opcode_extend[3]; //jal T

    //implement signal ctrl_sw
    assign ctrl_sw = opcode_extend[7]; //sw $rd, N($rs)

    //implement signal 
    assign ctrl_jr = opcode_extend[4]; //jr $rd


endmodule