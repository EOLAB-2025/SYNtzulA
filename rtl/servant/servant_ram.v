`default_nettype none
module servant_ram
#(//Memory parameters
	parameter depth = 8192,
	parameter aw    = 13,
	parameter RESET_STRATEGY = "MINI",
	parameter memfile = "")
(
	input wire 		i_wb_clk,
	input wire 		i_wb_rst,
	input wire [aw-1:2]     i_wb_adr,
	input wire [31:0] 	i_wb_dat,
	input wire [3:0] 	i_wb_sel,
	input wire 		i_wb_we,
	input wire 		i_wb_cyc,
	output     [31:0] 	o_wb_rdt,
	output reg 		o_wb_ack,
	
	input wire enb_debug,
	
	
	//BOOT
	input wire finish_boot,
	input wire [63:0] boot_ram_data,
	input wire [12:0] boot_ram_addr,
	input wire boot_ram_wren
);

	wire [3:0] we = {4{i_wb_we & i_wb_cyc}} & i_wb_sel;

	reg [31:0] mem [0:depth/4-1] /* verilator public */;

	wire [aw-3:0] addr = i_wb_adr[aw-1:2];

   always @(posedge i_wb_clk)
     if (i_wb_rst & (RESET_STRATEGY != "NONE"))
       o_wb_ack <= 1'b0;
     else
       o_wb_ack <= i_wb_cyc & !o_wb_ack;
       
   

	ihp_ram_boot sevant_ram 
	(	
	.clk(i_wb_clk),
	.i_wb_cyc(i_wb_cyc),
	.we(we),
	.addr(addr),
	.dina(i_wb_dat),
	.dout(o_wb_rdt),
	.enb_debug(enb_debug),
	.finish_boot(finish_boot),
	.boot_ram_data(boot_ram_data),
	.boot_ram_addr(boot_ram_addr),
	.boot_ram_wren(boot_ram_wren)
	);
	
	
/*
	ihp_ram #(.memfile(memfile)) sevant_ram 
	(	
	.clk(i_wb_clk),
	.we(we),
	.addr(addr),
	.dina(i_wb_dat),
	.dout(o_wb_rdt),
	.enb_debug(enb_debug)	
	);
*/


endmodule

















