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
	
	output wire output_buffer_wr_en_debug,
	//output wire signed [15:0] p1, p2,
	input  wire enb_debug,
	
	output wire o_txd,
	input  wire i_rxd
			
);	
	
       wire [2:0] buttons_i;
       wire [3:0] led_i;
       wire signed [15:0] p1_i, p2_i;
       
       wire wb_clk_i, wb_rst_i, enb_debug_i, timer_clk_i, i_flash_miso_i;
       wire o_flash_ss_i, o_flash_sck_i, o_flash_mosi_i;
       wire gate_general_i, gate_snn_i, gate_serv_i;
       wire output_buffer_wr_en_debug_i;
    
       wire o_txd_i;
       wire i_uart_rx;
    
       sg13g2_IOPadIn        pad_wb_clk          (.pad(wb_clk),       .p2c(wb_clk_i));
       
       sg13g2_IOPadIn        pad_uart_rx         (.pad(i_rxd),       .p2c(i_uart_rx));
       
       
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
       
       sg13g2_IOPadOut16mA   pad_output_buffer_wr_en_debug (.pad(output_buffer_wr_en_debug), .c2p(output_buffer_wr_en_debug_i));
       sg13g2_IOPadOut16mA   pad_o_txd  (.pad(o_txd),   .c2p(o_txd_i));   

/*         
       sg13g2_IOPadOut16mA   pad_gate_general              (.pad(gate_general),              .c2p(gate_general_i));
       sg13g2_IOPadOut16mA   pad_gate_snn                  (.pad(gate_snn),                  .c2p(gate_snn_i));
       sg13g2_IOPadOut16mA   pad_gate_serv                 (.pad(gate_serv),                 .c2p(gate_serv_i));      
       sg13g2_IOPadOut16mA pad_led_0 (.pad(led[0]), .c2p(led_i[0]));
       sg13g2_IOPadOut16mA pad_led_1 (.pad(led[1]), .c2p(led_i[1]));
       sg13g2_IOPadOut16mA pad_led_2 (.pad(led[2]), .c2p(led_i[2]));
       sg13g2_IOPadOut16mA pad_led_3 (.pad(led[3]), .c2p(led_i[3]));





    (* keep = "true" *)sg13g2_IOPadVdd pad_vdd0();
    (* keep = "true" *)sg13g2_IOPadVdd pad_vdd1();
    (* keep = "true" *)sg13g2_IOPadVss pad_vss0();
    (* keep = "true" *)sg13g2_IOPadVss pad_vss1();
    
    (* keep = "true" *)sg13g2_IOPadIOVdd pad_vddio0();
    (* keep = "true" *)sg13g2_IOPadIOVdd pad_vddio1();
    (* keep = "true" *)sg13g2_IOPadIOVss pad_vssio0();
    (* keep = "true" *)sg13g2_IOPadIOVss pad_vssio1();
*/

    

	wire gate_general, wb_clk_i_gated;
	
	OPENROAD_CLKGATE gating_cell (wb_clk_i, gate_general, wb_clk_i_gated);
	

	service_ihp  service_ihp(	        

		.buttons(buttons_i),

		.o_flash_ss(o_flash_ss_i),
		.o_flash_sck(o_flash_sck_i),
		.o_flash_mosi(o_flash_mosi_i),
		.i_flash_miso(i_flash_miso_i),
		
		.o_txd(o_txd_i),		
		.i_uart_rx(i_uart_rx),

		.wb_clk    (wb_clk_i_gated  ),
		.wb_rst    (wb_rst_i  ),
		.timer_clk (timer_clk_i),

		.gate_general(gate_general),
		//.gate_snn       (gate_snn_i),
		//.gate_serv      (gate_serv_i),

		.enb_debug(enb_debug_i),
		
		
		.output_buffer_wr_en_debug(output_buffer_wr_en_debug_i)
		//.p1(p1_i), .p2(p2_i)

	);	


	//  The following function calculates the address width based on specified RAM depth
	function integer clogb2;
	  input integer depth;
		for (clogb2=0; depth>0; clogb2=clogb2+1)
		  depth = depth >> 1;
	endfunction   

endmodule
