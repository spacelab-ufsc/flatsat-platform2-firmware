# SPDX-License-Identifier: GPL-2.0-only

# Payload UART Constraints
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS18} [get_ports {payload_uart16550_tx}];
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS18} [get_ports {payload_uart16550_rx}];
