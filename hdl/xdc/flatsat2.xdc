# SPDX-License-Identifier: GPL-2.0-only

# PS I2C Constraints
set_property PACKAGE_PIN H20 [get_ports {IIC_0_scl_io}];  # "H20.JX2_LVDS_17_N.JX2.70.LA29_N"
set_property PACKAGE_PIN G19 [get_ports {IIC_0_sda_io}];  # "G19.JX2_LVDS_16_P.JX2.67.PB0"
set_property PACKAGE_PIN K18 [get_ports {IIC_1_sda_io}];  # "K18.JX2_LVDS_11_N.JX2.50.CLK1_M2C_N"
set_property PACKAGE_PIN L17 [get_ports {IIC_1_scl_io}];  # "L17.JX2_LVDS_10_N.JX2.49.JA0-1_N" - JA - Pin 2

set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 35]];
