export DESIGN_NAME     = service_ihp_chip
export PLATFORM        = ihp-sg13g2
export DESIGN_NICKNAME = SYNtzulA_DualCore
export FLOW_VARIANT    = 1

export DIE_AREA   =   0   0 2230 2285
export CORE_AREA  = 285 285 1945 2000


export VERILOG_FILES =    SUB/SYNtzulA/rtl/syntzulu_dual_core/* \
                          SUB/SYNtzulA/rtl/memorie_ihp/* \
                          SUB/SYNtzulA/rtl/serv/* \
                          SUB/SYNtzulA/rtl/servant/*                        
 			
export SDC_FILE      =   ./designs/$(PLATFORM)/SYNtzulA/dual_core/constraint_dual_core.sdc

export ADDITIONAL_GDS  = ./platforms/ihp-sg13g2/gds/RM_IHPSG13_1P_256x48_c2_bm_bist.gds \
                         ./platforms/ihp-sg13g2/gds/RM_IHPSG13_1P_256x64_c2_bm_bist.gds \
                         ./platforms/ihp-sg13g2/gds/RM_IHPSG13_1P_2048x64_c2_bm_bist.gds \
                         ./platforms/ihp-sg13g2/gds/RM_IHPSG13_1P_1024x64_c2_bm_bist.gds 
 
export ADDITIONAL_LEFS = ./platforms/ihp-sg13g2/lef/RM_IHPSG13_1P_256x48_c2_bm_bist.lef \
                         ./platforms/ihp-sg13g2/lef/RM_IHPSG13_1P_256x64_c2_bm_bist.lef \
                         ./platforms/ihp-sg13g2/lef/RM_IHPSG13_1P_2048x64_c2_bm_bist.lef \
                         ./platforms/ihp-sg13g2/lef/RM_IHPSG13_1P_1024x64_c2_bm_bist.lef 

export ADDITIONAL_LIBS = ./platforms/ihp-sg13g2/lib/RM_IHPSG13_1P_256x48_c2_bm_bist_typ_1p20V_25C.lib \
                         ./platforms/ihp-sg13g2/lib/RM_IHPSG13_1P_256x64_c2_bm_bist_typ_1p20V_25C.lib \
                         ./platforms/ihp-sg13g2/lib/RM_IHPSG13_1P_2048x64_c2_bm_bist_typ_1p20V_25C.lib \
                         ./platforms/ihp-sg13g2/lib/RM_IHPSG13_1P_1024x64_c2_bm_bist_typ_1p20V_25C.lib 
                                            
export MACRO_PLACEMENT = ./designs/$(PLATFORM)/SYNtzulA/dual_core/placement_dual_core.cfg

export FOOTPRINT_TCL = $(DESIGN_HOME)/$(PLATFORM)/SYNtzulA/dual_core/pad_dual_core.tcl
export PDN_TCL = $(DESIGN_HOME)/$(PLATFORM)/SYNtzulA/dual_core/pdn_dual_core.tcl


export PLACE_DENSITY = 0.75

export  HOLD_SLACK_MARGIN = 0.1 
export SETUP_SLACK_MARGIN = 2.5 

export CAP_MARGIN = 0.1


export GDS_ALLOW_EMPTY = RM_IHPSG13_1P_BITKIT_16x2_LE_con_edge_lr|RM_IHPSG13_1P_BITKIT_16x2_LE_con_tap_lr|RM_IHPSG13_1P_BITKIT_16x2_TAP_LR|RM_IHPSG13_1P_BITKIT_16x2_POWER_ramtap|RM_IHPSG13_1P_BITKIT_16x2_LE_con_corner|RM_IHPSG13_1P_BITKIT_16x2_CORNER|RM_IHPSG13_1P_BITKIT_16x2_TAP|RM_IHPSG13_1P_BITKIT_16x2_EDGE_TB

