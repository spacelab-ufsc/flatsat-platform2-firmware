# SPDX-License-Identifier: GPL-2.0-only

namespace eval ::fsat_bd {
    proc create_zynq_ps {} {
    # Zynq Processing System Instance for Block Design
        set zynq_ps [create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 zynq_ps]
        set_property -dict [list \
            CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
            CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
            CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
            CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
            CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
            CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {100.000000} \
            CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {10.000000} \
            CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
            CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
            CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
            CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
            CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {50.000000} \
            CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
            CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
            CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
            CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
            CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
            CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
            CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
            CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
            CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
            CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {50.000000} \
            CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {111.111115} \
            CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
            CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {667} \
            CONFIG.PCW_CLK0_FREQ {100000000} \
            CONFIG.PCW_CLK1_FREQ {10000000} \
            CONFIG.PCW_CLK2_FREQ {10000000} \
            CONFIG.PCW_CLK3_FREQ {10000000} \
            CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE {667} \
            CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
            CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} \
            CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
            CONFIG.PCW_DDR_RAM_HIGHADDR {0x3FFFFFFF} \
            CONFIG.PCW_DM_WIDTH {4} \
            CONFIG.PCW_DQS_WIDTH {4} \
            CONFIG.PCW_DQ_WIDTH {32} \
            CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
            CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
            CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
            CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
            CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
            CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
            CONFIG.PCW_ENET0_RESET_ENABLE {0} \
            CONFIG.PCW_ENET_RESET_ENABLE {1} \
            CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
            CONFIG.PCW_EN_CLK0_PORT {1} \
            CONFIG.PCW_EN_CLK1_PORT {0} \
            CONFIG.PCW_EN_CLK2_PORT {0} \
            CONFIG.PCW_EN_CLK3_PORT {0} \
            CONFIG.PCW_EN_DDR {1} \
            CONFIG.PCW_EN_EMIO_I2C0 {1} \
            CONFIG.PCW_EN_EMIO_I2C1 {1} \
            CONFIG.PCW_EN_EMIO_TTC0 {1} \
            CONFIG.PCW_EN_EMIO_WP_SDIO0 {1} \
            CONFIG.PCW_EN_ENET0 {1} \
            CONFIG.PCW_EN_GPIO {1} \
            CONFIG.PCW_EN_I2C0 {1} \
            CONFIG.PCW_EN_I2C1 {1} \
            CONFIG.PCW_EN_QSPI {1} \
            CONFIG.PCW_EN_RST0_PORT {1} \
            CONFIG.PCW_EN_RST1_PORT {0} \
            CONFIG.PCW_EN_RST2_PORT {0} \
            CONFIG.PCW_EN_RST3_PORT {0} \
            CONFIG.PCW_EN_SDIO0 {1} \
            CONFIG.PCW_EN_TTC0 {1} \
            CONFIG.PCW_EN_UART1 {1} \
            CONFIG.PCW_EN_USB0 {1} \
            CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
            CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
            CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} \
            CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
            CONFIG.PCW_FCLK_CLK0_BUF {TRUE} \
            CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
            CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {100} \
            CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {33.333333} \
            CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {50} \
            CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
            CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
            CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
            CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
            CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {1} \
            CONFIG.PCW_I2C0_I2C0_IO {EMIO} \
            CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} \
            CONFIG.PCW_I2C1_I2C1_IO {EMIO} \
            CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {1} \
            CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {111.111115} \
            CONFIG.PCW_I2C_RESET_ENABLE {0} \
            CONFIG.PCW_IRQ_F2P_INTR {1} \
            CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
            CONFIG.PCW_MIO_0_PULLUP {disabled} \
            CONFIG.PCW_MIO_0_SLEW {slow} \
            CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
            CONFIG.PCW_MIO_10_PULLUP {disabled} \
            CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
            CONFIG.PCW_MIO_11_PULLUP {disabled} \
            CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
            CONFIG.PCW_MIO_12_PULLUP {disabled} \
            CONFIG.PCW_MIO_12_SLEW {slow} \
            CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
            CONFIG.PCW_MIO_13_PULLUP {disabled} \
            CONFIG.PCW_MIO_13_SLEW {slow} \
            CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
            CONFIG.PCW_MIO_14_PULLUP {disabled} \
            CONFIG.PCW_MIO_14_SLEW {slow} \
            CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
            CONFIG.PCW_MIO_15_PULLUP {disabled} \
            CONFIG.PCW_MIO_15_SLEW {slow} \
            CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_16_PULLUP {disabled} \
            CONFIG.PCW_MIO_16_SLEW {slow} \
            CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_17_PULLUP {disabled} \
            CONFIG.PCW_MIO_17_SLEW {slow} \
            CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_18_PULLUP {disabled} \
            CONFIG.PCW_MIO_18_SLEW {slow} \
            CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_19_PULLUP {disabled} \
            CONFIG.PCW_MIO_19_SLEW {slow} \
            CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
            CONFIG.PCW_MIO_1_PULLUP {disabled} \
            CONFIG.PCW_MIO_1_SLEW {slow} \
            CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_20_PULLUP {disabled} \
            CONFIG.PCW_MIO_20_SLEW {slow} \
            CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_21_PULLUP {disabled} \
            CONFIG.PCW_MIO_21_SLEW {slow} \
            CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_22_PULLUP {disabled} \
            CONFIG.PCW_MIO_22_SLEW {slow} \
            CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_23_PULLUP {disabled} \
            CONFIG.PCW_MIO_23_SLEW {slow} \
            CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_24_PULLUP {disabled} \
            CONFIG.PCW_MIO_24_SLEW {slow} \
            CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_25_PULLUP {disabled} \
            CONFIG.PCW_MIO_25_SLEW {slow} \
            CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_26_PULLUP {disabled} \
            CONFIG.PCW_MIO_26_SLEW {slow} \
            CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_27_PULLUP {disabled} \
            CONFIG.PCW_MIO_27_SLEW {slow} \
            CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_28_PULLUP {disabled} \
            CONFIG.PCW_MIO_28_SLEW {slow} \
            CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_29_PULLUP {disabled} \
            CONFIG.PCW_MIO_29_SLEW {slow} \
            CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
            CONFIG.PCW_MIO_2_SLEW {slow} \
            CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_30_PULLUP {disabled} \
            CONFIG.PCW_MIO_30_SLEW {slow} \
            CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_31_PULLUP {disabled} \
            CONFIG.PCW_MIO_31_SLEW {slow} \
            CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_32_PULLUP {disabled} \
            CONFIG.PCW_MIO_32_SLEW {slow} \
            CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_33_PULLUP {disabled} \
            CONFIG.PCW_MIO_33_SLEW {slow} \
            CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_34_PULLUP {disabled} \
            CONFIG.PCW_MIO_34_SLEW {slow} \
            CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_35_PULLUP {disabled} \
            CONFIG.PCW_MIO_35_SLEW {slow} \
            CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_36_PULLUP {disabled} \
            CONFIG.PCW_MIO_36_SLEW {slow} \
            CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_37_PULLUP {disabled} \
            CONFIG.PCW_MIO_37_SLEW {slow} \
            CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_38_PULLUP {disabled} \
            CONFIG.PCW_MIO_38_SLEW {slow} \
            CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_39_PULLUP {disabled} \
            CONFIG.PCW_MIO_39_SLEW {slow} \
            CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
            CONFIG.PCW_MIO_3_SLEW {slow} \
            CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_40_PULLUP {disabled} \
            CONFIG.PCW_MIO_40_SLEW {slow} \
            CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_41_PULLUP {disabled} \
            CONFIG.PCW_MIO_41_SLEW {slow} \
            CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_42_PULLUP {disabled} \
            CONFIG.PCW_MIO_42_SLEW {slow} \
            CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_43_PULLUP {disabled} \
            CONFIG.PCW_MIO_43_SLEW {slow} \
            CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_44_PULLUP {disabled} \
            CONFIG.PCW_MIO_44_SLEW {slow} \
            CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_45_PULLUP {disabled} \
            CONFIG.PCW_MIO_45_SLEW {slow} \
            CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_46_PULLUP {disabled} \
            CONFIG.PCW_MIO_46_SLEW {slow} \
            CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_47_PULLUP {disabled} \
            CONFIG.PCW_MIO_47_SLEW {slow} \
            CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_48_PULLUP {disabled} \
            CONFIG.PCW_MIO_48_SLEW {slow} \
            CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_49_PULLUP {disabled} \
            CONFIG.PCW_MIO_49_SLEW {slow} \
            CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
            CONFIG.PCW_MIO_4_SLEW {slow} \
            CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_50_PULLUP {disabled} \
            CONFIG.PCW_MIO_50_SLEW {slow} \
            CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_51_PULLUP {disabled} \
            CONFIG.PCW_MIO_51_SLEW {slow} \
            CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_52_PULLUP {disabled} \
            CONFIG.PCW_MIO_52_SLEW {slow} \
            CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
            CONFIG.PCW_MIO_53_PULLUP {disabled} \
            CONFIG.PCW_MIO_53_SLEW {slow} \
            CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
            CONFIG.PCW_MIO_5_SLEW {slow} \
            CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
            CONFIG.PCW_MIO_6_SLEW {slow} \
            CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
            CONFIG.PCW_MIO_7_SLEW {slow} \
            CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
            CONFIG.PCW_MIO_8_SLEW {slow} \
            CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
            CONFIG.PCW_MIO_9_PULLUP {disabled} \
            CONFIG.PCW_MIO_9_SLEW {slow} \
            CONFIG.PCW_MIO_PRIMITIVE {54} \
            CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#USB Reset#Quad SPI Flash#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#Enet 0#Enet\
        0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#GPIO#UART 1#UART 1#GPIO#GPIO#Enet\
        0#Enet 0} \
            CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#reset#qspi_fbclk#gpio[9]#gpio[10]#gpio[11]#gpio[12]#gpio[13]#gpio[14]#gpio[15]#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#clk#cmd#data[0]#data[1]#data[2]#data[3]#cd#gpio[47]#tx#rx#gpio[50]#gpio[51]#mdc#mdio}\
        \
            CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.416} \
            CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.408} \
            CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.369} \
            CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.370} \
            CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {0.001} \
            CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {0.037} \
            CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {-0.074} \
            CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {-0.098} \
            CONFIG.PCW_PACKAGE_NAME {clg400} \
            CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
            CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
            CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
            CONFIG.PCW_QSPI_GRP_FBCLK_IO {MIO 8} \
            CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
            CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
            CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
            CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
            CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} \
            CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
            CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
            CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
            CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
            CONFIG.PCW_SD0_GRP_CD_IO {MIO 46} \
            CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
            CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
            CONFIG.PCW_SD0_GRP_WP_IO {EMIO} \
            CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
            CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
            CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} \
            CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} \
            CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
            CONFIG.PCW_SINGLE_QSPI_DATA_MODE {x4} \
            CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
            CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
            CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
            CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {1} \
            CONFIG.PCW_TTC0_TTC0_IO {EMIO} \
            CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ {50} \
            CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
            CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
            CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} \
            CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
            CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {50} \
            CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
            CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
            CONFIG.PCW_UIPARAM_DDR_BL {8} \
            CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.294} \
            CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.298} \
            CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.338} \
            CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.334} \
            CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {32 Bit} \
            CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {54.14} \
            CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {54.14} \
            CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {39.7} \
            CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {39.7} \
            CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {50.05} \
            CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {50.43} \
            CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {50.10} \
            CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {50.01} \
            CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {-0.073} \
            CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {-0.072} \
            CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.024} \
            CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.023} \
            CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {49.59} \
            CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {51.74} \
            CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {50.32} \
            CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {48.55} \
            CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3} \
            CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125} \
            CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
            CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
            CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
            CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {0} \
            CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
            CONFIG.PCW_USB0_RESET_ENABLE {1} \
            CONFIG.PCW_USB0_RESET_IO {MIO 7} \
            CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
            CONFIG.PCW_USB_RESET_ENABLE {1} \
            CONFIG.PCW_USB_RESET_SELECT {Share reset pin} \
            CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
            CONFIG.PCW_USE_M_AXI_GP0 {0} \
            CONFIG.PCW_USE_M_AXI_GP1 {0} \
            CONFIG.PCW_CAN0_CAN0_IO {MIO 10 .. 11} \
            CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {1} \
        ] $zynq_ps

        return $zynq_ps
    }
}
