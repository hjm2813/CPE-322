`timescale 1ns / 1ps
module Clock_24_Hour_tb2;

// Inputs
reg clk;
reg reset;
reg [23:0] time_in; 

// Outputs
wire [23:0] time_out; 

// Instantiate the Clock_24_Hour_autotest
the Clock_24_Hour_autotest (
    .clk(clk),
    .reset(reset),
    .time_in(time_in),
    .time_out(time_out)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk; 
end

// Test sequence
initial begin
    // Initialize Inputs
    reset = 1;
    time_in = 0;
    #10; // Wait for the reset to take effect
    reset = 0;

    // Simulation loop to test every second in a 24-hour day
    integer i;
    for (i = 0; i < 86400; i = i + 1) begin
        time_in = i; 
        #10; // Wait for time to be set and output to be generated
       
        // Check output against expected value
        if (time_out != i) begin // Adjust this condition based on your design's time format
            $display("Mismatch at %d seconds: Expected %d, got %d", i, i, time_out);
        end
       
        #10; 
    end
   
    $display("Simulation complete.");
    $finish; // End the simulation
end

endmodule
