simulate_service_ihp_dual_core:
	@echo "Simulazione dei moduli: $(DEF)"
	iverilog -D SIM -D SIM_RTL -o rtl_sim  rtl/define.v sim/tb/servant_tb.v sim/tb/servant_sim.v sim/tb/uart_decoder.v sim/tb/vlog_tb_utils.v sim/tb/flash_spi_sim.sv rtl/servant/* rtl/serv/* rtl/syntzulu_ORFS/* rtl/memorie_ihp/* rtl/behavioural_ihp/* std_cells/*
	vvp rtl_sim
	rm rtl_sim 
	mv tb_serv.vcd work/
	gtkwave --save=work/serv_waves.gtkw work/tb_serv.vcd &

simulate_service_ihp_PS:
	@echo "Simulazione dei moduli: $(DEF)"
	mv rtl/servant/service_ihp_chip.v rtl/tmp
	iverilog -D SIM -D PROVA_TB -o rtl_sim  rtl/define.v sim/tb/servant_tb.v sim/tb/servant_sim.v sim/tb/uart_decoder.v sim/tb/vlog_tb_utils.v sim/tb/flash_spi_sim.sv rtl/servant/* rtl/serv/* rtl/syntzulu_ORFS/* rtl/memorie_ihp/* rtl/behavioural_ihp/* PS/*
	mv rtl/tmp/service_ihp_chip.v  rtl/servant
	vvp rtl_sim
	rm rtl_sim 
	mv tb_serv.vcd work/
	gtkwave --save=work/serv_waves.gtkw work/tb_serv.vcd &
	
simulate_service_ihp_final:
	@echo "Simulazione dei moduli: $(DEF)"
	mv rtl/servant/service_ihp_chip.v rtl/tmp
	iverilog -D SIM -D PROVA_TB -o rtl_sim  rtl/define.v sim/tb/servant_tb.v sim/tb/servant_sim.v sim/tb/uart_decoder.v sim/tb/vlog_tb_utils.v sim/tb/flash_spi_sim.sv rtl/servant/* rtl/serv/* rtl/syntzulu_ORFS/* rtl/memorie_ihp/* rtl/behavioural_ihp/* final/*
	mv rtl/tmp/service_ihp_chip.v  rtl/servant
	vvp rtl_sim
	rm rtl_sim 
	mv tb_serv.vcd work/
	gtkwave --save=work/serv_waves.gtkw work/tb_serv.vcd &	
