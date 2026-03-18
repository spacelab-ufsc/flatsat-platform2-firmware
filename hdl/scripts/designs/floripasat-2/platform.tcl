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

set mi_str [format "%02d" $current_mi]

connect_bd_intf_net [get_bd_intf_pins axi_payload_uart16550/S_AXI] [get_bd_intf_pins axi_cpu_interconnect/M${mi_str}_AXI]
connect_bd_net [get_bd_pins zynq_ps/FCLK_CLK0] [get_bd_pins axi_cpu_interconnect/M${mi_str}_ACLK]
connect_bd_net [get_bd_pins axi_cpu_interconnect/M${mi_str}_ARESETN] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]

connect_bd_net [get_bd_pins axi_payload_uart16550/s_axi_aclk] [get_bd_pins zynq_ps/FCLK_CLK0]
connect_bd_net [get_bd_pins axi_payload_uart16550/s_axi_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
assign_bd_address -offset 0x42000000 -range 64K [get_bd_addr_spaces zynq_ps/Data] [get_bd_addr_segs axi_payload_uart16550/S_AXI/Reg]

# Configure SPI1 for TTC2
set_property -dict [list \
  CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {1} \
] [get_bd_cells zynq_ps]

create_bd_port -dir O -type clk ttc_spi_sck_o
create_bd_port -dir I -type data ttc_spi_io1_i
create_bd_port -dir O -type data ttc_spi_io0_o
create_bd_port -dir O -type data ttc1_spi_ss_o
create_bd_port -dir O -type data ttc0_spi_ss_o

connect_bd_net [get_bd_ports ttc_spi_sck_o] [get_bd_pins zynq_ps/spi1_sclk_o]
connect_bd_net [get_bd_ports ttc_spi_io1_i] [get_bd_pins zynq_ps/spi1_miso_i]
connect_bd_net [get_bd_ports ttc_spi_io0_o] [get_bd_pins zynq_ps/spi1_mosi_o]
connect_bd_net [get_bd_ports ttc0_spi_ss_o] [get_bd_pins zynq_ps/spi1_ss_o]
connect_bd_net [get_bd_ports ttc1_spi_ss_o] [get_bd_pins zynq_ps/spi1_ss1_o]

connect_bd_net [get_bd_pins xlconstant_1/dout] [get_bd_pins zynq_ps/spi1_ss_i]
connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins zynq_ps/spi1_sclk_i]
connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins zynq_ps/spi1_mosi_i]

# EDC GPIO Enables
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_edc
set_property -dict [list \
  CONFIG.C_ALL_INPUTS {0} \
  CONFIG.C_ALL_OUTPUTS {1} \
  CONFIG.C_GPIO_WIDTH {2} \
  CONFIG.C_INTERRUPT_PRESENT {0} \
  CONFIG.C_IS_DUAL {0} \
] [get_bd_cells axi_gpio_edc]

# Create and connect TX and RX signals
create_bd_port -dir O -from 1 -to 0 edc_en_gpio

connect_bd_net [get_bd_pins axi_gpio_edc/gpio_io_o] [get_bd_ports edc_en_gpio]

# Configure GP0 Interconnect
set current_mi [get_property CONFIG.NUM_MI $gp0_ic]
set new_mi [expr {$current_mi + 1}]
set_property CONFIG.NUM_MI $new_mi $gp0_ic

set mi_str [format "%02d" $current_mi]

connect_bd_intf_net [get_bd_intf_pins axi_gpio_edc/S_AXI] [get_bd_intf_pins axi_cpu_interconnect/M${mi_str}_AXI]
connect_bd_net [get_bd_pins zynq_ps/FCLK_CLK0] [get_bd_pins axi_cpu_interconnect/M${mi_str}_ACLK]
connect_bd_net [get_bd_pins axi_cpu_interconnect/M${mi_str}_ARESETN] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]

connect_bd_net [get_bd_pins axi_gpio_edc/s_axi_aclk] [get_bd_pins zynq_ps/FCLK_CLK0]
connect_bd_net [get_bd_pins axi_gpio_edc/s_axi_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
assign_bd_address -offset 0x42010000 -range 64K [get_bd_addr_spaces zynq_ps/Data] [get_bd_addr_segs axi_gpio_edc/S_AXI/Reg]
