// control.sv
module control(
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic       mem_read,
    output logic       mem_write,
    output logic [3:0] alu_op
);

    // ALU op codes
    localparam ALU_ADD     = 4'b0000;
    localparam ALU_SUB     = 4'b0001;
    localparam ALU_SH1ADD  = 4'b0010;
    localparam ALU_SH2ADD  = 4'b0011;
    localparam ALU_SH3ADD  = 4'b0100;

    always_comb begin
        mem_read  = 0;
        mem_write = 0;
        alu_op    = ALU_ADD;

        case (opcode)
            7'b0000011: mem_read = 1;        // LOAD
            7'b0100011: mem_write = 1;       // STORE
            7'b0110011: begin                 // R-type
                case ({funct7, funct3})
                    10'b0000000000: alu_op = ALU_ADD;
                    10'b0100000000: alu_op = ALU_SUB;
                    10'b0000000001: alu_op = ALU_SH1ADD;
                    10'b0000000010: alu_op = ALU_SH2ADD;
                    10'b0000000011: alu_op = ALU_SH3ADD;
                    default: alu_op = ALU_ADD;
                endcase
            end
        endcase
    end

endmodule
