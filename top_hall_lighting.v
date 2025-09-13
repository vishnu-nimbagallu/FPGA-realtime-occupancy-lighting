`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2025 22:20:20
// Design Name: 
// Module Name: top_hall_lighting
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


module top_hall_lighting_system(
    input clk,
    input rst_n,
    input entry_sensor,
    input exit_sensor,
    output [6:0] seg,
    output [4:0] leds,
    output dp,
    output [3:0] an
);

    // Instantiate the main hall lighting system
    hall_lighting_system uut (
        .clk(clk),
        .rst_n(rst_n),
        .entry_sensor(entry_sensor),
        .exit_sensor(exit_sensor),
        .seg(seg),
        .leds(leds),
        .dp(dp)
    );
    
    // Only enable the rightmost digit (AN0)
    assign an = 4'b1110; // AN0 low (enabled), others high (disabled)

endmodule