setup_orfs_folder:
	mkdir -p ../OpenROAD-flow-scripts/flow/designs/ihp-sg13g2/SYNtzulA
	cp orfs_setup/template/config.mk orfs_setup/
	python3 orfs_setup/generate_orfs_files.py
	cp orfs_setup/config.mk                ../OpenROAD-flow-scripts/flow/designs/ihp-sg13g2/SYNtzulA
	cp orfs_setup/constraint.sdc           ../OpenROAD-flow-scripts/flow/designs/ihp-sg13g2/SYNtzulA
	cp orfs_setup/service_placement.cfg    ../OpenROAD-flow-scripts/flow/designs/ihp-sg13g2/SYNtzulA
	cp orfs_setup/pdn.tcl                  ../OpenROAD-flow-scripts/flow/designs/ihp-sg13g2/SYNtzulA

simulate_service_ihp_dual_core:
	iverilog -D SIM -D SIM_RTL -o rtl_sim  rtl/define.v sim/tb/servant_tb.v sim/tb/servant_sim.v sim/tb/uart_decoder.v sim/tb/vlog_tb_utils.v sim/tb/flash_spi_sim.sv rtl/servant/* rtl/serv/* rtl/syntzulu_ihp/* rtl/memorie_ihp/* rtl/behavioural_ihp/* std_cells/*
	vvp rtl_sim

simulate_service_ihp_dual_core_ps:
	cp ../OpenROAD-flow-scripts/flow/results/ihp-sg13g2/SYNtzulA/base/1_synth.v ./ORFS_netlist/post_synthesis/
	python3 ./ORFS_netlist/post_synthesis/init_synth.py
	iverilog -D PS -D SIM -o rtl_sim  rtl/define.v sim/tb/servant_tb.v sim/tb/servant_sim.v sim/tb/uart_decoder.v sim/tb/vlog_tb_utils.v sim/tb/flash_spi_sim.sv rtl/behavioural_ihp/* rtl/servant/service_ihp_top.v rtl/servant/servant_clock_gen.v std_cells/* ORFS_netlist/post_synthesis/1_synth.v
	vvp rtl_sim
