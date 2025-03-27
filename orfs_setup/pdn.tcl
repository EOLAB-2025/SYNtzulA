###################
###################
###################
################################################################## PIN PLACEMENT FOR SERVICE CHIP ##############################################################################

make_io_sites -horizontal_site sg13g2_ioSite \
    -vertical_site sg13g2_ioSite \
    -corner_site sg13g2_ioSite \
    -offset 0 \
    -rotation_horizontal R0 \
    -rotation_vertical R0 \
    -rotation_corner R0

set padD    180; # pad depth (edge to core)
set padW     80; # pad width (beachfront)

set chipH  2290; # left/right (height)
set chipW  2290; # top/bottom (width)

#Edge: LEFT (top to bottom)
set numPads 15
set offset 20
set pitch [expr {floor( ($chipH - 2*$padD -2*$offset - $padW)/($numPads-1) )}]

puts "IO_WEST_pitch: $pitch "
set start [expr $chipH - $padD - $offset - $padW]
place_pad -row IO_NORTH  -location [expr $start -  0*$pitch] "pad_wb_clk" ; 
place_pad -row IO_NORTH  -location [expr $start -  1*$pitch] "pad_wb_rst" ; 
place_pad -row IO_NORTH  -location [expr $start -  2*$pitch] "pad_enb_debug" ; 
place_pad -row IO_NORTH  -location [expr $start -  3*$pitch] "pad_timer_clk" ; 
place_pad -row IO_NORTH  -location [expr $start -  4*$pitch] "pad_i_flash_miso" ; 
place_pad -row IO_NORTH  -location [expr $start -  5*$pitch] "pad_buttons_0" ; 
place_pad -row IO_NORTH  -location [expr $start -  6*$pitch] "pad_buttons_1" ; 
place_pad -row IO_NORTH  -location [expr $start -  7*$pitch] "pad_buttons_2" ; 

place_pad -row IO_NORTH  -location [expr $start - 12*$pitch] "pad_o_flash_ss" ; 
place_pad -row IO_NORTH  -location [expr $start - 13*$pitch] "pad_o_flash_sck" ; 
place_pad -row IO_NORTH  -location [expr $start - 14*$pitch] "pad_o_flash_mosi" ;



set iocorner sg13g2_Corner
set iofill [ list sg13g2_Filler10000 sg13g2_Filler4000 sg13g2_Filler2000 sg13g2_Filler1000 sg13g2_Filler400 sg13g2_Filler200 ]

place_corners $iocorner

place_io_fill -row IO_NORTH {*}$iofill
place_io_fill -row IO_SOUTH {*}$iofill
place_io_fill -row IO_WEST  {*}$iofill
place_io_fill -row IO_EAST  {*}$iofill

connect_by_abutment
#place_bondpad -bond bondpad_70x70 -offset {5.0 -70.0} pad_*
place_io_terminals pad_*/pad
remove_io_rows




################################################################      POWER DISTRIBUTION NETWORK                           #####################################################
####################################
# global connections
####################################
# standard cells
add_global_connection -net {VDD} -pin_pattern {^VDD$} -power
add_global_connection -net {VDD} -pin_pattern {^VDDPE$}
add_global_connection -net {VDD} -pin_pattern {^VDDCE$}
add_global_connection -net {VSS} -pin_pattern {^VSS$} -ground
add_global_connection -net {VSS} -pin_pattern {^VSSE$}
# I/O pads
add_global_connection -net {VDD} -pin_pattern {^vdd$} -power
add_global_connection -net {VSS} -pin_pattern {^vss$} -ground
global_connect
# rams
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {VDDARRAY} -power
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {VDDARRAY!} -power
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {VDD!} -power
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {VSS!} -ground

####################################
# voltage domains
####################################
set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}

##########################################################################
##  Power settings
##########################################################################
# Core Power Ring
## Space between pads and core -> used for power ring
set PowRingSpace  35
## Spacing must meet TM2 rules
set pgcrSpacing 6
## Width must meet TM2 rules
set pgcrWidth 10
## Offset from core to power ring
set pgcrOffset [expr ($PowRingSpace - $pgcrSpacing - 2 * $pgcrWidth) / 2]

# TopMetal2 Core Power Grid
set tpg2Width     6; # arbitrary number
set tpg2Pitch   204; # multiple of pad-pitch
set tpg2Spacing  60; # big enough to skip over a pad
set tpg2Offset   97; # offset from leftX of core

# Macro Power Rings -> M3 and M2
## Spacing must be larger than pitch of M2/M3
set mprSpacing 0.6
## Width
set mprWidth 2
## Offset from Macro to power ring
set mprOffsetX 2.4
set mprOffsetY 0.6

