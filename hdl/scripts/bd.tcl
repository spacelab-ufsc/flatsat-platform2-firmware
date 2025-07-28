# SPDX-License-Identifier: GPL-2.0-only

source $script_dir/zynq_ps.tcl

namespace eval ::fsat_bd {
    proc create_base_design {name version} {
        create_bd_design $name -mode batch
        current_bd_design $name

        set parentCell [get_bd_cells /]
        set parentObj [get_bd_cells $parentCell]
        current_bd_instance $parentObj

        set DDR [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR]
        set FIXED_IO [create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO]
        set IIC_0 [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_0]
        set IIC_1 [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_1]

        set zynq_ps [create_zynq_ps]

        set proc_sys_reset_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0]

        set xlconstant_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0]
        set_property CONFIG.CONST_VAL {0} $xlconstant_0

        connect_bd_intf_net -intf_net zynq_ps_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins zynq_ps/DDR]
        connect_bd_intf_net -intf_net zynq_ps_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins zynq_ps/FIXED_IO]
        connect_bd_intf_net -intf_net zynq_ps_IIC_0 [get_bd_intf_ports IIC_0] [get_bd_intf_pins zynq_ps/IIC_0]
        connect_bd_intf_net -intf_net zynq_ps_IIC_1 [get_bd_intf_ports IIC_1] [get_bd_intf_pins zynq_ps/IIC_1]

        connect_bd_net -net zynq_ps_FCLK_CLK0 [get_bd_pins zynq_ps/FCLK_CLK0] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
        connect_bd_net -net zynq_ps_FCLK_RESET0_N [get_bd_pins zynq_ps/FCLK_RESET0_N] [get_bd_pins proc_sys_reset_0/ext_reset_in]
        connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconstant_0/dout] [get_bd_pins zynq_ps/SDIO0_WP]

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
