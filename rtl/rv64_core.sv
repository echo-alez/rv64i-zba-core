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
    // Program Counter (PC)
    // -------------------------------------------------
    logic [63:0] pc;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 64'h80000000; // Initial PC from linker script
        end else begin
            pc <= pc + 4; // Increment PC for next instruction
        end
    end

    // Instruction fetch
    assign imem_addr = pc;

    // -------------------------------------------------
    // Decode
    // -------------------------------------------------
    logic [6:0] opcode = imem_rdata[6:0];
    logic [2:0] funct3 = imem_rdata[14:12];
    logic [6:0] funct7 = imem_rdata[31:25];
    logic [4:0] rd_addr  = imem_rdata[11:7];
    logic [4:0] rs1_addr = imem_rdata[19:15];
    logic [4:0] rs2_addr = imem_rdata[24:20];

    // -------------------------------------------------
    // Control Unit
    // -------------------------------------------------
    logic       mem_read_ctrl;
    logic       mem_write_ctrl;
    logic [3:0] alu_op_ctrl;
    
    // For now, we assume R-type instructions always write back to the register file.
    // This will need to be more sophisticated later.
    logic       reg_wr_en = (opcode == 7'b0110011);

    control control_unit (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .mem_read(mem_read_ctrl),
        .mem_write(mem_write_ctrl),
        .alu_op(alu_op_ctrl)
    );

    // -------------------------------------------------
    // Register File
    // -------------------------------------------------
    logic [63:0] rs1_data;
    logic [63:0] rs2_data;
    logic [63:0] alu_result;

    regfile reg_file (
        .clk(clk),
        .we(reg_wr_en),
        .ra1(rs1_addr),
        .ra2(rs2_addr),
        .wa(rd_addr),
        .wd(alu_result), // Write ALU result back to register file
        .rd1(rs1_data),
        .rd2(rs2_data)
    );

    // -------------------------------------------------
    // ALU
    // -------------------------------------------------
    alu alu_unit (
        .a(rs1_data),
        .b(rs2_data),
        .alu_op(alu_op_ctrl),
        .result(alu_result)
    );
    
    // -------------------------------------------------
    // Data Memory Connections (for now, mostly placeholders)
    // -------------------------------------------------
    assign dmem_we    = mem_write_ctrl;
    assign dmem_addr  = alu_result; // Address for LOAD/STORE is typically ALU result
    assign dmem_wdata = rs2_data;   // Data to be written comes from the second register

endmodule
