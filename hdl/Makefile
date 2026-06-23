# Copyright (C) 2024, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0
#
# Modified by SpaceLab UFSC in 2026 for the FlatSat Platform 2 project.

RM = rm -rf
.DELETE_ON_ERROR:
ifdef XILINX_VIVADO
VIVADO ?= $(XILINX_VIVADO)/bin/vivado
SDTGEN ?= $(XILINX_VIVADO)/bin/sdtgen
else
VIVADO ?= vivado
SDTGEN ?= sdtgen
endif

JOBS ?= 8
PROJ_NAME ?= flatsat2
PLATFORM_NAME ?= floripasat-2
HW_BOARD_NAME ?= microzed

VIV_PRJ_DIR = hw_project
SDT_PRJ_DIR = hw_project_sdt
VIV_SCRIPTS_DIR ?= scripts
FSAT_SCRIPTS_DIR ?= $(abspath $(VIV_SCRIPTS_DIR))
IPS_DIR ?= ips
FSAT_IPS_DIR ?= $(abspath $(IPS_DIR))
export FSAT_SCRIPTS_DIR
export FSAT_IPS_DIR

VIV_XSA = $(VIV_PRJ_DIR)/*.xsa
VIV_SRC = $(FSAT_SCRIPTS_DIR)/main.tcl
SDTGEN_SRC = $(FSAT_SCRIPTS_DIR)/gen_sdt.tcl
IP_TCL = $(sort $(wildcard $(IPS_DIR)/*/*.tcl))
IP_DIRS = $(sort $(dir $(IP_TCL)))
IP_COMPONENTS = $(addsuffix component.xml,$(IP_DIRS))

.PHONY: help
help:
	@echo 'Usage:'
	@echo ''
	@echo '  make ips'
	@echo '    Package local Vivado IP cores from the ips directory.'
	@echo '  make xsa'
	@echo '    Package local IPs and generate flatsat2 base xsa.'
	@echo '  make sdt'
	@echo '    Generate the SDT files from XSA'
	@echo '  make all'
	@echo '    This will generate both XSA and SDT'
	@echo 'Note you can pass Args JOBS, PLATFORM_NAME and PROJ_NAME'
	@echo ''

.PHONY: all
all: xsa sdt

.PHONY: ips
ips: $(IP_COMPONENTS)
ifeq ($(strip $(IP_TCL)),)
	@echo 'No IP Tcl scripts found under $(IPS_DIR)'
endif

define IP_BUILD_RULE
$(1)component.xml: $(wildcard $(1)*.tcl) $(wildcard $(1)*.v) $(wildcard $(1)*.sv) $(wildcard $(1)*.vhd) $(FSAT_SCRIPTS_DIR)/ip.tcl
	cd $(1) && $(VIVADO) -mode batch -notrace -source $(notdir $(firstword $(wildcard $(1)*.tcl)))
endef

$(foreach ip_dir,$(IP_DIRS),$(eval $(call IP_BUILD_RULE,$(ip_dir))))

xsa: ips $(VIV_XSA)
$(VIV_XSA): $(VIV_SRC) $(IP_COMPONENTS)
	$(VIVADO) -mode batch -notrace -source $(VIV_SRC) -tclargs -jobs $(JOBS) -proj_name $(PROJ_NAME) -platform_name $(PLATFORM_NAME) -hw_board_name $(HW_BOARD_NAME)

sdt:
	$(SDTGEN) $(SDTGEN_SRC) -proj_dir $(VIV_PRJ_DIR) -xsa_name $(PROJ_NAME) -outdir $(SDT_PRJ_DIR)

.PHONY: clean-ips
clean-ips:
	$(RM) $(foreach ip_dir,$(IP_DIRS),$(ip_dir)component.xml $(ip_dir)xgui $(ip_dir)*.cache $(ip_dir)*.gen $(ip_dir)*.hw $(ip_dir)*.ip_user_files $(ip_dir)*.runs $(ip_dir)*.sim $(ip_dir)*.srcs $(ip_dir)*.xpr $(ip_dir)*.log $(ip_dir)*.jou)

.PHONY: clean
clean: clean-ips
	$(RM) $(VIV_PRJ_DIR)/../*.log $(VIV_PRJ_DIR)/../*.jou
	$(RM) $(VIV_PRJ_DIR) $(SDT_PRJ_DIR)
