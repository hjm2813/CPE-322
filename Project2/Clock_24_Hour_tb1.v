`timescale 1ns / 1ps
module Clock_24_Hour_tb1;

// Inputs to the Clock module
reg Reset_time, Set_time;
reg [7:0] Time_in;
// Outputs from the Clock module
wire [7:0] Time_out; 


Clock_24_Hour_structural uut (
    .Reset_time(Reset_time),
    .Set_time(Set_time),
    .Time_in(Time_in),
    .Time_out(Time_out)
);

initial begin
    // Initialize Inputs
    Reset_time = 0;
    Set_time = 0;
    Time_in = 0;

    // Wait for global reset to finish
    #100;
   
    // Asynchronously reset the clock
    Reset_time = 1; #10;
    Reset_time = 0; #10;
   
    // Load 23:59:55 into the clock and deassert Set_time
    Set_time = 1;
    Time_in = {2'b10, 3'b011, 3'b011, 2'b10, 3'b011, 3'b011}; // Binary for 23:59:55
    #10;
    Set_time = 0;
   
  
    #500; // 50 clock ticks should show the transition
   
    // End simulation after 20 seconds of simulation time
   
    #20000000;
    $finish;
end

// Optional: Monitor and display changes
initial begin
    $monitor("Time=%t Reset=%b Set=%b Time_in=%b Time_out=%b", $time, Reset_time, Set_time, Time_in, Time_out);
end

endmodule
