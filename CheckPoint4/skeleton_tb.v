`timescale 100 ns / 100 ps

module skeleton_tb();

    reg clock, reset;
    wire imem_clock, dmem_clock, processor_clock, regfile_clock;
	 
	skeleton dut(clock, reset, imem_clock, dmem_clock, processor_clock, regfile_clock);

    initial begin
        clock = 1'b0;
        reset = 1'b0;
    end

    always #20 clock = ~clock;

    initial begin
        @(posedge clock);
        reset = 1'b1;
        @(posedge clock);
        @(posedge clock);
        reset = 1'b0;
        #10000
        $stop;
    end
endmodule
