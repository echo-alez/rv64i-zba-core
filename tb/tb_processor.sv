// tb_processor.sv
`timescale 1ns/1ps

module tb_processor(
    // -----------------------------------------
    // Clock & reset
    // -----------------------------------------
    input logic clk,
    input logic reset,

    // -----------------------------------------
    // Instruction memory interface
    // -----------------------------------------
    output logic [63:0] imem_addr,
    input  logic [31:0] imem_rdata,

    // -----------------------------------------
    // Data memory interface
    // -----------------------------------------
    output logic        dmem_we,
    output logic [63:0] dmem_addr,
    output logic [63:0] dmem_wdata,
    input  logic [63:0] dmem_rdata
);

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

endmodule