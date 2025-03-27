module ihp_ram # (parameter memfile="") 
(
	input wire clk,
	input wire [3:0] we,
	input wire [9:0] addr,
	input wire [63:0] dina,
	output wire [63:0] dout,
	input wire enb_debug	

);

	wire [31:0] BM;
	reg [7:0] B1, B2, B3, B4;


	assign wea = (|we);
	//bitmask
	always @(posedge clk) begin
	    if (we[0]) B1 = 8'hFF; else B1 = 8'h00;
	    if (we[1]) B2 = 8'hFF; else B2 = 8'h00;
	    if (we[2]) B3 = 8'hFF; else B3 = 8'h00;
	    if (we[3]) B4 = 8'hFF; else B4 = 8'h00;
	end
	
	assign BM = wea ? {32'hFFFFFFFF, B4, B3, B2, B1} : 32'hFFFFFFFF;



`ifdef SIM
RM_IHPSG13_1P_1024x64_c2_bm_bist #(.INIT_FILE(memfile)) ram(
    .A_CLK(clk),
    
    .A_MEN(enb_debug),
    .A_WEN(wea),
    .A_REN(enb_debug),
    
    .A_ADDR(addr),
    .A_DIN(dina),
    .A_DLY(1'b0),
    .A_DOUT(dout),
    .A_BM(BM),
    
    
    .A_BIST_CLK(1'b0),
    .A_BIST_EN(1'b0),
    .A_BIST_MEN(1'b0),
    .A_BIST_WEN(1'b0),
    .A_BIST_REN(1'b0),
    .A_BIST_ADDR(1'b0),
    .A_BIST_DIN(1'b0),
    .A_BIST_BM(1'b0)
);


`else

RM_IHPSG13_1P_1024x64_c2_bm_bist  ram(

    .A_CLK(clk),
    
    .A_MEN(enb_debug),
    .A_WEN(wea),
    .A_REN(enb_debug),
    
    .A_ADDR(addr),
    .A_DIN(dina),
    .A_DLY(1'b0),
    .A_DOUT(dout),
    .A_BM(BM),
    
    
    .A_BIST_CLK(1'b0),
    .A_BIST_EN(1'b0),
    .A_BIST_MEN(1'b0),
    .A_BIST_WEN(1'b0),
    .A_BIST_REN(1'b0),
    .A_BIST_ADDR(1'b0),
    .A_BIST_DIN(1'b0),
    .A_BIST_BM(1'b0)
    
);

`endif		
		
	

endmodule
