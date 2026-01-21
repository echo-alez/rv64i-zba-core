// regfile.sv
module regfile(
    input  logic        clk,
    input  logic        we,
    input  logic [4:0]  ra1, ra2, wa,
    input  logic [63:0] wd,
    output logic [63:0] rd1, rd2
);
    logic [63:0] regs[31:0];

    assign rd1 = regs[ra1];
    assign rd2 = regs[ra2];

    always_ff @(posedge clk) begin
        if (we && wa != 0)
            regs[wa] <= wd;
    end
endmodule
