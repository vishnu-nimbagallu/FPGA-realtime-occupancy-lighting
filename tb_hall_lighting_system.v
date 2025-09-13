`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2025 22:09:51
// Design Name: 
// Module Name: tb_hall_lighting_system
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////




module tb_hall_lighting;
    // Inputs
    reg clk;
    reg rst_n;
    reg entry_sensor;
    reg exit_sensor;
    
    // Outputs
    wire [6:0] seg;
    wire [4:0] leds;
    wire dp;
    wire [3:0] an;
    
    // Instantiate top module
    top_hall_lighting uut (
        .clk(clk),
        .rst_n(rst_n),
        .entry_sensor(entry_sensor),
        .exit_sensor(exit_sensor),
        .seg(seg),
        .leds(leds),
        .dp(dp),
        .an(an)
    );
    
    // Clock generation (100MHz)
    always #5 clk = ~clk;
    
    // Test sequence
    initial begin
        // Initialize
        clk = 0;
        rst_n = 0;
        entry_sensor = 0;
        exit_sensor = 0;
        
        // Apply reset
        #100 rst_n = 1;
        
        // Test single entry
        $display("Testing single entry...");
        #100 entry_sensor = 1;
        #1000000; // Wait for debounce
        entry_sensor = 0;
        #1000000; // Wait for debounce
        $display("Count: %d, LEDs: %b", uut.uut.occupancy_count, leds);
        
        // Test another entry
        $display("Testing another entry...");
        #100 entry_sensor = 1;
        #1000000; // Wait for debounce
        entry_sensor = 0;
        #1000000; // Wait for debounce
        $display("Count: %d, LEDs: %b", uut.uut.occupancy_count, leds);
        
        // Test exit
        $display("Testing exit...");
        #100 exit_sensor = 1;
        #1000000; // Wait for debounce
        exit_sensor = 0;
        #1000000; // Wait for debounce
        $display("Count: %d, LEDs: %b", uut.uut.occupancy_count, leds);
        
        $display("Test completed!");
        $finish;
    end

endmodule