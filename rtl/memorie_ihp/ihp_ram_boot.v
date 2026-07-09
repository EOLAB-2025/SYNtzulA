module ihp_ram_boot # (parameter memfile="") 
(
	input wire clk,
	input wire [3:0] we,
	input wire [9:0] addr,
	input wire [63:0] dina,
	output [63:0] dout,
	input wire enb_debug,
	
	//BOOT
	input wire i_wb_cyc,
	input wire finish_boot,
	input wire [63:0] boot_ram_data,
	input wire [12:0] boot_ram_addr,
	input wire boot_ram_wren
);

	wire [31:0] BM;
	reg [7:0] B1, B2, B3, B4;
	
	wire [63:0] dout_ram, dout_rom;
	wire [1:0] sel_out_mem;


	assign wea = (|we);
	//bitmask
	always @(posedge clk) begin
	    if (we[0]) B1 = 8'hFF; else B1 = 8'h00;
	    if (we[1]) B2 = 8'hFF; else B2 = 8'h00;
	    if (we[2]) B3 = 8'hFF; else B3 = 8'h00;
	    if (we[3]) B4 = 8'hFF; else B4 = 8'h00;
	end
	
	assign BM = wea ? {32'hFFFFFFFF, B4, B3, B2, B1} : 32'hFFFFFFFF;

	wire [9:0]  addr_ram;
	wire [63:0] dina_ram;
	wire         wen_ram;	
	wire [63:0]   bm_ram;
	
	assign  wen_ram = finish_boot ? wea  : boot_ram_wren;
	assign addr_ram = finish_boot ? addr : boot_ram_addr;
	assign dina_ram = finish_boot ? dina : boot_ram_data;
	assign   bm_ram = finish_boot ?    32'hFFFFFFFF : BM;
	
	
	rom_boot rom(
	    .A_CLK(clk),	    
	    .A_REN(enb_debug),	    
	    .A_ADDR(addr),
	    .A_DOUT(dout_rom)   
	);

/*
	RM_IHPSG13_1P_1024x64_c2_bm_bist #(.INIT_FILE(memfile)) rom_debug(

	    .A_CLK(clk),	    
	    .A_REN(enb_debug),	    
	    .A_ADDR(addr),
	    .A_DOUT(dout_rom),
	    
	    
	    .A_MEN(enb_debug),
	    .A_WEN(wen_ram),
    
	    .A_BIST_CLK(1'b0),
	    .A_BIST_EN(1'b0),
	    .A_BIST_MEN(1'b0),
	    .A_BIST_WEN(1'b0),
	    .A_BIST_REN(1'b0),
	    .A_BIST_ADDR(1'b0),
	    .A_BIST_DIN(1'b0),
	    .A_BIST_BM(1'b0)	    
	    
	);	

*/
	RM_IHPSG13_1P_1024x64_c2_bm_bist ram(

	    .A_CLK(clk),
	    
	    .A_MEN(enb_debug),
	    .A_WEN(wen_ram),
	    .A_REN(enb_debug),
	    
	    .A_ADDR(addr_ram),
	    .A_DIN(dina_ram),
	    .A_DLY(1'b0),
	    .A_DOUT(dout_ram),
	    .A_BM(bm_ram),
	      
	    .A_BIST_CLK(1'b0),
	    .A_BIST_EN(1'b0),
	    .A_BIST_MEN(1'b0),
	    .A_BIST_WEN(1'b0),
	    .A_BIST_REN(1'b0),
	    .A_BIST_ADDR(1'b0),
	    .A_BIST_DIN(1'b0),
	    .A_BIST_BM(1'b0)
	    
	);	

	assign dout = finish_boot ? dout_ram : dout_rom;	
		

endmodule
