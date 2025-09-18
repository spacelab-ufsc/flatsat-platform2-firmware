# SPDX-License-Identifier: GPL-2.0-only

# PL I2C Constraints
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS18} [get_ports {iic_sens_sda_io}];
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS18} [get_ports {iic_sens_scl_io}];
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS18} [get_ports {iic_0_sda_io}];
set_property -dict {PACKAGE_PIN H20 IOSTANDARD LVCMOS18} [get_ports {iic_0_scl_io}];
set_property -dict {PACKAGE_PIN G18 IOSTANDARD LVCMOS18} [get_ports {iic_1_sda_io}];
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS18} [get_ports {iic_1_scl_io}];

# AXI QUAD SPI Constraints
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS18 PULLUP TRUE} [get_ports ltc2983_spi_ss_o]; # SPI_SS
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS18} [get_ports ltc2983_spi_sck_o]; # SPI_CLK
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS18} [get_ports ltc2983_spi_io0_o]; # SPI_MOSI
set_property -dict {PACKAGE_PIN H18 IOSTANDARD LVCMOS18} [get_ports ltc2983_spi_io1_i]; # SPI_MISO

# LTC2983 interrupt pin
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS18} [get_ports ltc2983_irq];

# PWM channels
set_property -dict {PACKAGE_PIN K14 IOSTANDARD LVCMOS18} [get_ports pwm_0];

set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 35]];
