`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2025 22:07:39
// Design Name: 
// Module Name: hall_lighting_system
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





module hall_lighting_system(
    input clk,                    // 100MHz clock
    input rst_n,                  // Active low reset
    input entry_sensor,           // Entry IR sensor input
    input exit_sensor,            // Exit IR sensor input
    output reg [6:0] seg,         // 7-segment display segments (a-g)
    output reg [3:0] an,          // 7-seg digit enables (active low)
    output reg [4:0] leds,        // 5 LEDs for occupancy indication
    output reg dp                 // Decimal point (not used)
);

    parameter MAX_COUNT = 30;     
    parameter DEBOUNCE_LIMIT = 20_000_00; // ~20ms at 100MHz

    reg [4:0] occupancy_count;

    // ====================================================
    // === Entry Sensor Debounce + One-pulse
    // ====================================================
    reg entry_sync0, entry_sync1;
    reg [21:0] entry_debounce_cnt;
    reg entry_stable;
    reg entry_prev;
    wire entry_rising;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            entry_sync0 <= 0; entry_sync1 <= 0;
        end else begin
            entry_sync0 <= entry_sensor;
            entry_sync1 <= entry_sync0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            entry_debounce_cnt <= 0; entry_stable <= 0;
        end else if (entry_sync1 != entry_stable) begin
            entry_debounce_cnt <= entry_debounce_cnt + 1;
            if (entry_debounce_cnt >= DEBOUNCE_LIMIT) begin
                entry_stable <= entry_sync1;
                entry_debounce_cnt <= 0;
            end
        end else begin
            entry_debounce_cnt <= 0;
        end
    end

    assign entry_rising = (entry_stable & ~entry_prev);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) entry_prev <= 0;
        else entry_prev <= entry_stable;
    end

    // ====================================================
    // === Exit Sensor Debounce + One-pulse
    // ====================================================
    reg exit_sync0, exit_sync1;
    reg [21:0] exit_debounce_cnt;
    reg exit_stable;
    reg exit_prev;
    wire exit_rising;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            exit_sync0 <= 0; exit_sync1 <= 0;
        end else begin
            exit_sync0 <= exit_sensor;
            exit_sync1 <= exit_sync0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            exit_debounce_cnt <= 0; exit_stable <= 0;
        end else if (exit_sync1 != exit_stable) begin
            exit_debounce_cnt <= exit_debounce_cnt + 1;
            if (exit_debounce_cnt >= DEBOUNCE_LIMIT) begin
                exit_stable <= exit_sync1;
                exit_debounce_cnt <= 0;
            end
        end else begin
            exit_debounce_cnt <= 0;
        end
    end

    assign exit_rising = (exit_stable & ~exit_prev);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) exit_prev <= 0;
        else exit_prev <= exit_stable;
    end

    // ====================================================
    // === Occupancy Counter
    // ====================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            occupancy_count <= 0;
        else begin
            if (entry_rising && occupancy_count < MAX_COUNT)
                occupancy_count <= occupancy_count + 1;
            else if (exit_rising && occupancy_count > 0)
                occupancy_count <= occupancy_count - 1;
        end
    end

    // ====================================================
    // === LED control (1 LED per 6 people)
    // ====================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            leds <= 5'b00000;
        else begin
            case ((occupancy_count + 5) / 6)
                0: leds <= 5'b00000; 
                1: leds <= 5'b00001; 
                2: leds <= 5'b00011; 
                3: leds <= 5'b00111; 
                4: leds <= 5'b01111; 
                default: leds <= 5'b11111; 
            endcase
        end
    end

    // ====================================================
    // === 7-segment display - FIXED VERSION
    // ====================================================
    reg [6:0] seg_lut [0:9];
    initial begin
                    //  abcdefg
        seg_lut[0] = 7'b1000000; // 0
        seg_lut[1] = 7'b1001111; // 1
        seg_lut[2] = 7'b0100100; // 2  0010010
        seg_lut[3] = 7'b0110000; // 3
        seg_lut[4] = 7'b0011001; // 4
        seg_lut[5] = 7'b0010010; // 5 0100100
        seg_lut[6] = 7'b0000010; // 6
        seg_lut[7] = 7'b1111000; // 7
        seg_lut[8] = 7'b0000000; // 8
        seg_lut[9] = 7'b0010000; // 9
    end

    // Calculate tens and ones digits
    wire [3:0] tens = occupancy_count / 10;
    wire [3:0] ones = occupancy_count % 10;

    // Refresh counter for multiplexing
    reg [15:0] refresh_counter;
    reg [1:0] digit_sel;  // 0 = ones, 1 = tens, 2-3 = off

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            refresh_counter <= 0;
            digit_sel <= 0;
        end else begin
            refresh_counter <= refresh_counter + 1;
            if (refresh_counter == 10000) begin  // Faster refresh rate
                digit_sel <= digit_sel + 1;
                refresh_counter <= 0;
            end
        end
    end

    // Display multiplexing logic
    always @(*) begin
        dp = 1'b1; // Decimal point off
        
        case(digit_sel)
            0: begin  // Display ones digit
                seg = seg_lut[ones];
                an = 4'b1110; // Enable rightmost digit
            end
            1: begin  // Display tens digit
                if (occupancy_count >= 10) begin
                    seg = seg_lut[tens];
                end else begin
                    seg = 7'b1111111; // Blank if less than 10
                end
                an = 4'b1101; // Enable second digit from right
            end
            default: begin  // Other digits off
                seg = 7'b1111111;
                an = 4'b1111;
            end
        endcase
    end

endmodule


// Top module for your FPGA board
module top_hall_lighting(
    input clk,
    input rst_n,
    input entry_sensor,
    input exit_sensor,
    output [6:0] seg,
    output [3:0] an,
    output [4:0] leds,
    output dp
);

    hall_lighting_system uut (
        .clk(clk),
        .rst_n(rst_n),
        .entry_sensor(entry_sensor),
        .exit_sensor(exit_sensor),
        .seg(seg),
        .an(an),
        .leds(leds),
        .dp(dp)
    );

endmodule