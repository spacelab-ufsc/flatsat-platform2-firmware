# SPDX-License-Identifier: GPL-2.0-only

source $script_dir/zynq_ps.tcl

namespace eval ::fsat_bd {
    proc create_base_design {name version} {
        create_bd_design $name -mode batch
        current_bd_design $name

        set parentCell [get_bd_cells /]
        set parentObj [get_bd_cells $parentCell]
        current_bd_instance $parentObj

        set ddr [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr]
        set fixed_io [create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 fixed_io]
        set iic_sens [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_sens]
        set iic_0 [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_0]
        set iic_1 [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_1]
        set zynq_ps [create_zynq_ps]

        # Main processor reset
        set proc_sys_reset_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0]

        # Ground for SDIO_WP
        set xlconstant_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0]
        set_property CONFIG.CONST_VAL {0} $xlconstant_0
        
        # VCC for AXI Quad SPI
        set xlconstant_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1]
        set_property CONFIG.CONST_VAL {1} $xlconstant_1

        # F2P interrupt concat
        set irq_concat [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 irq_concat]
        set_property -dict [list CONFIG.NUM_PORTS {16}] $irq_concat
        
        # Main processor interconnect GP0
        set axi_gp0 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_cpu_interconnect]
        set_property -dict [list CONFIG.NUM_MI {4} CONFIG.NUM_SI {1}] $axi_gp0

        # Clock Wizard
        #set clock_wiz [create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0]
        #set_property -dict [list \
        #    CONFIG.CLKOUT1_DRIVES {BUFG} \
        #    CONFIG.CLKOUT1_JITTER {191.387} \
        #    CONFIG.CLKOUT1_PHASE_ERROR {98.575} \
        #    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {16.0000} \
        #    CONFIG.CLKOUT2_DRIVES {BUFG} \
        #    CONFIG.CLKOUT3_DRIVES {BUFG} \
        #    CONFIG.CLKOUT4_DRIVES {BUFG} \
        #    CONFIG.CLKOUT5_DRIVES {BUFG} \
        #    CONFIG.CLKOUT6_DRIVES {BUFG} \
        #    CONFIG.CLKOUT7_DRIVES {BUFG} \
        #    CONFIG.ENABLE_CLOCK_MONITOR {false} \
        #    CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
        #    CONFIG.MMCM_BANDWIDTH {OPTIMIZED} \
        #    CONFIG.MMCM_CLKFBOUT_MULT_F {10.000} \
        #    CONFIG.MMCM_CLKOUT0_DIVIDE_F {62.500} \
        #    CONFIG.MMCM_COMPENSATION {ZHOLD} \
        #    CONFIG.PRIMITIVE {MMCM} \
        #    CONFIG.USE_LOCKED {false} \
        #    CONFIG.RESET_TYPE {ACTIVE_LOW} \
        #] $clock_wiz

        # IIC for sensors
        set axi_iic [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 axi_iic_sens_0]
        set_property -dict [list \
            CONFIG.IIC_FREQ_KHZ {400} \
        ] $axi_iic

        # IIC for open drain translator
        set axi_iic_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 axi_iic_0]
        set_property -dict [list \
            CONFIG.IIC_FREQ_KHZ {100} \
        ] $axi_iic_0

        set axi_iic_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 axi_iic_1]
        set_property -dict [list \
            CONFIG.IIC_FREQ_KHZ {100} \
        ] $axi_iic_1
        
        # SPI core for LTC2983
        #set ltc_spi [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_quad_spi_0]
        #set_property -dict [list \
        #    CONFIG.C_USE_STARTUP {0} \
        #    CONFIG.C_SPI_MODE {0} \
        #    CONFIG.Master_mode {1} \
        #    CONFIG.C_NUM_SS_BITS {1} \
        #    CONFIG.C_NUM_TRANSFER_BITS {8} \
        #    CONFIG.C_FIFO_DEPTH {16} \
        #    CONFIG.Multiples16 {2} \
        #] $ltc_spi

        # Expose GPIO EMIO for LTC2983 irq pin
        set_property -dict [list \
            CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} \
            CONFIG.PCW_GPIO_EMIO_GPIO_IO {1} \
        ] $zynq_ps

        # AXI Timer as PWM
        create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_0

        set_property -dict [list \
            CONFIG.C_TRIG0_ASSERT {Rising} \
            CONFIG.C_TRIG1_ASSERT {Rising} \
            CONFIG.C_ONE_TIMER_ONLY {0} \
            CONFIG.C_COUNT_WIDTH {32} \
            CONFIG.C_GEN0_ASSERT {Rising} \
            CONFIG.C_GEN1_ASSERT {Rising} \
        ] [get_bd_cells axi_timer_0]


        # Fixed IO and DDR
        connect_bd_intf_net -intf_net zynq_ps_ddr [get_bd_intf_ports ddr] [get_bd_intf_pins zynq_ps/DDR]
        connect_bd_intf_net -intf_net zynq_ps_fixed_io [get_bd_intf_ports fixed_io] [get_bd_intf_pins zynq_ps/FIXED_IO]

        # GP0 Interconnect
        connect_bd_intf_net -intf_net gp0_interconnect [get_bd_intf_pins zynq_ps/M_AXI_GP0] [get_bd_intf_pins axi_cpu_interconnect/S00_AXI]
        connect_bd_net [get_bd_pins zynq_ps/FCLK_CLK0] [get_bd_pins axi_cpu_interconnect/ACLK]
        connect_bd_net [get_bd_pins zynq_ps/FCLK_CLK0] [get_bd_pins axi_cpu_interconnect/S00_ACLK]
        connect_bd_net [get_bd_pins zynq_ps/FCLK_CLK0] [get_bd_pins axi_cpu_interconnect/M00_ACLK]
        connect_bd_net [get_bd_pins zynq_ps/FCLK_CLK0] [get_bd_pins axi_cpu_interconnect/M01_ACLK]
        connect_bd_net [get_bd_pins zynq_ps/FCLK_CLK0] [get_bd_pins axi_cpu_interconnect/M02_ACLK]
        connect_bd_net [get_bd_pins zynq_ps/FCLK_CLK0] [get_bd_pins axi_cpu_interconnect/M03_ACLK]
        connect_bd_net [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins axi_cpu_interconnect/ARESETN]
        connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_cpu_interconnect/S00_ARESETN]
        connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_cpu_interconnect/M00_ARESETN]
        connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_cpu_interconnect/M01_ARESETN]
        connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_cpu_interconnect/M02_ARESETN]
        connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_cpu_interconnect/M03_ARESETN]

        # Clock Wizard
        #connect_bd_net [get_bd_pins clk_wiz_0/resetn] [get_bd_pins zynq_ps/FCLK_RESET0_N]
        #connect_bd_net [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins zynq_ps/FCLK_CLK0]

        # LTC2983 SPI interface
        create_bd_port -dir I -type data ltc2983_irq
        create_bd_port -dir O -type clk ltc2983_spi_sck_o
        create_bd_port -dir I -type data ltc2983_spi_io1_i
        create_bd_port -dir O -type data ltc2983_spi_io0_o
        create_bd_port -dir O -type data ltc2983_spi_ss_o
        connect_bd_net [get_bd_ports ltc2983_irq] [get_bd_pins zynq_ps/GPIO_I]
        
        connect_bd_net [get_bd_ports ltc2983_spi_sck_o] [get_bd_pins zynq_ps/SPI0_SCLK_o]
        connect_bd_net [get_bd_ports ltc2983_spi_io1_i] [get_bd_pins zynq_ps/SPI0_MISO_i]
        connect_bd_net [get_bd_ports ltc2983_spi_io0_o] [get_bd_pins zynq_ps/SPI0_MOSI_o]
        connect_bd_net [get_bd_ports ltc2983_spi_ss_o] [get_bd_pins zynq_ps/SPI0_SS_o]

        connect_bd_net [get_bd_pins xlconstant_1/dout] [get_bd_pins zynq_ps/SPI0_SS_i]
        #connect_bd_net [get_bd_pins xlconstant_1/dout] [get_bd_pins zynq_ps/SPI0_SS1_i]
        #connect_bd_net [get_bd_pins xlconstant_1/dout] [get_bd_pins zynq_ps/SPI0_SS2_i]
        connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins zynq_ps/SPI0_SCLK_i]
        connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins zynq_ps/SPI0_MOSI_i]

        #connect_bd_intf_net [get_bd_intf_pins axi_quad_spi_0/AXI_LITE] [get_bd_intf_pins axi_cpu_interconnect/M01_AXI]
        #connect_bd_net [get_bd_pins axi_quad_spi_0/s_axi_aclk] [get_bd_pins zynq_ps/FCLK_CLK0]
        #connect_bd_net [get_bd_pins axi_quad_spi_0/ext_spi_clk] [get_bd_pins clk_wiz_0/clk_out1]
        #connect_bd_net [get_bd_pins axi_quad_spi_0/s_axi_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
        #connect_bd_net [get_bd_pins axi_quad_spi_0/ip2intc_irpt] [get_bd_pins irq_concat/In1]
        #connect_bd_net [get_bd_pins xlconstant_1/dout] [get_bd_pins axi_quad_spi_0/ss_i]
        #connect_bd_net [get_bd_ports ltc2983_spi_sck_o] [get_bd_pins axi_quad_spi_0/sck_o]
        #connect_bd_net [get_bd_ports ltc2983_spi_io1_i] [get_bd_pins axi_quad_spi_0/io1_i]
        #connect_bd_net [get_bd_ports ltc2983_spi_io0_o] [get_bd_pins axi_quad_spi_0/io0_o]
        #connect_bd_net [get_bd_ports ltc2983_spi_ss_o] [get_bd_pins axi_quad_spi_0/ss_o]
        #assign_bd_address -offset 0x41610000 -range 64K [get_bd_addr_spaces zynq_ps/Data] [get_bd_addr_segs axi_quad_spi_0/AXI_LITE/Reg]

        # Embedded I2C Sensors axi_iic
        connect_bd_intf_net [get_bd_intf_pins axi_iic_sens_0/S_AXI] [get_bd_intf_pins axi_cpu_interconnect/M00_AXI]
        connect_bd_net [get_bd_pins axi_iic_sens_0/s_axi_aclk] [get_bd_pins zynq_ps/FCLK_CLK0]
        connect_bd_net [get_bd_pins axi_iic_sens_0/s_axi_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
        connect_bd_intf_net [get_bd_intf_pins iic_sens] [get_bd_intf_pins axi_iic_sens_0/IIC]
        connect_bd_net [get_bd_pins axi_iic_sens_0/iic2intc_irpt] [get_bd_pins irq_concat/In0]
        assign_bd_address -offset 0x41600000 -range 64K [get_bd_addr_spaces zynq_ps/Data] [get_bd_addr_segs axi_iic_sens_0/S_AXI/Reg]
        
        # I2C axi_iic for open drain translator
        connect_bd_intf_net [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins axi_cpu_interconnect/M02_AXI]
        connect_bd_net [get_bd_pins axi_iic_0/s_axi_aclk] [get_bd_pins zynq_ps/FCLK_CLK0]
        connect_bd_net [get_bd_pins axi_iic_0/s_axi_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
        connect_bd_intf_net [get_bd_intf_pins iic_0] [get_bd_intf_pins axi_iic_0/IIC]
        connect_bd_net [get_bd_pins axi_iic_0/iic2intc_irpt] [get_bd_pins irq_concat/In2]
        assign_bd_address -offset 0x41620000 -range 64K [get_bd_addr_spaces zynq_ps/Data] [get_bd_addr_segs axi_iic_0/S_AXI/Reg]

        # I2C axi_iic for second open drain translator
        connect_bd_intf_net [get_bd_intf_pins axi_iic_1/S_AXI] [get_bd_intf_pins axi_cpu_interconnect/M03_AXI]
        connect_bd_net [get_bd_pins axi_iic_1/s_axi_aclk] [get_bd_pins zynq_ps/FCLK_CLK0]
        connect_bd_net [get_bd_pins axi_iic_1/s_axi_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
        connect_bd_intf_net [get_bd_intf_pins iic_1] [get_bd_intf_pins axi_iic_1/IIC]
        connect_bd_net [get_bd_pins axi_iic_1/iic2intc_irpt] [get_bd_pins irq_concat/In3]
        assign_bd_address -offset 0x41630000 -range 64K [get_bd_addr_spaces zynq_ps/Data] [get_bd_addr_segs axi_iic_1/S_AXI/Reg]

        # AXI Timer as PWM
        create_bd_port -dir O -type data pwm_0
        connect_bd_intf_net [get_bd_intf_pins axi_timer_0/S_AXI] [get_bd_intf_pins axi_cpu_interconnect/M01_AXI]
        connect_bd_net [get_bd_pins axi_timer_0/s_axi_aclk] [get_bd_pins zynq_ps/FCLK_CLK0]
        connect_bd_net [get_bd_pins axi_timer_0/s_axi_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
        connect_bd_net [get_bd_pins axi_timer_0/interrupt] [get_bd_pins irq_concat/In1]
        connect_bd_net [get_bd_pins axi_timer_0/pwm0] [get_bd_ports pwm_0]
        assign_bd_address -offset 0x41700000 -range 64K [get_bd_addr_spaces zynq_ps/Data] [get_bd_addr_segs axi_timer_0/S_AXI/Reg]

        # System Reset
        connect_bd_net -net zynq_ps_fclk_clk0 [get_bd_pins zynq_ps/FCLK_CLK0] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins zynq_ps/M_AXI_GP0_ACLK]
        connect_bd_net -net zynq_ps_fclk_reset0_n [get_bd_pins zynq_ps/FCLK_RESET0_N] [get_bd_pins proc_sys_reset_0/ext_reset_in]
        connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconstant_0/dout] [get_bd_pins zynq_ps/SDIO0_WP]

        # Fabric Interrupt
        connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins irq_concat/In4]
        connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins irq_concat/In5]
        connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins irq_concat/In6]
        connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins irq_concat/In7]
        connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins irq_concat/In8]
        connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins irq_concat/In9]
        connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins irq_concat/In10]
        connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins irq_concat/In11]
        connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins irq_concat/In12]
        connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins irq_concat/In13]
        connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins irq_concat/In14]
        connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins irq_concat/In15]
        connect_bd_net [get_bd_pins irq_concat/dout] [get_bd_pins zynq_ps/IRQ_F2P]

        # Disable Zynq PS 
        set_property -dict [list \
            CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {0} \
            CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0} \
        ] $zynq_ps

        # Set PFM properties
        set_property SYNTH_CHECKPOINT_MODE "Hierarchical" [get_files [current_bd_design].bd] 
        set_property PFM_NAME "spacelab.ufsc.br:sl:$name:$version" [get_files [current_bd_design].bd]
        set_property PFM.AXI_PORT {
            M_AXI_GP1 {memport "M_AXI_GP" sptag "GP" memory ""}
            S_AXI_HP1 {memport "S_AXI_HP" sptag "HP1" memory "ps7 HP1_DDR_LOWOCM"}
            S_AXI_HP2 {memport "S_AXI_HP" sptag "HP2" memory "ps7 HP2_DDR_LOWOCM"} 
            S_AXI_HP3 {memport "S_AXI_HP" sptag "HP3" memory "ps7 HP3_DDR_LOWOCM"}
        } $zynq_ps
        set_property PFM.CLOCK { 
            FCLK_CLK0 {id "0" is_default "true" proc_sys_reset "/proc_sys_reset_0" status "fixed"}
        } $zynq_ps
    }
}
