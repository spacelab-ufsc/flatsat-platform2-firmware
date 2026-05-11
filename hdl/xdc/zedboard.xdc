# SPI0
set_property -dict {PACKAGE_PIN Y11 IOSTANDARD LVCMOS33 PULLUP TRUE} [get_ports spi0_ss_o]; # JA1
set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS33} [get_ports spi0_sck_o]; # JA2
set_property -dict {PACKAGE_PIN Y10 IOSTANDARD LVCMOS33} [get_ports spi0_io0_o]; # JA3
set_property -dict {PACKAGE_PIN AA9 IOSTANDARD LVCMOS33} [get_ports spi0_io1_i]; # JA4
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33 PULLUP TRUE} [get_ports spi0_ss1_o]; # JB7
set_property -dict {PACKAGE_PIN W10 IOSTANDARD LVCMOS33 PULLUP TRUE} [get_ports spi0_ss2_o]; # JB8

# SPI1
set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS33 PULLUP TRUE} [get_ports spi1_ss_o]; # JA7
set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS33} [get_ports spi1_sck_o]; # JA8
set_property -dict {PACKAGE_PIN AB9 IOSTANDARD LVCMOS33} [get_ports spi1_io0_o]; # JA9
set_property -dict {PACKAGE_PIN AA8 IOSTANDARD LVCMOS33} [get_ports spi1_io1_i]; # JA10
set_property -dict {PACKAGE_PIN V9 IOSTANDARD LVCMOS33 PULLUP TRUE} [get_ports spi1_ss1_o]; # JB9
set_property -dict {PACKAGE_PIN V8 IOSTANDARD LVCMOS33 PULLUP TRUE} [get_ports spi1_ss2_o]; # JB10

# Ctrl GPIOs
set_property -dict {PACKAGE_PIN AB6 IOSTANDARD LVCMOS33} [get_ports ctrl_pins_tri_io[0]]; # JC1_N
set_property -dict {PACKAGE_PIN AB7 IOSTANDARD LVCMOS33} [get_ports ctrl_pins_tri_io[1]]; # JC1_P
set_property -dict {PACKAGE_PIN AA4 IOSTANDARD LVCMOS33} [get_ports ctrl_pins_tri_io[2]]; # JC2_N
set_property -dict {PACKAGE_PIN Y4 IOSTANDARD LVCMOS33} [get_ports ctrl_pins_tri_io[3]]; # JC2_P
set_property -dict {PACKAGE_PIN T6 IOSTANDARD LVCMOS33} [get_ports ctrl_pins_tri_io[4]]; # JC3_N
set_property -dict {PACKAGE_PIN R6 IOSTANDARD LVCMOS33} [get_ports ctrl_pins_tri_io[5]]; # JC3_P
set_property -dict {PACKAGE_PIN U4 IOSTANDARD LVCMOS33} [get_ports ctrl_pins_tri_io[6]]; # JC4_N
set_property -dict {PACKAGE_PIN T4 IOSTANDARD LVCMOS33} [get_ports ctrl_pins_tri_io[7]]; # JC4_P
set_property -dict {PACKAGE_PIN W7 IOSTANDARD LVCMOS33} [get_ports ctrl_pins_tri_io[8]]; # JD1_N
set_property -dict {PACKAGE_PIN V7 IOSTANDARD LVCMOS33} [get_ports ctrl_pins_tri_io[9]]; # JD1_P
set_property -dict {PACKAGE_PIN V4 IOSTANDARD LVCMOS33} [get_ports ctrl_pins_tri_io[10]]; # JD2_N
set_property -dict {PACKAGE_PIN V5 IOSTANDARD LVCMOS33} [get_ports ctrl_pins_tri_io[11]]; # JD2_P
set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports ctrl_pins_tri_io[12]]; # JD3_N

# CAN
set_property -dict {PACKAGE_PIN W12 IOSTANDARD LVCMOS33} [get_ports can_rx]; # JB1
set_property -dict {PACKAGE_PIN W11 IOSTANDARD LVCMOS33} [get_ports can_tx]; # JB2

# I2C
set_property -dict {PACKAGE_PIN V10 IOSTANDARD LVCMOS18} [get_ports {iic_0_sda_io}]; # JB3
set_property -dict {PACKAGE_PIN W8 IOSTANDARD LVCMOS18} [get_ports {iic_0_scl_io}]; # JB4

# Zedboard LEDS
set_property PACKAGE_PIN T22 [get_ports {leds[0]}];
set_property PACKAGE_PIN T21 [get_ports {leds[1]}];
set_property PACKAGE_PIN U22 [get_ports {leds[2]}];
set_property PACKAGE_PIN U21 [get_ports {leds[3]}];
set_property PACKAGE_PIN V22 [get_ports {leds[4]}];
set_property PACKAGE_PIN W22 [get_ports {leds[5]}];
set_property PACKAGE_PIN U19 [get_ports {leds[6]}];
set_property PACKAGE_PIN U14 [get_ports {leds[7]}];

# IO Banks properties
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 33]];

#set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 34]];

#set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 35]];

set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]];

