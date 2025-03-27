`default_nettype none

`ifdef SIM
	`include `CONFIG_PATH
`else
	`include "/home/luca/SYNtzulu_ihp/rtl/config/emg/config.txt"
`endif

module service_ihp_top #(
	parameter SIM = 1,
	parameter ENCODING_BYPASS = 0,
	parameter CHANNELS = `INPUT_CHANNELS,
	parameter ORDER = 2,
	parameter WINDOW = 8192,
	parameter REF_PERIOD = 1024,
	parameter DW = `DW,

	parameter WIDTH = 16,

	parameter MAX_NEURONS = 128,
	parameter MAX_SYNAPSES = 128,

	parameter INPUT_SPIKE_1 = `INPUT_SPIKE_1, 
	parameter NEURON_1 = `NEURON_1,  
	parameter WEIGHTS_FILE_1 = "weights_1.txt",
	parameter [13:0] current_decay_1 = `CURRENT_DECAY_1,
	parameter [13:0] voltage_decay_1 = `VOLTAGE_DECAY_1,
	parameter [WIDTH-1:0] threshold_1 = `THRESHOLD_1,

	parameter INPUT_SPIKE_2 = NEURON_1,
	parameter NEURON_2 = `NEURON_2,
	parameter WEIGHTS_FILE_2 = "weights_2.txt",
	parameter [13:0] current_decay_2 = `CURRENT_DECAY_2,
	parameter [13:0] voltage_decay_2 = `VOLTAGE_DECAY_2,
	parameter [WIDTH-1:0] threshold_2 = `THRESHOLD_2,

	parameter INPUT_SPIKE_3 = NEURON_2, 
	parameter NEURON_3 = `NEURON_3,  
	parameter WEIGHTS_FILE_3 = "weights_3.txt",
	parameter [13:0] current_decay_3 = `CURRENT_DECAY_3,
	parameter [13:0] voltage_decay_3 = `VOLTAGE_DECAY_3,
	parameter [WIDTH-1:0] threshold_3 = `THRESHOLD_3,

	parameter INPUT_SPIKE_4 = NEURON_3,
	parameter NEURON_4 = `NEURON_4,
	parameter WEIGHTS_FILE_4 = "weights_4.txt",
	parameter [13:0] current_decay_4 = `CURRENT_DECAY_4,
	parameter [13:0] voltage_decay_4 = `VOLTAGE_DECAY_4,
	parameter [WIDTH-1:0] threshold_4 = `THRESHOLD_4,

	parameter DOUBLE_CLOCK = 0, // if DOUBLE_CLOCK = 0 clk is generated from HFOSC, allowed freq are 48,24,12,6
	parameter pClockFrequency = 24_000_000/(DOUBLE_CLOCK+1),
	parameter DIVR = 4'b0000,
	parameter DIVF = 7'b1010100,
	parameter DIVQ = 3'b110,
	parameter HFOSC = "0b01", // "0b00" = 48 MHz, "0b01" = 24 MHz, "0b10" = 12 MHz, "0b11" = 6 MHz

	parameter memfile = "firmware/exe.hex",
	parameter memsize =  4096,
	parameter PLL = "ICE40_PAD"
)
(
	input wire  i_clk, i_rst,
	output wire [3:0] led,
	input  wire [2:0] buttons,
	output wire o_flash_ss,
	output wire o_flash_sck,
	output wire o_flash_mosi,
	input wire  i_flash_miso,
	output wire o_txd	
);	
	
    localparam WEIGHT_DEPTH_12 = 8192;
    localparam WEIGHT_DEPTH_34 = 8192;

//////////////////////////////////////////////////////////////////////////////////
//   ____  _     _            ____ _     _  __               ____ _____ _   _   //
//  |  _ \| |   | |      _   / ___| |   | |/ /___           / ___| ____| \ | |  //
//  | |_) | |   | |     (_) | |   | |   | ' // __|  _____  | |  _|  _| |  \| |  //
//  |  __/| |___| |___   _  | |___| |___| . \\__ \ |_____| | |_| | |___| |\  |  //
//  |_|   |_____|_____| (_)  \____|_____|_|\_\___/          \____|_____|_| \_|  //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

	wire      wb_clk;
	wire      wb_rst;
	wire      spi_clk;
	wire	  rst_gfcm;
	wire      slow_clk;
	wire      gate_general;


	servant_clock_gen #(.SIM(SIM), .DOUBLE_CLOCK(DOUBLE_CLOCK), .DIVR(DIVR), .DIVF(DIVF), .DIVQ(DIVQ), .HFOSC(HFOSC))
	clock_gen(
		.i_clk      (i_clk),
		.i_rst	    (i_rst),
		.o_clk      (spi_clk),   
		.o_half_clk (wb_clk),   
		.o_slow_clk (slow_clk), // 10 kHz
		.o_rst      (wb_rst),
		.o_rst_gfcm (rst_gfcm),
		.bypass     (1'b0),
		.low_power_mode(1'b1)  //mettere gate_general se si vuole il gating -- mettere 1'b1 se non si vuole il gating
	);
	
	wire timer_clk;
	wire gate_snn;
	wire gate_serv;
	wire rst;
	
	wire spi_clk_g;
	wire wb_clk_snn; 
	wire wb_clk_enc;
	wire wb_clk_serv;
	
	assign rst = wb_rst;
	
	
	`ifdef LOW_POWER
		assign spi_clk_g    = spi_clk;
		assign wb_clk_snn   = wb_clk;
		assign wb_clk_enc   = wb_clk;
		assign wb_clk_serv  = wb_clk;
		
	`else
		assign spi_clk_g    = spi_clk;
		assign wb_clk_snn   = wb_clk;
		assign wb_clk_enc   = wb_clk;
		assign wb_clk_serv  = wb_clk;
	`endif
	
	assign timer_clk = slow_clk;
	
	
	service_ihp_chip   

	service_ihp_chip(	        
	
				//.led(led),
				.buttons(buttons),
				
				.o_flash_ss(o_flash_ss),
				.o_flash_sck(o_flash_sck),
				.o_flash_mosi(o_flash_mosi),
				.i_flash_miso(i_flash_miso),
				
				.wb_clk    (i_clk  ),
				.wb_rst    (wb_rst ),
				.timer_clk (timer_clk),
				.enb_debug(1'b1)
				
				//.o_txd(o_txd)
				
				//.gate_general(gate_general)
				//.gate_snn       (gate_snn),
				//.gate_serv      (gate_serv),
				
			
			);	



	//  The following function calculates the address width based on specified RAM depth
	function integer clogb2;
	  input integer depth;
		for (clogb2=0; depth>0; clogb2=clogb2+1)
		  depth = depth >> 1;
	endfunction   

endmodule
