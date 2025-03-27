export DESIGN_NAME     = service_ihp_chip
export PLATFORM        = ihp-sg13g2
export DESIGN_NICKNAME = SYNtzulA

export DIE_AREA   =   0   0 2290 2290
export CORE_AREA  = 215 215 2075 2075                          
 			
export SDC_FILE      =   ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export ADDITIONAL_GDS  = ./platforms/ihp-sg13g2/gds/RM_IHPSG13_1P_256x48_c2_bm_bist.gds \
                         ./platforms/ihp-sg13g2/gds/RM_IHPSG13_1P_2048x64_c2_bm_bist.gds \
                         ./platforms/ihp-sg13g2/gds/RM_IHPSG13_1P_1024x64_c2_bm_bist.gds \
                         ./platforms/ihp-sg13g2/gds/sg13g2_io.gds \
                         ./platforms/ihp-sg13g2/gds/bondpad_70x70.gds
 
export ADDITIONAL_LEFS = ./platforms/ihp-sg13g2/lef/RM_IHPSG13_1P_256x48_c2_bm_bist.lef \
                         ./platforms/ihp-sg13g2/lef/RM_IHPSG13_1P_2048x64_c2_bm_bist.lef \
                         ./platforms/ihp-sg13g2/lef/RM_IHPSG13_1P_1024x64_c2_bm_bist.lef \
                         ./platforms/ihp-sg13g2/lef/sg13g2_io.lef \
                         ./platforms/ihp-sg13g2/lef/bondpad_70x70.lef

export ADDITIONAL_LIBS = ./platforms/ihp-sg13g2/lib/RM_IHPSG13_1P_256x48_c2_bm_bist_typ_1p20V_25C.lib \
                         ./platforms/ihp-sg13g2/lib/RM_IHPSG13_1P_2048x64_c2_bm_bist_typ_1p20V_25C.lib \
                         ./platforms/ihp-sg13g2/lib/RM_IHPSG13_1P_1024x64_c2_bm_bist_typ_1p20V_25C.lib \
                         ./platforms/ihp-sg13g2/lib/sg13g2_io_typ_1p2V_3p3V_25C.lib
                         
export MACRO_PLACEMENT = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/service_placement.cfg

export PDN_TCL = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/pdn.tcl

export HOLD_SLACK_MARGIN = 0.2 

export GDS_ALLOW_EMPTY = RM_IHPSG13_1P_BITKIT_16x2_LE_con_edge_lr|RM_IHPSG13_1P_BITKIT_16x2_LE_con_tap_lr|RM_IHPSG13_1P_BITKIT_16x2_TAP_LR|RM_IHPSG13_1P_BITKIT_16x2_POWER_ramtap|RM_IHPSG13_1P_BITKIT_16x2_LE_con_corner|RM_IHPSG13_1P_BITKIT_16x2_CORNER|RM_IHPSG13_1P_BITKIT_16x2_TAP|RM_IHPSG13_1P_BITKIT_16x2_EDGE_TB
