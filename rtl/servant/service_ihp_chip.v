`default_nettype none

`define OPENROAD_CLKGATE

`ifdef SIM
	`include `CONFIG_PATH
`else
	`include "/home/luca/SYNtzulu_ihp/rtl/config/emg/config.txt"
`endif

module service_ihp_chip
(
	//output wire [3:0] led,  
	input  wire [2:0] buttons,    
	
	output wire o_flash_ss,      
	output wire o_flash_sck,     
	output wire o_flash_mosi,    
	input wire  i_flash_miso,
	
	//input di servant_clk_gen   
	input wire wb_clk,              
	input wire wb_rst,              
	
	//output wire gate_general,
	// output wire gate_snn, gate_serv,	  
	input  wire timer_clk,   
	
	//output wire output_buffer_wr_en_debug,
	//output wire signed [15:0] p1, p2,
	input  wire enb_debug
	
	//output wire o_txd
			
);	
	
       wire [2:0] buttons_i;
       wire [3:0] led_i;
       wire signed [15:0] p1_i, p2_i;
       
       wire wb_clk_i, wb_rst_i, enb_debug_i, timer_clk_i, i_flash_miso_i;
       wire o_flash_ss_i, o_flash_sck_i, o_flash_mosi_i;
       wire gate_general_i, gate_snn_i, gate_serv_i;
       wire output_buffer_wr_en_debug_i;
    
       wire o_txd_i;
    
       sg13g2_IOPadIn        pad_wb_clk          (.pad(wb_clk),       .p2c(wb_clk_i));
       sg13g2_IOPadIn        pad_wb_rst          (.pad(wb_rst),       .p2c(wb_rst_i));
       sg13g2_IOPadIn        pad_enb_debug       (.pad(enb_debug),    .p2c(enb_debug_i));    
       sg13g2_IOPadIn        pad_timer_clk       (.pad(timer_clk),    .p2c(timer_clk_i));
       
       sg13g2_IOPadIn        pad_i_flash_miso    (.pad(i_flash_miso), .p2c(i_flash_miso_i));       
       sg13g2_IOPadOut16mA   pad_o_flash_ss      (.pad(o_flash_ss),   .c2p(o_flash_ss_i));
       sg13g2_IOPadOut16mA   pad_o_flash_sck     (.pad(o_flash_sck),  .c2p(o_flash_sck_i));
       sg13g2_IOPadOut16mA   pad_o_flash_mosi    (.pad(o_flash_mosi), .c2p(o_flash_mosi_i));

       sg13g2_IOPadIn        pad_buttons_0    (.pad(buttons[0]),    .p2c(buttons_i[0]));
       sg13g2_IOPadIn        pad_buttons_1    (.pad(buttons[1]),    .p2c(buttons_i[1]));
       sg13g2_IOPadIn        pad_buttons_2    (.pad(buttons[2]),    .p2c(buttons_i[2]));
       
       //sg13g2_IOPadOut16mA    pad_o_txd  (.pad(o_txd),   .c2p(o_txd_i));
         
       
       //sg13g2_IOPadOut16mA   pad_gate_general              (.pad(gate_general),              .c2p(gate_general_i));
       
