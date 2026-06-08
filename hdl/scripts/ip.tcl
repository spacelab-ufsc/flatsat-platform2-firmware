# SPDX-FileCopyrightText: 2026 SpaceLab UFSC
# SPDX-License-Identifier: GPL-2.0-only

# Vivado IP packaging helpers.
#
# Typical usage from an IP-local Tcl script:
#
#   source ../../scripts/ip.tcl
#   fsat_ip::create my_ip
#   fsat_ip::files my_ip [list \
#       my_ip.v \
#       my_ip.xdc] -top my_ip
#   fsat_ip::package_lite my_ip

namespace eval fsat_ip {
    if {[info exists ::env(FSAT_SCRIPTS_DIR)] && $::env(FSAT_SCRIPTS_DIR) ne ""} {
        variable script_dir [file normalize $::env(FSAT_SCRIPTS_DIR)]
    } else {
        variable script_dir [file dirname [file normalize [info script]]]
    }
    variable repo_root [file normalize [file join $script_dir ..]]
    if {[info exists ::env(FSAT_IPS_DIR)] && $::env(FSAT_IPS_DIR) ne ""} {
        variable ips_dir [file normalize $::env(FSAT_IPS_DIR)]
    } else {
        variable ips_dir [file join $repo_root ips]
    }
    variable defaults [dict create \
        -vendor {spacelab.ufsc.br} \
        -library {ip} \
        -taxonomy {/SpaceLab} \
        -vendor_display_name {SpaceLab UFSC} \
        -company_url {https://spacelab.ufsc.br} \
        -root_dir {.} \
        -ip_repo_paths [list $ips_dir] \
        -part {}]
}

proc fsat_ip::_defaults {} {
    variable defaults
    return $defaults
}

proc fsat_ip::_file_defaults {ip_name} {
    return [dict create -top $ip_name]
}

proc fsat_ip::_parse_options {defaults args} {
    if {[expr {[llength $args] % 2}] != 0} {
        error "options must be provided as '-name value' pairs"
    }

    set options $defaults
    foreach {key value} $args {
        if {![string match -* $key]} {
            error "invalid option '$key'; options must start with '-'"
        }
        if {![dict exists $options $key]} {
            set valid_options [join [lsort [dict keys $options]] {, }]
            error "unknown option '$key'; valid options are: $valid_options"
        }
        dict set options $key $value
    }

    return $options
}

proc fsat_ip::_require_vivado_command {command caller} {
    if {[llength [info commands $command]] == 0} {
        error "$caller requires Vivado; missing Tcl command '$command'"
    }
}

proc fsat_ip::_require_ipx {caller} {
    if {[llength [info commands ipx::package_project]] == 0} {
        set load_errors [list]

        if {[llength [info commands load_features]] > 0} {
            foreach feature {ipx ip_packager ip_catalog ip} {
                if {[catch {load_features -quiet $feature} result]} {
                    lappend load_errors "$feature: $result"
                }

                if {[llength [info commands ipx::package_project]] > 0} {
                    break
                }
            }

            if {[llength [info commands ipx::package_project]] == 0 &&
                [llength [info commands list_features]] > 0} {
                if {[catch {load_features -quiet [list_features]} result]} {
                    lappend load_errors "all features: $result"
                }
            }
        }
    }

    if {[llength [info commands ipx::package_project]] == 0} {
        if {[info exists load_errors] && [llength $load_errors] > 0} {
            error "$caller requires Vivado IP packager support; missing Tcl command 'ipx::package_project' after load_features attempts: [join $load_errors {; }]"
        } else {
            error "$caller requires Vivado IP packager support; missing Tcl command 'ipx::package_project'"
        }
    }
}

proc fsat_ip::_current_core {} {
    fsat_ip::_require_ipx fsat_ip
    set core [ipx::current_core]
    if {$core eq {}} {
        error "no current IP core is selected"
    }
    return $core
}

proc fsat_ip::_apply_core_metadata {ip_name options} {
    set core [fsat_ip::_current_core]

    set_property name $ip_name $core
    set_property vendor_display_name [dict get $options -vendor_display_name] $core

    set company_url [dict get $options -company_url]
    if {$company_url ne {}} {
        set_property company_url $company_url $core
    }

    set_property AUTO_FAMILY_SUPPORT_LEVEL level_2 $core

    return $core
}

proc fsat_ip::_remove_memory_maps {core} {
    foreach memory_map [ipx::get_memory_maps * -of_objects $core] {
        set map_name [get_property NAME $memory_map]
        if {$map_name eq {}} {
            set map_name [lindex $memory_map end]
        }
        ipx::remove_memory_map $map_name $core
    }
}

proc fsat_ip::_port_width {core port_name} {
    set port [ipx::get_ports -nocase true $port_name -of_objects $core]
    if {$port eq {}} {
        error "required IP port '$port_name' was not found"
    }

    set left [get_property SIZE_LEFT $port]
    set right [get_property SIZE_RIGHT $port]

    if {$left eq {} || $right eq {}} {
        return 1
    }

    return [expr {abs($left - $right) + 1}]
}

proc fsat_ip::create {ip_name args} {
    fsat_ip::_require_vivado_command create_project fsat_ip::create

    set options [fsat_ip::_parse_options [fsat_ip::_defaults] {*}$args]
    set project_args [list $ip_name [dict get $options -root_dir] -force]

    set part [dict get $options -part]
    if {$part ne {}} {
        lappend project_args -part $part
    }

    create_project {*}$project_args

    set ip_repo_paths [dict get $options -ip_repo_paths]
    if {$ip_repo_paths ne {}} {
        set_property ip_repo_paths $ip_repo_paths [current_fileset]
        update_ip_catalog
    }

    return [current_project]
}

proc fsat_ip::files {ip_name ip_files args} {
    fsat_ip::_require_vivado_command get_filesets fsat_ip::files
    fsat_ip::_require_vivado_command add_files fsat_ip::files
    set options [fsat_ip::_parse_options [fsat_ip::_file_defaults $ip_name] {*}$args]

    set source_files [list]
    set constraint_files [list]

    foreach ip_file $ip_files {
        switch -- [string tolower [file extension $ip_file]] {
            {.xdc} {
                lappend constraint_files $ip_file
            }
            default {
                lappend source_files $ip_file
            }
        }
    }

    set source_fileset [get_filesets sources_1]

    if {[llength $source_files] > 0} {
        add_files -norecurse -scan_for_includes -fileset $source_fileset $source_files
    }

    if {[llength $constraint_files] > 0} {
        add_files -norecurse -fileset [get_filesets constrs_1] $constraint_files
    }

    set_property top [dict get $options -top] $source_fileset

    return $source_fileset
}

proc fsat_ip::package_lite {ip_name args} {
    fsat_ip::_require_ipx fsat_ip::package_lite

    set options [fsat_ip::_parse_options [fsat_ip::_defaults] {*}$args]

    ipx::package_project \
        -root_dir [dict get $options -root_dir] \
        -vendor [dict get $options -vendor] \
        -library [dict get $options -library] \
        -taxonomy [dict get $options -taxonomy]

    set core [fsat_ip::_apply_core_metadata $ip_name $options]

    ipx::save_core $core
    ipx::remove_all_bus_interface $core
    fsat_ip::_remove_memory_maps $core
    ipx::update_checksums $core
    ipx::save_core $core

    return $core
}

proc fsat_ip::package_axi_lite {ip_name args} {
    fsat_ip::_require_ipx fsat_ip::package_axi_lite
    fsat_ip::_require_vivado_command ipx::infer_bus_interface fsat_ip::package_axi_lite

    set core [fsat_ip::package_lite $ip_name {*}$args]

    ipx::infer_bus_interface [list \
        s_axi_awvalid \
        s_axi_awaddr \
        s_axi_awprot \
        s_axi_awready \
        s_axi_wvalid \
        s_axi_wdata \
        s_axi_wstrb \
        s_axi_wready \
        s_axi_bvalid \
        s_axi_bresp \
        s_axi_bready \
        s_axi_arvalid \
        s_axi_araddr \
        s_axi_arprot \
        s_axi_arready \
        s_axi_rvalid \
        s_axi_rdata \
        s_axi_rresp \
        s_axi_rready] \
        xilinx.com:interface:aximm_rtl:1.0 \
        $core

    ipx::infer_bus_interface s_axi_aclk xilinx.com:signal:clock_rtl:1.0 $core
    ipx::infer_bus_interface s_axi_aresetn xilinx.com:signal:reset_rtl:1.0 $core

    set read_addr_width [fsat_ip::_port_width $core s_axi_araddr]
    set write_addr_width [fsat_ip::_port_width $core s_axi_awaddr]

    if {$read_addr_width != $write_addr_width} {
        puts [format \
            "WARNING: AXI address width mismatch for %s (read=%d, write=%d); using 64 KiB range" \
            $ip_name \
            $read_addr_width \
            $write_addr_width]
        set range 65536
    } elseif {$read_addr_width >= 16} {
        set range 65536
    } else {
        set range [expr {1 << $read_addr_width}]
    }

    ipx::add_memory_map s_axi $core
    set s_axi_bus [ipx::get_bus_interfaces s_axi -of_objects $core]
    set_property slave_memory_map_ref s_axi $s_axi_bus

    set memory_map [ipx::get_memory_maps s_axi -of_objects $core]
    ipx::add_address_block axi_lite $memory_map
    set address_block [ipx::get_address_blocks axi_lite -of_objects $memory_map]
    set_property range $range $address_block

    ipx::associate_bus_interfaces -clock s_axi_aclk -reset s_axi_aresetn $core
    ipx::update_checksums $core
    ipx::save_core $core

    return $core
}

proc fsat_ip::add_port_map {bus physical_name logical_name} {
    fsat_ip::_require_ipx fsat_ip::add_port_map
    fsat_ip::_require_vivado_command ipx::add_port_map fsat_ip::add_port_map

    set port_map [ipx::add_port_map $physical_name $bus]
    set_property PHYSICAL_NAME $physical_name $port_map
    set_property LOGICAL_NAME $logical_name $port_map

    return $port_map
}

proc fsat_ip::add_bus {bus_name mode abstraction_type bus_type port_maps} {
    fsat_ip::_require_ipx fsat_ip::add_bus
    fsat_ip::_require_vivado_command ipx::add_bus_interface fsat_ip::add_bus

    set core [fsat_ip::_current_core]
    set bus [ipx::add_bus_interface $bus_name $core]

    set_property ABSTRACTION_TYPE_VLNV $abstraction_type $bus
    set_property BUS_TYPE_VLNV $bus_type $bus
    set_property INTERFACE_MODE $mode $bus

    foreach port_map $port_maps {
        if {[llength $port_map] != 2} {
            error "port map entries must be two-element lists: {physical_name logical_name}"
        }
        fsat_ip::add_port_map $bus {*}$port_map
    }

    return $bus
}

proc fsat_ip::add_bus_clock {clock_signal_name bus_interface_name {reset_signal_name {}} {reset_signal_mode slave} {clock_signal_mode slave}} {
    fsat_ip::_require_ipx fsat_ip::add_bus_clock
    fsat_ip::_require_vivado_command ipx::add_bus_interface fsat_ip::add_bus_clock

    set core [fsat_ip::_current_core]
    set clean_bus_name [string map {: _} $bus_interface_name]
    set clock_interface_name "${clean_bus_name}_signal_clock"

    set clock_interface [ipx::add_bus_interface $clock_interface_name $core]
    set_property abstraction_type_vlnv xilinx.com:signal:clock_rtl:1.0 $clock_interface
    set_property bus_type_vlnv xilinx.com:signal:clock:1.0 $clock_interface
    set_property display_name $clock_interface_name $clock_interface
    set_property interface_mode $clock_signal_mode $clock_interface

    set clock_map [ipx::add_port_map CLK $clock_interface]
    set_property physical_name $clock_signal_name $clock_map

    set associated_bus [ipx::add_bus_parameter ASSOCIATED_BUSIF $clock_interface]
    set_property value $bus_interface_name $associated_bus

    if {$reset_signal_name ne {}} {
        set reset_interface_name "${clean_bus_name}_signal_reset"
        set reset_interface [ipx::add_bus_interface $reset_interface_name $core]
        set_property abstraction_type_vlnv xilinx.com:signal:reset_rtl:1.0 $reset_interface
        set_property bus_type_vlnv xilinx.com:signal:reset:1.0 $reset_interface
        set_property display_name $reset_interface_name $reset_interface
        set_property interface_mode $reset_signal_mode $reset_interface

        set reset_map [ipx::add_port_map RST $reset_interface]
        set_property physical_name $reset_signal_name $reset_map

        set associated_reset [ipx::add_bus_parameter ASSOCIATED_RESET $clock_interface]
        set_property value $reset_signal_name $associated_reset

        set reset_polarity [ipx::add_bus_parameter POLARITY $reset_interface]
        if {[string match -nocase *n $reset_signal_name]} {
            set_property value ACTIVE_LOW $reset_polarity
        } else {
            set_property value ACTIVE_HIGH $reset_polarity
        }
    }

    return $clock_interface
}

proc fsat_ip_create {ip_name args} {
    return [fsat_ip::create $ip_name {*}$args]
}

proc fsat_ip_files {ip_name ip_files args} {
    return [fsat_ip::files $ip_name $ip_files {*}$args]
}

proc fsat_ip_properties_lite {ip_name args} {
    return [fsat_ip::package_lite $ip_name {*}$args]
}

proc fsat_ip_properties {ip_name args} {
    return [fsat_ip::package_axi_lite $ip_name {*}$args]
}
