`default_nettype none

`ifdef SIM
	`include `CONFIG_PATH
`else
	`include "/home/luca/SYNtzulu_ihp/rtl/config/emg/config.txt"
`endif

module service_ihp #(
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
	parameter PLL = "NONE"
)
(
	output wire [3:0] led,
	input  wire [2:0] buttons,
	output wire o_flash_ss,
	output wire o_flash_sck,
	output wire o_flash_mosi,
	input wire  i_flash_miso,
	output wire o_txd,
	
	//input di servant_clk_gen   
	input wire wb_clk,   
	input wire wb_rst,
	
	output wire gate_general, gate_snn, gate_serv,	
	input  wire timer_clk,
	
	output output_buffer_wr_en_debug,
	output signed [WIDTH-1:0] p1, p2,
	input enb_debug	
			
);	
	
    localparam WEIGHT_DEPTH_12 = 8192;
    localparam WEIGHT_DEPTH_34 = 8192;


//////////////////////////////////////////////////////////////////////////////////////
//   ____  _____ ______     ___    _   _ _____                                      //
//  / ___|| ____|  _ \ \   / / \  | \ | |_   _|                                     //
//  \___ \|  _| | |_) \ \ / / _ \ |  \| | | |                                       //
//   ___) | |___|  _ < \ V / ___ \| |\  | | |                                       //
//  |____/|_____|_| \_\ \_/_/   \_\_| \_| |_|                                       //
//   ____  _____ ______     __  ____  ___ ____   ______     __  ____         ____   //
//  / ___|| ____|  _ \ \   / / |  _ \|_ _/ ___| / ___\ \   / / / ___|  ___  / ___|  //
//  \___ \|  _| | |_) \ \ / /  | |_) || |\___ \| |    \ \ / /  \___ \ / _ \| |      //
//   ___) | |___|  _ < \ V /   |  _ < | | ___) | |___  \ V /    ___) | (_) | |___   //
//  |____/|_____|_| \_\ \_/    |_| \_\___|____/ \____|  \_/    |____/ \___/ \____|  //
//                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////

	wire [31:0] wb_acc_adr;
	wire [31:0] wb_acc_dat;
	wire        wb_acc_we;
	wire        wb_acc_cyc;
	wire [31:0] wb_acc_rdt;
	wire 	  	wb_acc_ack;

	wire        acc_snn_valid;
	wire output_buffer_ren;
	wire [7:0] output_buffer_addr;
	wire [31:0] output_buffer_out;
	wire [31:0] acc_snn_adr_w1;
	wire [31:0] acc_snn_adr_w2;
	wire [31:0] acc_snn_adr_w3;
	wire [31:0] acc_snn_adr_w4;
	wire [ 4:0] acc_snn_we;
	wire [15:0] acc_snn_dat;
	wire [clogb2(MAX_SYNAPSES-1)-1:0] snn_input_channels; 
	wire [clogb2(MAX_NEURONS-1)-1:0] neuron_1, neuron_2, neuron_3, neuron_4;
	wire [2:0] layers;
	wire [ 7:0] uart_byte;
	wire [ 3:0] sel;
	wire        uart_tx_go;
	wire        uart_tx_done;
	wire [7:0] o_spike_mem_dat;
	wire [7:0] i_spike_mem_adr;
	wire [1:0] i_spike_mem_rd_en;
	wire [1:0] i_spike_mem_wr_en;
	wire [3:0] i_spike_mem_dat;
	wire [15:0] o_sample_mem_dat;	
	wire [7:0] i_sample_mem_adr;
	wire       i_sample_mem_rd_en; 
	wire        i_sample_mem_wr_en;
	wire [15:0] i_sample_mem_dat; 
	wire encoding_bypass;
	// wire gate_spi, gate_snn, gate_enc, gate_serv, gate_general;
	wire gate_spi, gate_enc;
	wire timer_irq;


	servant #(
		.memfile (memfile)
	)
	
	servant(
		.wb_clk (wb_clk),
		.timer_clk(timer_clk),
		.wb_rst (wb_rst),
		
		.led      (led),
		.buttons(buttons),
		.timer_irq(timer_irq),

		.o_wb_acc_adr   (wb_acc_adr),
		.o_wb_acc_dat   (wb_acc_dat),
		.o_wb_acc_we    (wb_acc_we),
		.o_wb_acc_cyc   (wb_acc_cyc),
		.i_wb_acc_rdt   (wb_acc_rdt),
		.i_wb_acc_ack   (wb_acc_ack),
		
		.enb_debug(enb_debug)
	);

////////////////////////////////////////////////////////////////////////////////////////////////////
//   ____  _   _ ____    ___ _   _ _____ _____ ____   ____ ___  _   _ _   _ _____ ____ _____      //
//  | __ )| | | / ___|  |_ _| \ | |_   _| ____|  _ \ / ___/ _ \| \ | | \ | | ____/ ___|_   _|     //
//  |  _ \| | | \___ \   | ||  \| | | | |  _| | |_) | |  | | | |  \| |  \| |  _|| |     | |       //
//  | |_) | |_| |___) |  | || |\  | | | | |___|  _ <| |__| |_| | |\  | |\  | |__| |___  | |       //
//  |____/ \___/|____/  |___|_| \_| |_| |_____|_| \_\\____\___/|_| \_|_| \_|_____\____| |_|       //
//    __ _           _           _        __                                                      //
//   / _| | __ _ ___| |__       (_)_ __  / _| ___ _ __ ___ _ __   ___ ___                         //
//  | |_| |/ _` / __| '_ \      | | '_ \| |_ / _ \ '__/ _ \ '_ \ / __/ _ \                        //
//  |  _| | (_| \__ \ | | |  _  | | | | |  _|  __/ | |  __/ | | | (_|  __/  _                     //
//  |_| |_|\__,_|___/_| |_| ( ) |_|_| |_|_|  \___|_|  \___|_| |_|\___\___| ( )                    //
//                          |/ _                      _ _                  |/                     //
//   ___  __ _ _ __ ___  _ __ | | ___       ___ _ __ (_) | _____   _ __ ___   ___ _ __ ___  ___   //
//  / __|/ _` | '_ ` _ \| '_ \| |/ _ \     / __| '_ \| | |/ / _ \ | '_ ` _ \ / _ \ '_ ` _ \/ __|  //
//  \__ \ (_| | | | | | | |_) | |  __/  _  \__ \ |_) | |   <  __/ | | | | | |  __/ | | | | \__ \  //
//  |___/\__,_|_| |_| |_| .__/|_|\___| ( ) |___/ .__/|_|_|\_\___| |_| |_| |_|\___|_| |_| |_|___/  //
//                      |_|            |/      |_|                                                //
// 																								  //
////////////////////////////////////////////////////////////////////////////////////////////////////

	accelerator_top 
	acc_top(
	
	.wb_clk(wb_clk),
	.spi_clk(wb_clk),
	.wb_rst(wb_rst),

	.i_cpu_adr(wb_acc_adr),
	.i_cpu_dat(wb_acc_dat),
	.i_cpu_we(wb_acc_we),
	.i_cpu_cyc(wb_acc_cyc),
	.o_cpu_rdt(wb_acc_rdt),
	.o_cpu_ack(wb_acc_ack),

	.o_flash_sck(o_flash_sck),
	.o_flash_mosi(o_flash_mosi),
	.o_flash_ss(o_flash_ss),
	.i_flash_miso(i_flash_miso),

	.i_snn_valid(acc_snn_valid),
	.output_buffer_ren(output_buffer_ren),
	.output_buffer_addr(output_buffer_addr),
	.output_buffer_out(output_buffer_out),
	.o_snn_adr_w1(acc_snn_adr_w1),
	.o_snn_adr_w2(acc_snn_adr_w2),
	.o_snn_adr_w3(acc_snn_adr_w3),
	.o_snn_adr_w4(acc_snn_adr_w4),
	.o_snn_we(acc_snn_we),
	.o_snn_dat(acc_snn_dat),
	.snn_input_channels(snn_input_channels), 
	.neuron_1(neuron_1), .neuron_2(neuron_2), .neuron_3(neuron_3), .neuron_4(neuron_4), 
	.layers(layers),
	.o_txd(o_txd),
	.i_spike_mem_dat(o_spike_mem_dat),
	.o_spike_mem_adr(i_spike_mem_adr),
	.o_spike_mem_rd_en(i_spike_mem_rd_en),		
	.o_spike_mem_wr_en(i_spike_mem_wr_en),
	.o_spike_mem_dat(i_spike_mem_dat),
	.i_sample_mem_dat(o_sample_mem_dat),	
	.o_sample_mem_adr(i_sample_mem_adr),
	.o_sample_mem_rd_en(i_sample_mem_rd_en),
	.o_sample_mem_wr_en(i_sample_mem_wr_en),
	.o_sample_mem_dat(i_sample_mem_dat),
	.o_encoding_bypass(encoding_bypass),
	.gate_spi(gate_spi), .gate_snn(gate_snn), .gate_enc(gate_enc), .gate_serv(gate_serv), 
	.timer_irq(timer_irq), .gate_general(gate_general)
    );




