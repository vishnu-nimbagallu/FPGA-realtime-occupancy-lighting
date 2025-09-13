## Clock signal
## Bank = 35, Pin name = IO_L12P_T1_MRCC_35, Sch name = CLK100MHZ
set_property PACKAGE_PIN E3 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Reset (manual button mapping to rst_n)
## Bank = 15, Pin name = IO_L3P_T0_DQS_AD1P_15, Sch name = CPU_RESET
set_property PACKAGE_PIN C12 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

## IR Sensors (connect via Pmod JA header)
## JA1 ? entry_sensor
set_property PACKAGE_PIN B13 [get_ports entry_sensor]
set_property IOSTANDARD LVCMOS33 [get_ports entry_sensor]

## JA2 ? exit_sensor
set_property PACKAGE_PIN F14 [get_ports exit_sensor]
set_property IOSTANDARD LVCMOS33 [get_ports exit_sensor]

## LEDs (only 5 used: leds[4:0])
set_property PACKAGE_PIN T8 [get_ports {leds[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[0]}]

set_property PACKAGE_PIN V9 [get_ports {leds[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[1]}]

set_property PACKAGE_PIN R8 [get_ports {leds[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[2]}]

set_property PACKAGE_PIN T6 [get_ports {leds[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[3]}]

set_property PACKAGE_PIN T5 [get_ports {leds[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[4]}]

## 7-segment display segments
set_property PACKAGE_PIN L3 [get_ports {seg[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]

set_property PACKAGE_PIN N1 [get_ports {seg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]

set_property PACKAGE_PIN L5 [get_ports {seg[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]

set_property PACKAGE_PIN L4 [get_ports {seg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]

set_property PACKAGE_PIN K3 [get_ports {seg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]

set_property PACKAGE_PIN M2 [get_ports {seg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]

set_property PACKAGE_PIN L6 [get_ports {seg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

## Decimal point
set_property PACKAGE_PIN M4 [get_ports dp]
set_property IOSTANDARD LVCMOS33 [get_ports dp]

## Anode controls (only 4 used: an[3:0])
set_property PACKAGE_PIN N6 [get_ports {an[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}rd
]

set_property PACKAGE_PIN M6 [get_ports {an[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]

set_property PACKAGE_PIN M3 [get_ports {an[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]

set_property PACKAGE_PIN N5 [get_ports {an[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]
