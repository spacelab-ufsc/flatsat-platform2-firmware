# SPDX-License-Identifier: GPL-2.0-only

# PL I2C Constraints
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS18} [get_ports {iic_sens_sda_io}];
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS18} [get_ports {iic_sens_scl_io}];
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS18} [get_ports {iic_0_sda_io}];
set_property -dict {PACKAGE_PIN H20 IOSTANDARD LVCMOS18} [get_ports {iic_0_scl_io}];

set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS18 PULLUP TRUE} [get_ports ltc2983_spi_ss_io[0]]; # SPI_ENB
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS18} [get_ports ltc2983_spi_sck_io]; # SPI_CLK
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS18} [get_ports ltc2983_spi_io1_io]; # SPI_MISO
set_property -dict {PACKAGE_PIN H18 IOSTANDARD LVCMOS18} [get_ports ltc2983_spi_io0_io]; # SPI_MOSI

set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 35]];
