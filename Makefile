OPENROAD_PATH ?= /home/luca/OpenROAD-flow-scripts_new

setup_orfs:
	mkdir -p $(OPENROAD_PATH)/flow/designs/ihp-sg13g2/SYNtzulA_prova_repo
	sed 's|SUB|$(PWD)/rtl|g' orfs_setup/config_dual_core.mk > $(OPENROAD_PATH)/flow/designs/ihp-sg13g2/SYNtzulA_prova_repo/config_dual_core.mk
	sed 's|SUB|$(PWD)/rtl|g' orfs_setup/config_quad_core.mk > $(OPENROAD_PATH)/flow/designs/ihp-sg13g2/SYNtzulA_prova_repo/config_quad_core.mk
	cp -r orfs_setup/dual_core $(OPENROAD_PATH)/flow/designs/ihp-sg13g2/SYNtzulA_prova_repo/
	cp -r orfs_setup/quad_core $(OPENROAD_PATH)/flow/designs/ihp-sg13g2/SYNtzulA_prova_repo/


simulate_dual_core:
	cp ./sim/mem/emg/flash_dual_core.txt ./sim/mem/emg/flash.txt 
	iverilog -D SIM -o rtl_sim -D DUAL_CORE rtl/define.v sim/tb/Ihp_chip_tb.v sim/tb/servant_sim.v sim/tb/uart_decoder.v sim/tb/vlog_tb_utils.v sim/tb/flash_spi_sim.sv rtl/servant/* rtl/serv/* rtl/syntzulu_dual_core/* rtl/memorie_ihp/* rtl/behavioural_ihp/* std_cells/*
	vvp rtl_sim

simulate_service_ihp_dual_core_PostSintesi:
	cp ./sim/mem/emg/flash_dual_core.txt ./sim/mem/emg/flash.txt 
	iverilog -D PS -D SIM -D DUAL_CORE -o rtl_sim  rtl/define.v sim/tb/Ihp_chip_tb.v sim/tb/servant_sim.v sim/tb/uart_decoder.v sim/tb/vlog_tb_utils.v sim/tb/flash_spi_sim.sv rtl/behavioural_ihp/* rtl/servant/service_ihp_top.v rtl/servant/servant_clock_gen.v std_cells/* ORFS_netlist/post_synthesis/DualCore.v
	vvp rtl_sim
	
simulate_quad_core:
	cp ./sim/mem/emg/flash_quad_core.txt ./sim/mem/emg/flash.txt 
	iverilog -D QUAD_CORE -D SIM -o rtl_sim  rtl/define.v sim/tb/Ihp_chip_tb.v sim/tb/servant_sim.v sim/tb/uart_decoder.v sim/tb/vlog_tb_utils.v sim/tb/flash_spi_sim.sv rtl/servant/* rtl/serv/* rtl/syntzulu_quad_core/* rtl/memorie_ihp/* rtl/behavioural_ihp/* std_cells/*
	vvp rtl_sim

simulate_service_ihp_quad_core_PostSintesi:
	cp ./sim/mem/emg/flash_quad_core.txt ./sim/mem/emg/flash.txt 
	iverilog -D QUAD_CORE -D SIM -D PS -o rtl_sim  rtl/define.v sim/tb/Ihp_chip_tb.v sim/tb/servant_sim.v sim/tb/uart_decoder.v sim/tb/vlog_tb_utils.v sim/tb/flash_spi_sim.sv rtl/behavioural_ihp/* rtl/servant/service_ihp_top.v rtl/servant/servant_clock_gen.v std_cells/* ORFS_netlist/post_synthesis/QuadCore.v
	vvp rtl_sim
