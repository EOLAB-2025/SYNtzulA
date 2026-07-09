#################################################################### Design 
current_design service_ihp_chip

#################################################################### Clock del sistema 
set clk_name  wb_clk
set clk_port_name wb_clk
set clk_period 8
set clk_port [get_ports $clk_port_name]
create_clock -name $clk_name -period $clk_period $clk_port

#################################################################### Clock del timer responsabile gating 
set clk_name  timer_clk
set clk_port_name timer_clk
set clk_period 100000
set clk_port [get_ports $clk_port_name]
create_clock -name $clk_name -period $clk_period $clk_port

set_max_fanout 8 [current_design]


#################################################################### 

set_max_delay 2 -from [get_pins \service_ihp.acc_top.aif.snn_address[30]\$_DFFE_PP_/Q] \
		-to [get_pins \service_ihp.mosquito.snn_lp_i.weight_mem.mem34_1024_2048/A_WEN]
		
set_max_delay 2 -from [get_pins \service_ihp.acc_top.aif.snn_address[30]\$_DFFE_PP_/Q] \
		-to [get_pins \service_ihp.mosquito.snn_lp_i.weight_mem.mem34_1024_2048/A_ADDR[9]]

set_max_delay 2 -from [get_pins \service_ihp.acc_top.aif.snn_address[30]\$_DFFE_PP_/Q] \
		-to [get_pins \service_ihp.mosquito.snn_lp_i.weight_mem.mem34_0_1024/A_ADDR[9]]

set_max_delay 2 -from [get_pins \service_ihp.acc_top.aif.snn_address[30]\$_DFFE_PP_/Q] \
		-to [get_pins \service_ihp.mosquito.snn_lp_i.weight_mem.mem34_1024_2048/A_ADDR[3]]

set_max_delay 2 -from [get_pins \service_ihp.acc_top.aif.snn_address[30]\$_DFFE_PP_/Q] \
		-to [get_pins \service_ihp.mosquito.snn_lp_i.weight_mem.mem34_0_1024/A_ADDR[3]]