/* 
       sg13g2_IOPadOut16mA   pad_gate_snn                  (.pad(gate_snn),                  .c2p(gate_snn_i));
       sg13g2_IOPadOut16mA   pad_gate_serv                 (.pad(gate_serv),                 .c2p(gate_serv_i));
       
         
       sg13g2_IOPadOut16mA pad_led_0 (.pad(led[0]), .c2p(led_i[0]));
       sg13g2_IOPadOut16mA pad_led_1 (.pad(led[1]), .c2p(led_i[1]));
       sg13g2_IOPadOut16mA pad_led_2 (.pad(led[2]), .c2p(led_i[2]));
       sg13g2_IOPadOut16mA pad_led_3 (.pad(led[3]), .c2p(led_i[3]));


       sg13g2_IOPadOut16mA   pad_output_buffer_wr_en_debug (.pad(output_buffer_wr_en_debug), .c2p(output_buffer_wr_en_debug_i));
       sg13g2_IOPadOut16mA pad_p1_0  (.pad(p1[0]),  .c2p(p1_i[0]));
       sg13g2_IOPadOut16mA pad_p1_1  (.pad(p1[1]),  .c2p(p1_i[1]));
       sg13g2_IOPadOut16mA pad_p1_2  (.pad(p1[2]),  .c2p(p1_i[2]));
       sg13g2_IOPadOut16mA pad_p1_3  (.pad(p1[3]),  .c2p(p1_i[3]));
       sg13g2_IOPadOut16mA pad_p1_4  (.pad(p1[4]),  .c2p(p1_i[4]));
       sg13g2_IOPadOut16mA pad_p1_5  (.pad(p1[5]),  .c2p(p1_i[5]));
       sg13g2_IOPadOut16mA pad_p1_6  (.pad(p1[6]),  .c2p(p1_i[6]));
       sg13g2_IOPadOut16mA pad_p1_7  (.pad(p1[7]),  .c2p(p1_i[7]));
       sg13g2_IOPadOut16mA pad_p1_8  (.pad(p1[8]),  .c2p(p1_i[8]));
       sg13g2_IOPadOut16mA pad_p1_9  (.pad(p1[9]),  .c2p(p1_i[9]));
       sg13g2_IOPadOut16mA pad_p1_10 (.pad(p1[10]), .c2p(p1_i[10]));
       sg13g2_IOPadOut16mA pad_p1_11 (.pad(p1[11]), .c2p(p1_i[11]));
       sg13g2_IOPadOut16mA pad_p1_12 (.pad(p1[12]), .c2p(p1_i[12]));
       sg13g2_IOPadOut16mA pad_p1_13 (.pad(p1[13]), .c2p(p1_i[13]));
       sg13g2_IOPadOut16mA pad_p1_14 (.pad(p1[14]), .c2p(p1_i[14]));
       sg13g2_IOPadOut16mA pad_p1_15 (.pad(p1[15]), .c2p(p1_i[15]));

       sg13g2_IOPadOut16mA pad_p2_0  (.pad(p2[0]),  .c2p(p2_i[0]));
       sg13g2_IOPadOut16mA pad_p2_1  (.pad(p2[1]),  .c2p(p2_i[1]));
       sg13g2_IOPadOut16mA pad_p2_2  (.pad(p2[2]),  .c2p(p2_i[2]));
       sg13g2_IOPadOut16mA pad_p2_3  (.pad(p2[3]),  .c2p(p2_i[3]));
       sg13g2_IOPadOut16mA pad_p2_4  (.pad(p2[4]),  .c2p(p2_i[4]));
       sg13g2_IOPadOut16mA pad_p2_5  (.pad(p2[5]),  .c2p(p2_i[5]));
       sg13g2_IOPadOut16mA pad_p2_6  (.pad(p2[6]),  .c2p(p2_i[6]));
       sg13g2_IOPadOut16mA pad_p2_7  (.pad(p2[7]),  .c2p(p2_i[7]));
       sg13g2_IOPadOut16mA pad_p2_8  (.pad(p2[8]),  .c2p(p2_i[8]));
       sg13g2_IOPadOut16mA pad_p2_9  (.pad(p2[9]),  .c2p(p2_i[9]));
       sg13g2_IOPadOut16mA pad_p2_10 (.pad(p2[10]), .c2p(p2_i[10]));
       sg13g2_IOPadOut16mA pad_p2_11 (.pad(p2[11]), .c2p(p2_i[11]));
       sg13g2_IOPadOut16mA pad_p2_12 (.pad(p2[12]), .c2p(p2_i[12]));
       sg13g2_IOPadOut16mA pad_p2_13 (.pad(p2[13]), .c2p(p2_i[13]));
       sg13g2_IOPadOut16mA pad_p2_14 (.pad(p2[14]), .c2p(p2_i[14]));
       sg13g2_IOPadOut16mA pad_p2_15 (.pad(p2[15]), .c2p(p2_i[15]));
*/

	wire gate_general, wb_clk_i_gated;
	
	OPENROAD_CLKGATE gating_cell (wb_clk_i, gate_general, wb_clk_i_gated);
	

	service_ihp  service_ihp(	        

		.buttons(buttons_i),

		.o_flash_ss(o_flash_ss_i),
		.o_flash_sck(o_flash_sck_i),
		.o_flash_mosi(o_flash_mosi_i),
		.i_flash_miso(i_flash_miso_i),
		//.o_txd(o_txd_i),

		.wb_clk    (wb_clk_i_gated  ),
		.wb_rst    (wb_rst_i  ),
		.timer_clk (timer_clk_i),

		.gate_general(gate_general),
		//.gate_snn       (gate_snn_i),
		//.gate_serv      (gate_serv_i),

		.enb_debug(enb_debug_i)
		
		
		//.output_buffer_wr_en_debug(output_buffer_wr_en_debug_i),
		//.p1(p1_i), .p2(p2_i)

	);	


	//  The following function calculates the address width based on specified RAM depth
	function integer clogb2;
	  input integer depth;
		for (clogb2=0; depth>0; clogb2=clogb2+1)
		  depth = depth >> 1;
	endfunction   

endmodule
