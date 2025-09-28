# SPDX-License-Identifier: GPL-2.0-only

puts "FloripaSat-2 Platform Design"
puts "============================"

set platform_constraints "$platform_dir/xdc/floripasat-2.xdc"
import_files -fileset constrs_1 $platform_constraints

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_payload_uart16550

# Remove constant from UART IRQ number
disconnect_bd_net /xlconstant_0_dout [get_bd_pins irq_concat/In15]

# Connect UART interrupt 
connect_bd_net [get_bd_pins axi_payload_uart16550/ip2intc_irpt] [get_bd_pins irq_concat/In15]

# Create and connect TX and RX signals
create_bd_port -dir O payload_uart16550_tx
create_bd_port -dir I payload_uart16550_rx

connect_bd_net [get_bd_pins axi_payload_uart16550/sout] [get_bd_ports payload_uart16550_tx]
connect_bd_net [get_bd_ports payload_uart16550_rx] [get_bd_pins axi_payload_uart16550/sin]

# Configure GP0 Interconnect
set gp0_ic [get_bd_cells axi_cpu_interconnect]
set current_mi [get_property CONFIG.NUM_MI $gp0_ic]
set new_mi [expr {$current_mi + 1}]
set_property CONFIG.NUM_MI $new_mi $gp0_ic

connect_bd_intf_net [get_bd_intf_pins axi_payload_uart16550/S_AXI] [get_bd_intf_pins axi_cpu_interconnect/M${current_mi}_AXI]
connect_bd_net [get_bd_pins zynq_ps/FCLK_CLK0] [get_bd_pins axi_cpu_interconnect/M${current_mi}_ACLK]
connect_bd_net [get_bd_pins axi_cpu_interconnect/M${current_mi}_ARESETN] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]

connect_bd_net [get_bd_pins axi_payload_uart16550/s_axi_aclk] [get_bd_pins zynq_ps/FCLK_CLK0]
connect_bd_net [get_bd_pins axi_payload_uart16550/s_axi_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
assign_bd_address -offset 0x42000000 -range 64K [get_bd_addr_spaces zynq_ps/Data] [get_bd_addr_segs axi_payload_uart16550/S_AXI/Reg]
