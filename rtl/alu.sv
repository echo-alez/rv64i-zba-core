// alu.sv
module alu(
    input  logic [63:0] a,
    input  logic [63:0] b,
    input  logic [3:0]  alu_op,
    output logic [63:0] result
);

    // ALU operations
    localparam ALU_ADD     = 4'b0000;
    localparam ALU_SUB     = 4'b0001;
    localparam ALU_SH1ADD  = 4'b0010;
    localparam ALU_SH2ADD  = 4'b0011;
    localparam ALU_SH3ADD  = 4'b0100;

    always_comb begin
        case(alu_op)
            ALU_ADD:     result = a + b;
            ALU_SUB:     result = a - b;
            ALU_SH1ADD:  result = a + (b << 1);
            ALU_SH2ADD:  result = a + (b << 2);
            ALU_SH3ADD:  result = a + (b << 3);
            default:     result = 0;
        endcase
    end

endmodule
