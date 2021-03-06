# ####################################################################################################################
# #################################################################################################################### 
# Create vivado project
# Open vivado
# In the TCL console:
#	cd to current directory 
#		e.g.
#		cd ~/repo/bdSound_Bolide/TableHub/Zynq/ZynqPL
#
# 	vivado -mode batch -source ./00_create_table_hub.tcl 
# #################################################################################################################### 
# #################################################################################################################### 

# ################################################
# OPTIONS
# ################################################

source ./version.tcl

set bus_ch_num	15
set beginTime [clock seconds]


file delete -force ../Build/table_hub

create_project table_hub ../Build/table_hub -part xc7z010clg400-1
set_property board_part em.avnet.com:microzed_7010:part0:1.1 [current_project]
set_property target_language VHDL [current_project]

set_property  ip_repo_paths  ./ips [current_project]
update_ip_catalog


source ./01_top.tcl

assign_bd_address
set_property range 64K [get_bd_addr_segs {processing_system7_0/Data/SEG_bram_ctrl_from_ps_Mem0}]
set_property range 64K [get_bd_addr_segs {processing_system7_0/Data/SEG_bram_ctrl_to_ps_Mem0}]

add_files -norecurse ./table_hub.vhd
add_files -fileset constrs_1 -norecurse ./table_hub.xdc
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

validate_bd_design
regenerate_bd_layout
save_bd_design


set endTime [clock seconds]
set elapsed [expr {$endTime - $beginTime}]
puts "Time to elaborate: [clock format $elapsed -gmt true -format %H:%M:%S]"
























