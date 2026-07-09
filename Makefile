# ============================================================
#  Paths / configuration
# ============================================================
OPENROAD_PATH  ?= /home/luca/OpenROAD-flow-scripts_new
PLATFORM       := ihp-sg13g2
DESIGN         := SYNtzulA
RTL_ROOT       := $(PWD)/rtl

# Design directory inside OpenROAD (the config-internal paths are relative to this name)
ORFS_DESIGN_DIR := $(OPENROAD_PATH)/flow/designs/$(PLATFORM)/$(DESIGN)

# ============================================================
#  OpenROAD setup
#  Copy the configs into the ORFS design, replacing the SUB
#  placeholder with the real path of the repo's rtl directory.
# ============================================================
.PHONY: setup_orfs
setup_orfs:
	mkdir -p $(ORFS_DESIGN_DIR)
	sed 's|SUB|$(RTL_ROOT)|g' orfs_setup/config_dual_core.mk > $(ORFS_DESIGN_DIR)/config_dual_core.mk
	sed 's|SUB|$(RTL_ROOT)|g' orfs_setup/config_quad_core.mk > $(ORFS_DESIGN_DIR)/config_quad_core.mk
	cp -r orfs_setup/dual_core $(ORFS_DESIGN_DIR)/
	cp -r orfs_setup/quad_core $(ORFS_DESIGN_DIR)/

# ============================================================
#  Simulation
#  Shared source lists (written only once)
# ============================================================
SIM_TB  := sim/tb/Ihp_chip_tb.v sim/tb/servant_sim.v sim/tb/uart_decoder.v \
           sim/tb/vlog_tb_utils.v sim/tb/flash_spi_sim.sv

# RTL sources shared by the RTL simulation
SIM_RTL := rtl/servant/* rtl/serv/* rtl/memorie_ihp/* rtl/behavioural_ihp/* std_cells/*

# Sources for the post-synthesis simulation (netlist + behavioural models)
PS_RTL  := rtl/behavioural_ihp/* rtl/servant/service_ihp_top.v \
           rtl/servant/servant_clock_gen.v std_cells/*

# OpenROAD synthesis results and local netlist directory
ORFS_RESULTS   := $(OPENROAD_PATH)/flow/results/$(PLATFORM)
PS_NETLIST_DIR := ORFS_netlist/post_synthesis

# INIT_FILE injection: the synthesized netlist instantiates the delta-modulator
# memory without a preload file; simulation needs it initialized from delta.txt.
# Match only the delta_mem instance (dotted path) so the other two 256x48
# memories are left untouched.
INIT_INJECT = sed -i '/delta_modulator_1\.delta_mem\.single_port/ s|RM_IHPSG13_1P_256x48_c2_bm_bist |RM_IHPSG13_1P_256x48_c2_bm_bist \#(.INIT_FILE("sim/mem/emg/delta.txt")) |'

.PHONY: simulate_dual_core simulate_quad_core \
        simulate_service_ihp_dual_core_PostSintesi \
        simulate_service_ihp_quad_core_PostSintesi \
        netlist_dual_core netlist_quad_core

# ---- RTL ----
simulate_dual_core:
	cp ./sim/mem/emg/flash_dual_core.txt ./sim/mem/emg/flash.txt
	iverilog -D SIM -D DUAL_CORE -o rtl_sim \
	    rtl/define.v $(SIM_TB) rtl/syntzulu_dual_core/* $(SIM_RTL)
	vvp rtl_sim

simulate_quad_core:
	cp ./sim/mem/emg/flash_quad_core.txt ./sim/mem/emg/flash.txt
	iverilog -D SIM -D QUAD_CORE -o rtl_sim \
	    rtl/define.v $(SIM_TB) rtl/syntzulu_quad_core/* $(SIM_RTL)
	vvp rtl_sim

# ---- Import synthesized netlist from OpenROAD and inject the INIT_FILE ----
netlist_dual_core:
	cp $(ORFS_RESULTS)/SYNtzulA_DualCore/1/1_synth.v $(PS_NETLIST_DIR)/DualCore.v
	$(INIT_INJECT) $(PS_NETLIST_DIR)/DualCore.v

netlist_quad_core:
	cp $(ORFS_RESULTS)/SYNtzulA_QuadCore/1/1_synth.v $(PS_NETLIST_DIR)/QuadCore.v
	$(INIT_INJECT) $(PS_NETLIST_DIR)/QuadCore.v

# ---- Post-synthesis (imports the netlist first) ----
simulate_service_ihp_dual_core_PostSintesi: netlist_dual_core
	cp ./sim/mem/emg/flash_dual_core.txt ./sim/mem/emg/flash.txt
	iverilog -D PS -D SIM -D DUAL_CORE -o rtl_sim \
	    rtl/define.v $(SIM_TB) $(PS_RTL) $(PS_NETLIST_DIR)/DualCore.v
	vvp rtl_sim

simulate_service_ihp_quad_core_PostSintesi: netlist_quad_core
	cp ./sim/mem/emg/flash_quad_core.txt ./sim/mem/emg/flash.txt
	iverilog -D PS -D SIM -D QUAD_CORE -o rtl_sim \
	    rtl/define.v $(SIM_TB) $(PS_RTL) $(PS_NETLIST_DIR)/QuadCore.v
	vvp rtl_sim
