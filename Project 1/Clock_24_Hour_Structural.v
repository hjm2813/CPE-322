// Clock_24_Hour_structural.v

// D flip-flop module (D_FF)
module D_FF(
    input CLK,
    input D,
    output reg Q
);
    always @(posedge CLK) begin
        Q <= D;
    end
endmodule

// Four_Bit_Mod_n_Counter module
module Four_Bit_Mod_n_Counter(
    input CLK,
    input Reset,
    input LD,
    input EN,
    input [3:0] D,
    output reg [3:0] Q,
    output reg Cout
);
    parameter n = 10; // Default value, can be overridden at instantiation
    
    always @(posedge CLK or posedge Reset) begin
        if (Reset) begin
            Q <= 0;
            Cout <= 0;
        end else if (LD) begin
            Q <= D;
            Cout <= 0;
        end else if (EN) begin
            if (Q == (n - 1)) begin
                Q <= 0;
                Cout <= 1;
            end else begin
                Q <= Q + 1;
                Cout <= 0;
            end
        end else begin
            Cout <= 0;
        end
    end
endmodule

// Top-level structural module for the 24-hour clock
module Clock_24_Hour_structural(
    input CLK,
    input Reset_time,
    input Set_time,
    input [23:0] Time_in,
    output [23:0] Time_out
);

    // Wire declarations
    wire [5:0] cout; // Carry out signals for each counter
    wire G1, G2, G3; // Intermediate signals for gates

    // Add the sync_signal wire here
    wire sync_signal; // This wire will connect to the Q output of the D_FF

    // ... (rest of your module instantiations and logic)
    
    // Seconds counter: 0 to 59
    Four_Bit_Mod_n_Counter #(10) seconds_low (
        .CLK(CLK),
        .Reset(Reset_time),
        .LD(Set_time),
        .EN(~Reset_time & (Set_time | cout[0])),
        .D(Time_in[3:0]),
        .Q(Time_out[3:0]),
        .Cout(cout[0])
    );
    
    Four_Bit_Mod_n_Counter #(6) seconds_high (
        .CLK(CLK),
        .Reset(Reset_time),
        .LD(Set_time),
        .EN(cout[0]),
        .D(Time_in[7:4]),
        .Q(Time_out[7:4]),
        .Cout(cout[1])
    );
    
    // Minutes counter: 0 to 59
    Four_Bit_Mod_n_Counter #(10) minutes_low (
        .CLK(CLK),
        .Reset(Reset_time),
        .LD(Set_time),
        .EN(cout[1]),
        .D(Time_in[11:8]),
        .Q(Time_out[11:8]),
        .Cout(cout[2])
    );
    
    Four_Bit_Mod_n_Counter #(6) minutes_high (
        .CLK(CLK),
        .Reset(Reset_time),
        .LD(Set_time),
        .EN(cout[2]),
        .D(Time_in[15:12]),
        .Q(Time_out[15:12]),
        .Cout(cout[3])
    );
    
    // Hours counter: 0 to 23
    Four_Bit_Mod_n_Counter #(10) hours_low (
        .CLK(CLK),
        .Reset(Reset_time),
        .LD(Set_time),
        .EN(cout[3]),
        .D(Time_in[19:16]),
        .Q(Time_out[19:16]),
        .Cout(cout[4])
    );
    
    // This module has a modified modulus to handle the 24-hour format.
    // It resets to 0 when it reaches 2 and the lower bits are at 4 (24 hours).
    Four_Bit_Mod_n_Counter #(3) hours_high (
        .CLK(CLK),
        .Reset(Reset_time),
        .LD(Set_time),
        .EN(cout[4] & ~(Time_out[19:16] == 4)),
        .D(Time_in[23:20]),
        .Q(Time_out[23:20]),
        .Cout(cout[5])
    );
    
    // Logic gates for carry handling and setting functionality
    assign G1 = cout[1] & cout[2]; // AND gate that combines carries for seconds and minutes
    assign G2 = cout[4] | Set_time; // OR gate that combines carry for hours or Set_time
    assign G3 = ~Reset_time;       // NOT gate for Reset_time
    
    // D flip-flop to synchronize the setting operation
    D_FF set_sync (
    .CLK(CLK), 
    .D(G2), 
    .Q(sync_signal) // Assuming 'sync_signal' is the name of the output you want to connect to
    );
    
    endmodule
