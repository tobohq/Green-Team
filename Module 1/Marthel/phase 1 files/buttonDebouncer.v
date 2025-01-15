module buttonDebouncer (
    input clk,          // Clock input signal
    input reset,        // Active-high reset signal to initialize the debouncer
    input button_in,    // Raw input from the button
    output reg button_out // Processed output with debounce and edge detection
);


// Generate the remaining module code using an AI language model, maintaining the specified inputs and outputs.
// Parameter for debounce time (in clock cycles)
    parameter DEBOUNCE_TIME = 100000;  // Adjust this value as needed (100ms for 100MHz clock)
    
    // Internal signal to count clock cycles for debouncing
    reg [17:0] debounce_counter;  // 18-bit counter for debouncing
    reg button_sync_0, button_sync_1;  // Synchronizers for the input signal
    reg button_reg;  // Register to hold the stable button state

    // Edge detection signals
    reg button_out_reg; // Register to hold the debounced output

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            debounce_counter <= 0;
            button_sync_0 <= 0;
            button_sync_1 <= 0;
            button_reg <= 0;
            button_out_reg <= 0;
            button_out <= 0;
        end else begin
            // Synchronize the button input to the clock domain
            button_sync_0 <= button_in;
            button_sync_1 <= button_sync_0;

            // If button state changes, reset debounce counter
            if (button_sync_1 != button_reg) begin
                debounce_counter <= 0;
                button_reg <= button_sync_1;
            end else if (debounce_counter < DEBOUNCE_TIME) begin
                // Count the clock cycles to debounce
                debounce_counter <= debounce_counter + 1;
            end else if (debounce_counter == DEBOUNCE_TIME) begin
                // Once debounce time is complete, update the output register
                button_out_reg <= button_reg;
            end

            // Output the debounced button signal
            button_out <= button_out_reg;
        end
    end

endmodule
