// ============================================================================
// Module     : pipeline_regs
// Designer   : Yogita Jangra
// Description: Parameterized pipeline register used between stages.
//              Acts as IF/ID and ID/EX pipeline registers.
//              Latches data on every rising clock edge.
// ============================================================================

module pipeline_regs #(
    parameter WIDTH = 8       // Width of the register (default 8-bit)
)(
    input  wire             clk,    // Clock
    input  wire             rst,    // Synchronous reset
    input  wire [WIDTH-1:0] d,      // Data input
    output reg  [WIDTH-1:0] q       // Data output (registered)
);

    always @(posedge clk) begin
        if (rst)
            q <= {WIDTH{1'b0}};
        else
            q <= d;
    end

endmodule
