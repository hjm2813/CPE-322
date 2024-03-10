// Four_Bit_Mod_n_Counter.v

module Four_Bit_Mod_n_Counter(
    input wire CLK,
    input wire Reset,
    input wire LD,
    input wire EN,
    input wire [3:0] D,
    output reg [3:0] Q,
    output wire Cout
);
    parameter n = 10; // Default modulus value

    // Carry out logic (Mealy type output)
    assign Cout = (EN && Q == (n - 1)) ? 1'b1 : 1'b0;

    always @(posedge CLK or posedge Reset or posedge LD) begin
        if (Reset) begin
            // Asynchronous reset
            Q <= 4'b0;
        end else if (LD) begin
            // Asynchronous load
            Q <= D;
        end else if (EN) begin
            // Synchronous increment
            if (Q == (n - 1)) begin
                Q <= 4'b0; // Wrap around to zero
            end else begin
                Q <= Q + 1;
            end
        end
        // No else clause needed, as there are no other actions on the clock edge
    end
endmodule
