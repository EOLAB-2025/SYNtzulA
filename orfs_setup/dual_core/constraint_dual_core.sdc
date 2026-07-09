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

set_max_delay 1.5 -from [get_pins \service_ihp.acc_top.sac.state[1]\$_DFF_P_/Q] \
                 -to   [get_pins \service_ihp.mosquito.snn_lp_i.wmem.wmem2048_4095/A_ADDR[2]]

set_max_delay 1.5 -from [get_pins \service_ihp.acc_top.sac.state[1]\$_DFF_P_/Q] \
                 -to   [get_pins \service_ihp.mosquito.snn_lp_i.wmem.wmem0_2047/A_ADDR[2]]

set_max_delay 4 -from [get_pins \service_ihp.acc_top.aif.snn_address[14]\$_DFFE_PP_/Q] \
                 -to   [get_pins \service_ihp.mosquito.snn_lp_i.wmem.wmem0_2047/A_ADDR[1]]

set_max_delay 4 -from [get_pins \service_ihp.acc_top.aif.snn_address[14]\$_DFFE_PP_/Q] \
                 -to   [get_pins \service_ihp.mosquito.snn_lp_i.wmem.wmem2048_4095/A_ADDR[1]]
