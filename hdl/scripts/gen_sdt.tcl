# SPDX-License-Identifier: GPL-2.0-only

for { set i 0 } { $i < $argc } { incr i } {
  if { [lindex $argv $i] == "-xsa_name" } {
    incr i
    set xsa_name [lindex $argv $i]
  }
  if { [lindex $argv $i] == "-outdir" } {
    incr i
    set outdir [lindex $argv $i]
  }
  if { [lindex $argv $i] == "-proj_dir" } {
    incr i
    set proj_dir [lindex $argv $i]
  }
}

set xsa_path $proj_dir/$xsa_name/outputs/$xsa_name.xsa

sdtgen set_dt_param -xsa $xsa_path -dir $outdir
sdtgen generate_sdt
