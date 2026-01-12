# SPDX-License-Identifier: GPL-2.0-only

# PL I2C Constraints
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS18} [get_ports {iic_sens_sda_io}];
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS18} [get_ports {iic_sens_scl_io}];
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS18} [get_ports {iic_0_sda_io}]; # H2-49
set_property -dict {PACKAGE_PIN H20 IOSTANDARD LVCMOS18} [get_ports {iic_0_scl_io}]; # H2-51
set_property -dict {PACKAGE_PIN G18 IOSTANDARD LVCMOS18} [get_ports {iic_1_sda_io}]; # H1-41
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS18} [get_ports {iic_1_scl_io}]; # H1-43

# AXI QUAD SPI Constraints
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS18 PULLUP TRUE} [get_ports ltc2983_spi_ss_o]; # SPI_SS
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS18} [get_ports ltc2983_spi_sck_o]; # SPI_CLK
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS18} [get_ports ltc2983_spi_io0_o]; # SPI_MOSI
set_property -dict {PACKAGE_PIN H18 IOSTANDARD LVCMOS18} [get_ports ltc2983_spi_io1_i]; # SPI_MISO

# LTC2983 interrupt pin
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS18} [get_ports ltc2983_irq_tri_io[0]]; # H2-8

# PWM channels
#set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS18} [get_ports pwm_0]; # H1-26
#set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS18} [get_ports pwm_1]; # H1-25
#set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS18} [get_ports pwm_2]; # H2-23
#set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS18} [get_ports pwm_3]; # H2-24
#set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS18} [get_ports pwm_4]; # H1-24
#set_property -dict {PACKAGE_PIN T20 IOSTANDARD LVCMOS18} [get_ports pwm_5]; # H1-23
#set_property -dict {PACKAGE_PIN W20 IOSTANDARD LVCMOS18} [get_ports pwm_6]; # H2-21
#set_property -dict {PACKAGE_PIN U20 IOSTANDARD LVCMOS18} [get_ports pwm_7]; # H2-22

set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 35]];