///////////////////////////////////////////////////////////////////////////////////////
//   ____              _             _                                               //
//  / ___| _   _ _ __ | |_ _____   _| |_   _   _                                     //
//  \___ \| | | | '_ \| __|_  / | | | | | | | (_)                                    //
//   ___) | |_| | | | | |_ / /| |_| | | |_| |  _                                     //
//  |____/ \__, |_| |_|\__/___|\__,_|_|\__,_| (_)                                    //
//   __  __|___/                  _ _                  _ _ _                         //
//  |  \/  | ___  ___  __ _ _   _(_) |_ ___           | (_) | _____                  //
//  | |\/| |/ _ \/ __|/ _` | | | | | __/ _ \   _____  | | | |/ / _ \                 //
//  | |  | | (_) \__ \ (_| | |_| | | || (_) | |_____| | | |   <  __/                 //
//  |_|  |_|\___/|___/\__, |\__,_|_|\__\___/          |_|_|_|\_\___|                 //
//                       |_|                                                         //
//   _____ _       _     _                                   ____ ___ __  __ ____    //
//  | ____(_) __ _| |__ | |_          __      ____ _ _   _  / ___|_ _|  \/  |  _ \   //
//  |  _| | |/ _` | '_ \| __|  _____  \ \ /\ / / _` | | | | \___ \| || |\/| | | | |  //
//  | |___| | (_| | | | | |_  |_____|  \ V  V / (_| | |_| |  ___) | || |  | | |_| |  //
//  |_____|_|\__, |_| |_|\__|           \_/\_/ \__,_|\__, | |____/___|_|  |_|____/   //
//           |___/                                   |___/                           //
//   ____  _   _ _   _                                                               //
//  / ___|| \ | | \ | |  _ __  _ __ ___   ___ ___  ___ ___  ___  _ __                //
//  \___ \|  \| |  \| | | '_ \| '__/ _ \ / __/ _ \/ __/ __|/ _ \| '__|               //
//   ___) | |\  | |\  | | |_) | | | (_) | (_|  __/\__ \__ \ (_) | |                  //
//  |____/|_| \_|_| \_| | .__/|_|  \___/ \___\___||___/___/\___/|_|                  //
//                      |_|                                                          //
// 																					 //
///////////////////////////////////////////////////////////////////////////////////////

    Syntzulu 
     
    mosquito
    (
	.clk_enc    (wb_clk),
	.clk_snn    (wb_clk), 
	.rst        (wb_rst),
	
	.en         (acc_snn_we[4]),
	.data_in    (acc_snn_dat),
	.detect     (1'b1),

	.encoding_bypass(1'b0),

	.valid  (acc_snn_valid),

	.weight_mem_L1_wren     ({8{acc_snn_we[0]}}),
	.weight_mem_L1_wr_addr  (acc_snn_adr_w1),
	.weight_mem_L1_data_in  (acc_snn_dat),
	.weight_mem_L1_ena      (acc_snn_we[0]),

	.weight_mem_L2_wren     ({8{acc_snn_we[1]}}),
	.weight_mem_L2_wr_addr  (acc_snn_adr_w2),
	.weight_mem_L2_data_in  (acc_snn_dat),
	.weight_mem_L2_ena      (acc_snn_we[1]),

	.weight_mem_L3_wren     ({8{acc_snn_we[2]}}),
	.weight_mem_L3_wr_addr  (acc_snn_adr_w3),
	.weight_mem_L3_data_in  (acc_snn_dat),
	.weight_mem_L3_ena      (acc_snn_we[2]),

	.weight_mem_L4_wren     ({8{acc_snn_we[3]}}),
	.weight_mem_L4_wr_addr  (acc_snn_adr_w4),
	.weight_mem_L4_data_in  (acc_snn_dat),
	.weight_mem_L4_ena      (acc_snn_we[3]),

	// ACCESSIBILITY
	.o_spike_mem_dat(o_spike_mem_dat),
	.i_spike_mem_adr(i_spike_mem_adr),
	.i_spike_mem_rd_en(i_spike_mem_rd_en),
	.i_spike_mem_wr_en(i_spike_mem_wr_en),
	.i_spike_mem_dat(i_spike_mem_dat),
	.o_sample_mem_dat(o_sample_mem_dat),	
	.i_sample_mem_adr(i_sample_mem_adr),
	.i_sample_mem_rd_en(i_sample_mem_rd_en),
	.i_sample_mem_wr_en(i_sample_mem_wr_en),
	.i_sample_mem_dat(i_sample_mem_dat),

	// CONFIGURABILITY
	.snn_input_channels(snn_input_channels), 
	.neuron_1(neuron_1), .neuron_2(neuron_2), .neuron_3(neuron_3), .neuron_4(neuron_4),
	.layers(layers),

	// OUTPUT BUFFER ACCESS

	.output_buffer_ren(output_buffer_ren),
	.output_buffer_addr(output_buffer_addr),
	.output_buffer_out(output_buffer_out),
	
	.output_buffer_wr_en_debug(output_buffer_wr_en_debug),
	.p1(p1), 
	.p2(p2),
	
	.enb_debug(enb_debug)
    );
    

	//  The following function calculates the address width based on specified RAM depth
	function integer clogb2;
	  input integer depth;
		for (clogb2=0; depth>0; clogb2=clogb2+1)
		  depth = depth >> 1;
	endfunction   

endmodule
