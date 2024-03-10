// Clock_24_Hour_behavioral.v

module Clock_24_Hour_behavioral(
    input CLK,
    input Reset_time,
    input Set_time,
    input [23:0] Time_in,
    output reg [23:0] Time_out
);

    // Internal registers to hold the current time
    reg [3:0] seconds_low, seconds_high;
    reg [3:0] minutes_low, minutes_high;
    reg [3:0] hours_low, hours_high;

    // Helper function to increment the BCD-encoded digits
    function [3:0] increment_bcd;
        input [3:0] value;
        input integer modulus;
        begin
            if (value + 1 == modulus) increment_bcd = 0;
            else if (value[3:0] == 9) increment_bcd = value + 7; // Roll over from 9 to 0
            else increment_bcd = value + 1;
        end
    endfunction

    // Always block to handle the time counting
    always @(posedge CLK or posedge Reset_time) begin
        if (Reset_time) begin
            // Reset the time to 00:00:00
            {hours_high, hours_low, minutes_high, minutes_low, seconds_high, seconds_low} <= 24'b0;
        end else if (Set_time) begin
            // Load the input time
            {hours_high, hours_low, minutes_high, minutes_low, seconds_high, seconds_low} <= Time_in;
        end else begin
            // Increment the time
            seconds_low = increment_bcd(seconds_low, 10);
            if (seconds_low == 0) begin
                seconds_high = increment_bcd(seconds_high, 6);
                if (seconds_high == 0) begin
                    minutes_low = increment_bcd(minutes_low, 10);
                    if (minutes_low == 0) begin
                        minutes_high = increment_bcd(minutes_high, 6);
                        if (minutes_high == 0) begin
                            hours_low = increment_bcd(hours_low, 10);
                            if (hours_low == 0 || (hours_high == 2 && hours_low == 4)) begin
                                hours_high = increment_bcd(hours_high, 3);
                            end
                        end
                    end
                end
            end
        end
    end

    // Always block to update the output
    always @(*) begin
        Time_out = {hours_high, hours_low, minutes_high, minutes_low, seconds_high, seconds_low};
    end

endmodule
