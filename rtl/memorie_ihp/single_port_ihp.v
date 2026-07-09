module ihp_single_port_256x48 #(
  parameter RAM_WIDTH = 4,                  
  parameter RAM_DEPTH = 64,                 
  parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE", 
  parameter INIT_FILE = ""                       
)
(
  input [7:0] addra,  
  input [7:0] addrb,  
  input [47:0] dina,           
  input clk,                           
  input wea,                            
  input ena,                            
  input enb,                            
  input rst,                           
  input regceb,                         
  
  output [47:0] doutb                 
);


assign MEN = ena || enb ;
assign WEN = ena || wea ;
assign REN = enb ;

wire [7:0] ADDR;
assign ADDR = WEN ? addra : addrb;

wire [47:0] ram_data_b;

`ifdef SIM
RM_IHPSG13_1P_256x48_c2_bm_bist #(.INIT_FILE(INIT_FILE)) single_port(
    .A_CLK(clk),
    .A_MEN(MEN),
    .A_WEN(WEN),
    .A_REN(REN),
    .A_ADDR(ADDR),
    .A_DIN(dina),
    .A_DLY(1'b0),
    .A_DOUT(ram_data_b),
    .A_BM(48'hFFFFFFFFFFFF),
    
    
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

RM_IHPSG13_1P_256x48_c2_bm_bist single_port(
    .A_CLK(clk),
    .A_MEN(MEN),
    .A_WEN(WEN),
    .A_REN(REN),
    .A_ADDR(ADDR),
    .A_DIN(dina),
    .A_DLY(1'b0),
    .A_DOUT(ram_data_b),
    .A_BM(48'hFFFFFFFFFFFF),
    
    
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



  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign doutb = ram_data_b;

    end else begin: output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      reg [RAM_WIDTH-1:0] doutb_reg = {RAM_WIDTH{1'b0}};

      always @(posedge clk)
        if (rst)
          doutb_reg <= {RAM_WIDTH{1'b0}};
        else if (regceb)
          doutb_reg <= ram_data_b;

      assign doutb = doutb_reg;

    end
  endgenerate

endmodule

module ihp_single_port_256x64 #(
  parameter RAM_WIDTH = 4,                  
  parameter RAM_DEPTH = 64,                 
  parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE", 
  parameter INIT_FILE = ""                       
)
(
  input [7:0] addra,  
  input [7:0] addrb,  
  input [63:0] dina,           
  input clk,                           
  input wea,                            
  input ena,                            
  input enb,                            
  input rst,                           
  input regceb,                         
  
  output [63:0] doutb                 
);


assign MEN = ena || enb ;
assign WEN = ena || wea ;
assign REN = enb ;

wire [7:0] ADDR;
assign ADDR = WEN ? addra : addrb;

wire [47:0] ram_data_b;

`ifdef SIM
RM_IHPSG13_1P_256x64_c2_bm_bist #(.INIT_FILE(INIT_FILE)) single_port(
    .A_CLK(clk),
    .A_MEN(MEN),
    .A_WEN(WEN),
    .A_REN(REN),
    .A_ADDR(ADDR),
    .A_DIN(dina),
    .A_DLY(1'b0),
    .A_DOUT(ram_data_b),
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


`else

RM_IHPSG13_1P_256x64_c2_bm_bist single_port(
    .A_CLK(clk),
    .A_MEN(MEN),
    .A_WEN(WEN),
    .A_REN(REN),
    .A_ADDR(ADDR),
    .A_DIN(dina),
    .A_DLY(1'b0),
    .A_DOUT(ram_data_b),
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

`endif



  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign doutb = ram_data_b;

    end else begin: output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      reg [RAM_WIDTH-1:0] doutb_reg = {RAM_WIDTH{1'b0}};

      always @(posedge clk)
        if (rst)
          doutb_reg <= {RAM_WIDTH{1'b0}};
        else if (regceb)
          doutb_reg <= ram_data_b;

      assign doutb = doutb_reg;

    end
  endgenerate

endmodule





module output_buffer_qc #(
  parameter RAM_WIDTH = 4,                  
  parameter RAM_DEPTH = 64,                 
  parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE", 
  parameter INIT_FILE = ""                       
)
(
  input [7:0] addra,  
  input [7:0] addrb,  
  input [63:0] dina,           
  input clk,                           
  input wea,                            
  input ena,                            
  input enb,                            
  input rst,                           
  input regceb,                         
  
  output [31:0] doutb                 
);


	assign MEN = ena || enb ;
	assign WEN = ena || wea ;
	assign REN = enb ;

	wire [7:0] ADDR;
	reg [63:0] A_BM;
	assign ADDR = WEN ? addra : (addrb>>1);

	reg [31:0] ram_data_b;
	wire [63:0] A_DOUT;

	always@(*) begin
		if(~addrb[0]) begin 
			 ram_data_b = A_DOUT[31:0]; 
		end
		else begin
			 ram_data_b = A_DOUT[63:32];
		end
	end


	RM_IHPSG13_1P_256x64_c2_bm_bist single_port(
	    .A_CLK(clk),
	    .A_MEN(MEN),
	    .A_WEN(WEN),
	    .A_REN(REN),
	    .A_ADDR(ADDR),
	    .A_DIN(dina),
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



  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign doutb = ram_data_b;

    end else begin: output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      reg [RAM_WIDTH-1:0] doutb_reg = {RAM_WIDTH{1'b0}};

      always @(posedge clk)
        if (rst)
          doutb_reg <= {RAM_WIDTH{1'b0}};
        else if (regceb)
          doutb_reg <= ram_data_b;

      assign doutb = doutb_reg;

    end
  endgenerate

endmodule
