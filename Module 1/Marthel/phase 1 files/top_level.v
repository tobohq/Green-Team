module top_level(
    input wire clk,               // 100 MHz clock input from Basys 3 board
    input wire rst,               // Reset signal
    input wire button0,           // Button 0 input
    input wire button1,           // Button 1 input
    output wire [6:0] seg,        // 7-segment display segments (a-g)
    output wire [3:0] an          // 7-segment display anodes (digits)
);

    //----------------------------------------------------------------------
    // 1) Clock Divider
    //    Generates a slower clock, for example 1 Hz or 1 kHz, for the stopwatch.
    //----------------------------------------------------------------------
    wire clk_div;  // Slower clock for stopwatch (e.g., 1Hz)

    clock_divider clk_div_inst (
        .clk_in(clk),
        .reset(rst),
        .clk_out(clk_div)
    );

    //----------------------------------------------------------------------
    // 2) Button Debouncers
    //----------------------------------------------------------------------
    wire button0_debounced;
    wire button1_debounced;

    // Debounce for button0 (start/stop)
    buttonDebouncer db0_inst (
        .clk(clk),               // Using 100 MHz clock for debouncing
        .reset(rst),
        .button_in(button0),
        .button_out(button0_debounced)
    );

    // Debounce for button1 (reset)
    buttonDebouncer db1_inst (
        .clk(clk),               // Using 100 MHz clock for debouncing
        .reset(rst),
        .button_in(button1),
        .button_out(button1_debounced)
    );

    //----------------------------------------------------------------------
    // 3) Stopwatch Module
    //    Uses the slow clock (clk_div) and the debounced buttons.
    //----------------------------------------------------------------------
    wire [15:0] stopwatch_data;  // 4-digit (BCD) output for HH:MM

    stopwatch my_stopwatch (
//        .clk         (clk_div),              // Slow clock (e.g., 1 Hz)
        .clk         (clk),              // original clock (e.g., 1 Hz)
        .rst         (rst),
        .start_stop  (button0_debounced),    // Start/Stop toggle
        .reset_button(button1_debounced),    // Reset to 00:00
        .time_out    (stopwatch_data)        // HH:MM in BCD
    );

    //----------------------------------------------------------------------
    // 4) Seve