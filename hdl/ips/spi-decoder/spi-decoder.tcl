# SPDX-FileCopyrightText: 2026 SpaceLab UFSC
# SPDX-License-Identifier: GPL-2.0-only

set ip_name spi_cs_decoder
set ip_dir [file dirname [file normalize [info script]]]

if {[info exists ::env(FSAT_SCRIPTS_DIR)] && $::env(FSAT_SCRIPTS_DIR) ne ""} {
    set script_dir [file normalize $::env(FSAT_SCRIPTS_DIR)]
} else {
    set script_dir [file normalize [file join $ip_dir .. .. scripts]]
}

source $script_dir/ip.tcl
cd $ip_dir
fsat_ip::create $ip_name
fsat_ip::files $ip_name [list \
    [file join $ip_dir spi-decoder.v] \
] -top $ip_name
fsat_ip::package_lite $ip_name
