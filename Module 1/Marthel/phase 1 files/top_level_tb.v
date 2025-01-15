`timescale 1ns / 1ps

module top_level_tb;

    reg clk;               // Clock signal (simulated 100 MHz)
    reg rst;               // Reset signal
    reg button0;           // Simulated start/stop button
    reg button1;           // Simulated reset button
    wire [6:0] seg;        // 7-segment display segments (a-g)
    wire [3:0] an;         // 7-segment display anodes (digits)

    // Instantiate the top-level module
    top_level uut (
        .clk(clk),
        .rst(rst),
        .button0(button0),
        .button1(button1),
        .seg(seg),
        .an(an)
    );

    // ----------------------------------------------------------------------
    // Clock Generation (100 MHz)
    // ----------------------------------------------------------------------
    // This creates a 100 MHz clock with a 10 ns period.
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Toggle every 5 ns
    end

    // ----------------------------------------------------------------------
    // Test Stimulus
    // ----------------------------------------------------------------------
    initial begin
        // Initial conditions
        rst = 1;
        button0 = 0;
        button1 = 0;

        // Wait 100 ns for reset to propagate and stabilize
        #100;
        rst = 0;

        // 1. Press start button (button0) to start the stopwatch
        #500;
        button0 = 1;    // Simulate press
        #1000;
        button0 = 0;    // Release button

        // Let the stopwatch run for a while (10,000 ns)
        #10000;

        // 2. Press start button again to stop the stopwatch
        button0 = 1;    // Simulate press
        #1000;
        button0 = 0;    // Release button

        // Wait for a moment (5,000 ns) while the stopwatch is stopped
        #5000;

        // 3. Press reset button (button1) to reset the stopwatch
        button1 = 1;    // Simulate press
        #1000;
        button1 = 0;    // Release button

        // Let the system idle for a bit (10,000 ns)
        #10000;

        // End the simulation
        $