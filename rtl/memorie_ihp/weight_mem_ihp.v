module weights_mem_ihp #(
    parameter RAM_DEPTH = 4096,
    parameter RAM_WIDTH = 32,
    parameter INIT_FILE = ""
)
(
  input [11:0] addra1,   
  input [15:0] dina1,
  input ena1,
  input wea1,
  
  input [11:0] addra2,
  input [15:0] dina2,  
  input ena2, 
  input wea2,
  
  input [11:0] addrb,         
  input clk,                                                      
  input enb,                            
  input rst,                           
  input regceb,                         
  
  output reg [31:0] doutb                   
    );
    
    wire [31:0] doutb_tmp;
    wire A_MEN;
    wire A_WEN;
    wire A_REN;
    reg  [10:0] A_ADDR;
    reg  [63:0] A_BM;
    wire [63:0] A_DOUT;
    reg  [63:0] A_DIN;
    
    assign A_MEN  = ena1 || ena2 || enb ;
    assign A_WEN  = ena1 || ena2;
    assign A_REN  = enb;
    
    assign doutb_tmp = addrb[11] ? A_DOUT[63:32] : A_DOUT[31:0];
    
    
    //MASCHERA
    always@(*) begin 
       	
    	if(ena1) begin   		
    		if (addra1[11]) begin 
    			A_BM = 64'hFFFF000000000000;
    			A_DIN = {dina1, 48'h000000000000}; end
    		else begin
    			A_BM = 64'h00000000FFFF0000;
    			A_DIN = {32'h000000000000, dina1, 16'h0000}; end
    	end		
    				
    	else if (ena2) begin
    		if (addra2[11]) begin
    			A_BM = 64'h0000FFFF00000000;
    			A_DIN = {16'h0000, dina2, 32'h00000000}; end
    		else begin
    			A_BM = 64'h000000000000FFFF;
    			A_DIN = {48'h000000000000, dina2}; end
    	end
    	
    	else begin
    			A_BM  = 64'h0000000000000000;
    			A_DIN = 64'h0000000000000000; end		
         
    end
    
    //INDIRIZZO
    always@(*) begin    	
    	if(ena1)   		
		A_ADDR = addra1[10:0];
		
    	else if(ena2)
    		A_ADDR = addra2[10:0];
    		
    	else 
    		A_ADDR = addrb[10:0];
    end    
    


	RM_IHPSG13_1P_2048x64_c2_bm_bist mem(
	    .A_CLK(clk),
	    .A_MEN(A_MEN),		//Memory enable, activates memory for read/write.
	    .A_WEN(A_WEN),		//Write enable, triggers write operation to memory.
	    .A_REN(A_REN),		//Read enable, triggers read operation from memory.
	    .A_ADDR(A_ADDR),
	    .A_DIN(A_DIN),
	    .A_DLY(1'b0),		//Delay control, possibly for timing adjustments.
	    .A_DOUT(A_DOUT),
	    .A_BM(A_BM),
	    .A_BIST_CLK(1'b0),
	    .A_BIST_EN(1'b0),
	    .A_BIST_MEN(1'b0),
	    .A_BIST_WEN(1'b0),
	    .A_BIST_REN(1'b0),
	    .A_BIST_ADDR(1'b0),
	    .A_BIST_DIN(1'b0),
	    .A_BIST_BM(1'b0)
	);
	

always@(posedge clk) begin
	if(rst) 
		doutb <= 0;
	else
		doutb <= doutb_tmp;
end



endmodule




module weights_mem_ihp_qc #(
    parameter RAM_DEPTH = 4096,
    parameter RAM_WIDTH = 32,
    parameter INIT_FILE = ""
)
(
  input [10:0] addra1,   
  input [15:0] dina1,
  input ena1,
  input wea1,
  
  input [10:0] addrb,         
  input clk,                                                      
  input enb,                            
  input rst,                           
  input regceb,                         
  
  output reg [31:0] doutb                   
);
    
    wire [31:0] doutb_tmp;
    wire A_MEN;
    wire A_WEN;
    wire A_REN;
    reg  [10:0] A_ADDR;
    reg  [63:0] A_BM;
    wire [63:0] A_DOUT;
    reg  [63:0] A_DIN;
    
    assign A_MEN  = ena1 || enb ;
    assign A_WEN  = ena1;
    assign A_REN  = enb;
    
    assign doutb_tmp = addrb[10] ? A_DOUT[63:32] : A_DOUT[31:0];
    
    
    //MASCHERA
    always@(*) begin 
       	
    	if(ena1) begin   		
    		if (addra1[10]) begin 
    			A_BM = 64'hFFFF000000000000;
    			A_DIN = {dina1, 48'h000000000000}; end
    		else begin
    			A_BM = 64'h00000000FFFF0000;
    			A_DIN = {32'h000000000000, dina1, 16'h0000}; end
    	end    	
    	else begin
    			A_BM  = 64'h0000000000000000;
    			A_DIN = 64'h0000000000000000; end		     
    end
    
    //INDIRIZZO
    always@(*) begin    	
    	if(ena1)   		
		A_ADDR = addra1[9:0];
    	else 
    		A_ADDR = addrb[9:0];
    end    
    
`ifdef SIM

	RM_IHPSG13_1P_1024x64_c2_bm_bist #(.INIT_FILE(INIT_FILE)) mem(
	    .A_CLK(clk),
	    .A_MEN(A_MEN),		//Memory enable, activates memory for read/write.
	    .A_WEN(A_WEN),		//Write enable, triggers write operation to memory.
	    .A_REN(A_REN),		//Read enable, triggers read operation from memory.
	    .A_ADDR(A_ADDR),
	    .A_DIN(A_DIN),
	    .A_DLY(1'b0),		//Delay control, possibly for timing adjustments.
	    .A_DOUT(A_DOUT),
	    .A_BM(A_BM),
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
	RM_IHPSG13_1P_1024x64_c2_bm_bist mem(
	    .A_CLK(clk),
	    .A_MEN(A_MEN),		//Memory enable, activates memory for read/write.
	    .A_WEN(A_WEN),		//Write enable, triggers write operation to memory.
	    .A_REN(A_REN),		//Read enable, triggers read operation from memory.
	    .A_ADDR(A_ADDR),
	    .A_DIN(A_DIN),
	    .A_DLY(1'b0),		//Delay control, possibly for timing adjustments.
	    .A_DOUT(A_DOUT),
	    .A_BM(A_BM),
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

always@(posedge clk) begin
	if(rst) 
		doutb <= 0;
	else
		doutb <= doutb_tmp;
end



endmodule


module weights_mem_ihp_qc_2048x64 #(
    parameter RAM_DEPTH = 4096,
    parameter RAM_WIDTH = 32,
    parameter INIT_FILE = ""
)
(
  input [10:0] addra1,   
  input [15:0] dina1,
  input ena1,
  input wea1,
  
  input [10:0] addrb,         
  input clk,                                                      
  input enb,                            
  input rst,                           
  input regceb,                         
  
  output reg [63:0] doutb                   
);
    
    //wire [31:0] doutb_tmp;
    wire A_MEN;
    wire A_WEN;
    wire A_REN;
    //reg  [10:0] A_ADDR;
    //reg  [63:0] A_BM;
    wire [63:0] A_DOUT;
    reg  [63:0] A_DIN;
    
    assign A_MEN  = ena1 || enb ;
    assign A_WEN  = ena1;
    assign A_REN  = enb;
      
    
`ifdef SIM

	RM_IHPSG13_1P_2048x64_c2_bm_bist #(.INIT_FILE(INIT_FILE)) mem(
	    .A_CLK(clk),
	    .A_MEN(A_MEN),		//Memory enable, activates memory for read/write.
	    .A_WEN(A_WEN),		//Write enable, triggers write operation to memory.
	    .A_REN(A_REN),		//Read enable, triggers read operation from memory.
	    .A_ADDR(addrb),
	    .A_DIN(A_DIN),
	    .A_DLY(1'b0),		//Delay control, possibly for timing adjustments.
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
`else	
	RM_IHPSG13_1P_2048x64_c2_bm_bist mem(
	    .A_CLK(clk),
	    .A_MEN(A_MEN),		//Memory enable, activates memory for read/write.
	    .A_WEN(A_WEN),		//Write enable, triggers write operation to memory.
	    .A_REN(A_REN),		//Read enable, triggers read operation from memory.
	    .A_ADDR(addrb),
	    .A_DIN(A_DIN),
	    .A_DLY(1'b0),		//Delay control, possibly for timing adjustments.
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


`endif

always@(posedge clk) begin
	if(rst) 
		doutb <= 0;
	else
		doutb <= A_DOUT;
end



endmodule