# macro power grid (stripes on TopMetal1/TopMetal2 depending on orientation)
set mpgWidth 6
set mpgSpacing 4
set mpgOffset 20; # arbitrary 

##########################################################################
##  SRAM power rings
##########################################################################
proc sram_power { name macro } {
    global mprWidth mprSpacing mprOffsetX mprOffsetY mpgWidth mpgSpacing mpgOffset
    # Macro Grid and Rings
    define_pdn_grid -macro -cells $macro -name ${name}_grid -orient "R0 R180 MY MX" \
        -grid_over_boundary -voltage_domains {CORE} \
        -halo {1 1}

    add_pdn_ring -grid ${name}_grid \
        -layer        {Metal3 Metal4} \
        -widths       "$mprWidth $mprWidth" \
        -spacings     "$mprSpacing $mprSpacing" \
        -core_offsets "$mprOffsetX $mprOffsetY" \
        -add_connect

    set sram  [[ord::get_db] findMaster $macro]
    set sramHeight  [ord::dbu_to_microns [$sram getHeight]]
    set stripe_dist [expr $sramHeight - 2*$mpgOffset - $mpgWidth - $mpgSpacing]
    utl::report "stripe_dist of $macro: $stripe_dist"

    # for the large macros there is enough space for an additional stripe
    if {$stripe_dist > 100} {
        set stripe_dist [expr $stripe_dist/2]
    }

    add_pdn_stripe -grid ${name}_grid -layer {TopMetal1} -width $mpgWidth -spacing $mpgSpacing \
                   -pitch $stripe_dist -offset $mpgOffset -extend_to_core_ring -starts_with POWER -snap_to_grid

    # Connection of Macro Power Ring to standard-cell rails
    add_pdn_connect -grid ${name}_grid -layers {Metal3 Metal1}
    # Connection of Stripes on Macro to Macro Power Ring
    add_pdn_connect -grid ${name}_grid -layers {TopMetal1 Metal3}
    add_pdn_connect -grid ${name}_grid -layers {TopMetal1 Metal4}
    # Connection of Stripes on Macro to Macro Power Pins
    # add_pdn_connect -grid ${name}_grid -layers {TopMetal1 Metal4}
    # Connection of Stripes on Macro to Core Power Stripes
    add_pdn_connect -grid ${name}_grid -layers {TopMetal2 TopMetal1}
}


##########################################################################
##  Core Power
##########################################################################
# Top 1 - Top 2
define_pdn_grid -name {core_grid} -voltage_domains {CORE}

add_pdn_ring -grid {core_grid} \
   -layer        {TopMetal1 TopMetal2} \
   -widths       "$pgcrWidth $pgcrWidth" \
   -spacings     "$pgcrSpacing $pgcrSpacing" \
   -pad_offsets  "6 6" \
   -add_connect                        \
   -connect_to_pads                    \
   -connect_to_pad_layers TopMetal2

# M1 Standardcell Rows (tracks)
add_pdn_stripe -grid {core_grid} -layer {Metal1} -width {0.44} -offset {0} \
               -followpins -extend_to_core_ring


# SRAMS
# sram_power "grid_256x64" "RM_IHPSG13_1P_256x64_c2_bm_bist"          
sram_power "grid_256x48" "RM_IHPSG13_1P_256x48_c2_bm_bist"              
sram_power "grid_wmem"   "RM_IHPSG13_1P_2048x64_c2_bm_bist"
sram_power "grid_ram"    "RM_IHPSG13_1P_1024x64_c2_bm_bist"  

# Top power grid
# Top 2 Stripe
add_pdn_stripe -grid {core_grid} -layer {TopMetal2} -width $tpg2Width \
               -pitch $tpg2Pitch -spacing $tpg2Spacing -offset $tpg2Offset \
               -extend_to_core_ring -snap_to_grid 

# "The add_pdn_connect command is used to define which layers in the power grid are to be connected together. 
#  During power grid generation, vias will be added for overlapping power nets and overlapping ground nets."
# M1 is declared vertical but tracks still horizontal
# vertical TopMetal2 to below horizonals (M1 has horizontal power tracks)
add_pdn_connect -grid {core_grid} -layers {TopMetal2 Metal1}
add_pdn_connect -grid {core_grid} -layers {TopMetal2 Metal2}
add_pdn_connect -grid {core_grid} -layers {TopMetal2 Metal4}
# add_pdn_connect -grid {core_grid} -layers {TopMetal2 TopMetal1}
# power ring to standard cell rails
add_pdn_connect -grid {core_grid} -layers {Metal3 Metal1}
add_pdn_connect -grid {core_grid} -layers {Metal3 Metal2}
