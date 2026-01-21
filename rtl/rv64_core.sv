// rv64_core.sv
module rv64_core (
    input  logic        clk,
    input  logic        reset,

    // Instruction memory interface
    output logic [63:0] imem_addr,
    input  logic [31:0] imem_rdata,

    // Data memory interface
    output logic        dmem_we,
    output logic [63:0] dmem_addr,
    output logic [63:0] dmem_wdata,
    input  logic [63:0] dmem_rdata
);

    // -------------------------------------------------
    // Minimal core behavior
    // -------------------------------------------------

    // Always fetch from address 0 for now
    assign imem_addr = 64'h0;

    // No data memory activity
    assign dmem_we    = 1'b0;
    assign dmem_addr  = 64'b0;
    assign dmem_wdata = 64'b0;

endmodule
