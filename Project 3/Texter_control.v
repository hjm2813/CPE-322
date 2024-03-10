Texter_control.v 
module texter_control( 
input wire clk,               
input wire reset,         
input wire dash_dit,          
input wire dc_error,          
input wire space,          
output reg nxt_char,          
output reg out_space,     
output reg out_char,          
output reg nxt_bit          
); 
// Define state encoding 
localparam [1:0] 
IDLE = 2'b00, 
PROCESS_BIT = 2'b01, 
// Clock input 
    // Reset signal 
// Dash/Dit input from sat_counter 
// Decoder error signal 
   // Space signal from timing logic 
// Signal to fetch next character 
    // Output space signal 
// Output character signal 
  // Signal to process next bit 
OUTPUT_CHAR = 2'b10, 
OUTPUT_SPACE = 2'b11; 
// State variable 
reg [1:0] current_state, next_state; 
// FSM Next State Logic 
always @(posedge clk or posedge reset) begin 
if (reset) begin 
current_state <= IDLE; 
end else begin 
current_state <= next_state; 
end 
end 
// FSM Transition and Output Logic 
always @(*) begin 
// Default outputs 
nxt_char = 0; 
out_space = 0; 
out_char = 0; 
nxt_bit = 0; 
case (current_state) 
IDLE: begin 
if (dash_dit) begin 
next_state = PROCESS_BIT; 
end else if (space) begin 
next_state = OUTPUT_SPACE; 
end else begin 
next_state = IDLE; 
end 
end 
PROCESS_BIT: begin 
nxt_bit = 1; 
if (dc_error) begin 
// Handle error 
next_state = IDLE; 
end else { 
next_state = OUTPUT_CHAR; 
end 
end 
OUTPUT_CHAR: begin 
out_char = 1; 
next_state = IDLE; 
end 
OUTPUT_SPACE: begin 
out_space = 1; 
next_state = IDLE; 
end 
default: begin 
next_state = IDLE; 
end 
endcase 
end 
endmodule
