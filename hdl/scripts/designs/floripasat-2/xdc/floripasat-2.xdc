# SPDX-License-Identifier: GPL-2.0-only

# Payload UART Constraints
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS18} [get_ports {payload_uart16550_tx}];
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS18} [get_ports {payload_uart16550_rx}];

# TTC SPI
set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS18 PULLUP TRUE} [get_ports ttc1_spi_ss_o]; # SPI_SS TTC 1
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS18 PULLUP TRUE} [get_ports ttc0_spi_ss_o]; # SPI_SS TTC 0
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS18} [get_ports ttc_spi_sck_o]; # SPI_CLK
set_property -dict {PACKAGE_PIN A20 IOSTANDARD LVCMOS18} [get_ports ttc_spi_io0_o]; # SPI_MOSI
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS18} [get_ports ttc_spi_io1_i]; # SPI_MISO

# EDC GPIO
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS18} [get_ports {edc_en_gpio[0]}];
set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS18} [get_ports {edc_en_gpio[1]}];
