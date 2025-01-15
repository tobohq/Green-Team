module stopwatch (
    input wire clk,               // Slow clock (e.g., 1 kHz from clock divider)
    input wire rst,               // Reset signal
    input wire start_stop,        // Debounced start/stop button input
    input wire reset_button,      // Debounced reset button input
    output reg [15:0] time_out    // BCD output for seven-segment display (HH:MM)
);


    // Internal signal to track whether stopwatch is running (1) or stopped (0).
    reg running;

    // ----------------------------------------------------------------------
    // 1) Synchronous Logic
    // ----------------------------------------------------------------------
    // On each rising edge of the clock:
    //  - Check reset first
    //  - Check reset_button, start_stop, then increment if running
    // ----------------------------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            // Initialize to 00:00 and stop the stopwatch
            time_out <= 16'h0000;  
            running  <= 1'b0;
        end else begin
            // Handle 'reset_button' => clear the time
            if (reset_button) begin
                time_out <= 16'h0000;
            end

            // Handle 'start_stop' => toggle running
            if (start_stop) begin
                running <= ~running;
            end

            // If running, increment the BCD time
            if (running) begin
                time_out <= bcd_increment(time_out);
            end
        end
    end

    // ----------------------------------------------------------------------
    // 2) BCD Increment Function
    // ----------------------------------------------------------------------
    // Increments the 4-digit BCD value (HH:MM) by 1 minute.  
    // Range: 00:00 -> 99:59; wraps around to 00:00 after 99:59.
    // ----------------------------------------------------------------------
    function [15:0] bcd_increment(input [15:0] bcd_val);
        reg [3:0] h_tens, h_ones, m_tens, m_ones;
    begin
        // Extract each nibble
        h_tens = bcd_val[15:12];
        h_ones = bcd_val[11: 8];
        m_tens = bcd_val[ 7: 4];
        m_ones = bcd_val[ 3: 0];

        // Increment the minutes
        m_ones = m_ones + 1'b1;

        // Handle carry from minute ones
        if (m_ones == 4'd10) begin
            m_ones = 4'd0;
            m_tens = m_tens + 1'b1;
            // Handle carry from minute tens
            if (m_tens == 4'd6) begin
                m_tens = 4'd0;
                h_ones = h_ones + 1'b1;
                // Handle carry from hour ones
                if (h_ones == 4'd10) begin
                    h_ones = 4'd0;
                    h_tens = h_tens + 1'b1;
                    // Handle carry from hour tens (wrap after 99:59 to 00:00)
                    if (h_tens == 4'd10) begin
               