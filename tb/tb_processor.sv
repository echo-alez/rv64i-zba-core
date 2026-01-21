// tb_processor.sv
`timescale 1ns/1ps

module tb_processor;

    // -----------------------------------------
    // Clock & reset
    // -----------------------------------------
    // We use "logic" for compatibility
    logic clk;
    logic reset;

    // -----------------------------------------
    // Instruction memory interface
    // -----------------------------------------
    logic [63:0] imem_addr;
    logic [31:0] imem_rdata;

    // -----------------------------------------
    // Data memory interface
    // -----------------------------------------
    logic        dmem_we;
    logic [63:0] dmem_addr;
    logic [63:0] dmem_wdata;
    logic [63:0] dmem_rdata;

    // -----------------------------------------
    // Instantiate DUT (Device Under Test)
    // -----------------------------------------
    rv64_core core0 (
        .clk        (clk),
        .reset      (reset),
        .imem_addr  (imem_addr),
        .imem_rdata (imem_rdata),
        .dmem_we    (dmem_we),
        .dmem_addr  (dmem_addr),
        .dmem_wdata (dmem_wdata),
        .dmem_rdata (dmem_rdata)
    );

    // -----------------------------------------
    // Clock generation
    // -----------------------------------------
    // In Verilator --timing mode, this creates a 100MHz clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // -----------------------------------------
    // Reset sequence
    // -----------------------------------------
    initial begin
        reset = 1;      // Start with reset active
        #20;            // Wait 20ns
        reset = 0;      // Release reset
    end

    // -----------------------------------------
    // Instruction memory (Simple ROM)
    // -----------------------------------------
    always_comb begin
        case (imem_addr)
            64'h0: imem_rdata = 32'h00000013; // NOP (addi x0,x0,0)
            64'h4: imem_rdata = 32'h00000013; // NOP
            default: imem_rdata = 32'h00000013;
        endcase
    end

    // -----------------------------------------
    // Data memory (Dummy Read)
    // -----------------------------------------
    assign dmem_rdata = 64'b0;

    // -----------------------------------------
    // Debug Monitor
    // -----------------------------------------
    always @(posedge clk) begin
        if (!reset && dmem_we) begin
            $display("[%0t] DMEM WRITE: addr=%h data=%h", $time, dmem_addr, dmem_wdata);
        end
    end

    // -----------------------------------------
    // Waveform dump
    // -----------------------------------------
    initial begin
        // These tasks tell Verilator to start recording
        $dumpfile("wave.vcd");
        // 0 = dump all signals in tb_processor and its children (core0)
        $dumpvars(0, tb_processor);
    end

    // -----------------------------------------
    // Simulation Control
    // -----------------------------------------
    initial begin
        // Run simulation for 1000 time units
        #1000;
        $display("Simulation finished at time %0t", $time);
        $finish; // This will trigger the C++ while loop to exit
    end

endmodule