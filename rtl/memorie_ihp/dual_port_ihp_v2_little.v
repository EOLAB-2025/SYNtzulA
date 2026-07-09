module ihp_fake_dualport_little #(
  parameter RAM_WIDTH = 4,                  
  parameter RAM_DEPTH = 64,                 
  parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE", 
  parameter INIT_FILE = ""                       
)
(
  input [7:0] addra,  
  input [7:0] addrb,  
  input [15:0] dina,           
  input clk,                           
  input wea,                            
  input ena,                            
  input enb,                            
  input rst,                           
  input regceb,                         
  
  output [15:0] doutb                 
);
	
	wire [63:0] A_DOUT, A_DIN;
	wire REN, WEN, MEN;
	reg [7:0] A_ADDR;
		
	//assign REN = addrb[1] && addrb[0] && enb;
	assign WEN = addra[1] && addra[0] && ena && wea;
	assign MEN = REN || WEN;
	
	always@(*) begin
		if (WEN) 
			A_ADDR = addra[7:2];
		else
			A_ADDR = read_addr;
	end
	

	
	//READ LOGIC
	
	reg [63:0] buffer_r;
	reg REN_D, REN_DD;
	reg [15:0] out_buff_r;
	reg [15:0] doutb_d;
	wire [7:0] read_addr;
	
	fsm fsm_read(clk, rst, addra, addrb, enb, REN, read_addr);
	
	always@(posedge clk) begin
		if(rst) begin
			REN_D  <= 0;
			REN_DD <= 0;
		end
		else begin
			REN_D  <= REN;
			REN_DD <= REN_D;	
		end
	end	
	
	always@(posedge clk) begin
		if(rst)
			buffer_r <= 0;
		else if (REN_D) 
			buffer_r <= A_DOUT;	
	end
	
	always@(*) begin 
		case(addrb[1:0])
		        2'b00: out_buff_r = buffer_r[15:0];
			2'b01: out_buff_r = buffer_r[31:16];
			2'b10: out_buff_r = buffer_r[47:32];
			2'b11: out_buff_r = buffer_r[63:48];
		endcase
	end
	
	always@(posedge clk) begin
		if(rst)
			doutb_d <= 0;
		else if (enb) 
			doutb_d <= out_buff_r;	
	end
	
	assign doutb = (REN_DD && enb) ? buffer_r[15:0] : doutb_d;
	
	//WRITE LOGIC
	
	reg [15:0] buffer_w0, buffer_w1, buffer_w2;
	 
	always@(posedge clk) begin
		if(rst) begin
			buffer_w0 <= 0;
			buffer_w1 <= 0;
			buffer_w2 <= 0;
		end
		else if (ena && wea) begin
			buffer_w0 <= dina;
			buffer_w1 <= buffer_w0;
			buffer_w2 <= buffer_w1;
		end	
	end	
	
	assign A_DIN = {dina, buffer_w0, buffer_w1, buffer_w2};
	

	RM_IHPSG13_1P_64x64_c2_bm_bist mem0(
	    .A_CLK(clk),
	    .A_MEN(MEN),
	    .A_WEN(WEN),
	    .A_REN(REN),
	    .A_ADDR(A_ADDR),
	    .A_DIN(A_DIN),
	    .A_DLY(1'b0),
	    .A_DOUT(A_DOUT),
	    .A_BM(64'hFFFFFFFFFFFFFFFF),
	    
	    
	    .A_BIST_CLK(1'b0),
	    .A_BIST_EN(1'b0),
	    .A_BIST_MEN(1'b0),
	    .A_BIST_WEN(1'b0),
	    .A_BIST_REN(1'b0),
	    .A_BIST_ADDR(1'b0),
	    .A_BIST_DIN(1'b0),
	    .A_BIST_BM(1'b0)
	);


endmodule
