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



module weights_mem_ihp_dc_v2 #(
    parameter RAM_DEPTH = 4096,
    parameter RAM_WIDTH = 64,
    parameter INIT_FILE = ""
)
(
  input [11:0] addra1,   
  input [15:0] dina1,
  input ena1,
  
  input [11:0] addra2,
  input [15:0] dina2,  
  input ena2, 
  
  input [11:0] addra3,
  input [15:0] dina3,  
  input ena3, 
  
  input [11:0] addra4,
  input [15:0] dina4,  
  input ena4, 
  
  input [11:0] addrb,         
  input clk,                                                      
  input enb,                            
  input rst,                           
  input regceb,                         
  
  output reg [63:0] doutb                   
    );

	wire [3:0] sel_waddr;
	reg [11:0] waddr;
	reg [63:0] A_BM;
	reg [63:0] A_DIN;

	assign sel_waddr = {ena4, ena3, ena2, ena1};
	assign enw       = ena4 || ena3 || ena2 || ena1;
	
	always@(*) begin
		case(sel_waddr)
			4'b0001: begin waddr = addra1; A_BM = 64'h00000000FFFF0000; A_DIN = {32'h00000000, dina1, 16'h0000};     end
			4'b0010: begin waddr = addra2; A_BM = 64'h000000000000FFFF; A_DIN = {48'h000000000000, dina2};           end
			4'b0100: begin waddr = addra3; A_BM = 64'hFFFF000000000000; A_DIN = {dina3, 48'h000000000000};           end
			4'b1000: begin waddr = addra4; A_BM = 64'h0000FFFF00000000; A_DIN = {16'h0000, dina4, 32'h00000000};     end
			4'b0000: begin waddr = 0;      A_BM = 64'hFFFFFFFFFFFFFFFF; A_DIN = 0;                                   end
			default: begin waddr = 0;      A_BM = 64'hFFFFFFFFFFFFFFFF; A_DIN = 0;                                   end	
		endcase	
	end
	
	wire [10:0] A_ADDR;
	assign A_ADDR = enw ? waddr : addrb;
	
	assign A_MEN  = (waddr[11] && enw) || (~enw && addrb[11]);
	
	wire [63:0] A_DOUT_0, A_DOUT_1, doutb_tmp;
	
	assign doutb_tmp = A_MEN ? A_DOUT_1 : A_DOUT_0;
	
	always @(posedge clk) begin
		if(rst)
			doutb <= 0;
		else
			doutb <= doutb_tmp;
	end

	
	RM_IHPSG13_1P_2048x64_c2_bm_bist wmem0_2047(
	    .A_CLK(clk),
	    .A_MEN(~A_MEN),		//Memory enable, activates memory for read/write.
	    .A_WEN(enw),		//Write enable, triggers write operation to memory.
	    .A_REN(enb),		//Read enable, triggers read operation from memory.
	    .A_ADDR(A_ADDR),
	    .A_DIN(A_DIN),
	    .A_DLY(1'b0),		//Delay control, possibly for timing adjustments.
	    .A_DOUT(A_DOUT_0),
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

	RM_IHPSG13_1P_2048x64_c2_bm_bist wmem2048_4095(
	    .A_CLK(clk),
	    .A_MEN(A_MEN),		//Memory enable, activates memory for read/write.
	    .A_WEN(enw),		//Write enable, triggers write operation to memory.
	    .A_REN(enb),		//Read enable, triggers read operation from memory.
	    .A_ADDR(A_ADDR),
	    .A_DIN(A_DIN),
	    .A_DLY(1'b0),		//Delay control, possibly for timing adjustments.
	    .A_DOUT(A_DOUT_1),
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


module weights_mem_ihp_qc_2048x64_v3 #(
    parameter RAM_DEPTH = 4096,
    parameter RAM_WIDTH = 32,
    parameter INIT_FILE = ""
)
(
  input [10:0] addra,   
  input [15:0] dina,
  input ena1,
  input ena2,
  input ena3,
  input ena4,
  input wen,
  
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
    wire  [10:0] A_ADDR;
    reg  [63:0] A_BM;
    wire [63:0] A_DOUT;
    reg  [63:0] A_DIN;
    
    assign A_WEN  = wen && (ena1 || ena2 || ena3 || ena4 );
    assign A_REN  = enb;
    assign A_ADDR = A_WEN ? addra : addrb;
       
    assign A_MEN  = A_WEN || A_REN;
    
    always@(*) begin
    	casex({ena1, ena2, ena3, ena4}) 
    		4'b1000: begin A_BM = 64'hFFFF000000000000; A_DIN = { dina, {48{1'bx}} };             end
    		4'b0100: begin A_BM = 64'h0000FFFF00000000; A_DIN = { {16{1'bx}}, dina, {32{1'bx}} }; end
    		4'b0010: begin A_BM = 64'h00000000FFFF0000; A_DIN = { {32{1'bx}}, dina, {16{1'bx}} }; end
    		4'b0001: begin A_BM = 64'h000000000000FFFF; A_DIN = { {48{1'bx}}, dina };             end
    		default: begin A_BM = 64'h0000000000000000; A_DIN = {64{1'bx}} ;                      end
    	endcase
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
		doutb <= A_DOUT;
end



endmodule




module weights_mem_ihp_qc_v4 #(
    parameter RAM_DEPTH = 4096,
    parameter RAM_WIDTH = 32,
    parameter INIT_FILE = ""
)
(
  input [11:0] addra,   
  input [15:0] dina,
  input ena1,
  input ena2,
  input ena3,
  input ena4,
  
  input [11:0] addrb,         
  input clk,                                                      
  input enb,                            
  input rst,                           
  input regceb,                         
  
  output reg [127:0] doutb                   
);
    
    //wire [31:0] doutb_tmp;
    wire A_MEN;
    wire A_WEN;
    wire A_REN;
    wire [9:0] A_ADDR;
    reg  [63:0] A_BM;
    reg  [63:0] A_DIN;
    
    
    always@(*) begin
    	casex({ena1, ena2, ena3, ena4}) 
    		4'b1000: begin A_BM = 64'hFFFF000000000000; A_DIN = { dina, {48{1'bx}} };             end
    		4'b0100: begin A_BM = 64'h0000FFFF00000000; A_DIN = { {16{1'bx}}, dina, {32{1'bx}} }; end
    		4'b0010: begin A_BM = 64'h00000000FFFF0000; A_DIN = { {32{1'bx}}, dina, {16{1'bx}} }; end
    		4'b0001: begin A_BM = 64'h000000000000FFFF; A_DIN = { {48{1'bx}}, dina };             end
    		default: begin A_BM = 64'h0000000000000000; A_DIN = {64{1'bx}} ;                      end
    	endcase
    end
    
    assign A_ADDR = wen ? addra : addrb;
    
    assign wen    = (ena1 || ena2 || ena3 || ena4 );
    
    assign A_WEN_0  = ~addra[11] && ~addra[10] && wen;
    assign A_WEN_1  = ~addra[11] &&  addra[10] && wen;
    assign A_WEN_2  =  addra[11] && ~addra[10] && wen;
    assign A_WEN_3  =  addra[11] &&  addra[10] && wen;
    
    assign A_REN_0 =  ~addrb[10];
    assign A_REN_1 =   addrb[10];
    
    assign A_MEN_0 =   A_WEN_0 || A_REN_0;
    assign A_MEN_1 =   A_WEN_1 || A_REN_1;
    assign A_MEN_2 =   A_WEN_2 || A_REN_0;
    assign A_MEN_3 =   A_WEN_3 || A_REN_1;
    
    wire [63:0] A_DOUT_0, A_DOUT_1, A_DOUT_2, A_DOUT_3;
    wire [127:0] A_DOUT;
    

    
	RM_IHPSG13_1P_1024x64_c2_bm_bist mem12_0_1024(
	    .A_CLK(clk),
	    .A_MEN(A_MEN_0),		//Memory enable, activates memory for read/write.
	    .A_WEN(A_WEN_0),		//Write enable, triggers write operation to memory.
	    .A_REN(A_REN_0),		//Read enable, triggers read operation from memory.
	    .A_ADDR(A_ADDR),
	    .A_DIN(A_DIN),
	    .A_DLY(1'b0),		//Delay control, possibly for timing adjustments.
	    .A_DOUT(A_DOUT_0),
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

    
	RM_IHPSG13_1P_1024x64_c2_bm_bist mem12_1024_2048(
	    .A_CLK(clk),
	    .A_MEN(A_MEN_1),		//Memory enable, activates memory for read/write.
	    .A_WEN(A_WEN_1),		//Write enable, triggers write operation to memory.
	    .A_REN(A_REN_1),		//Read enable, triggers read operation from memory.
	    .A_ADDR(A_ADDR),
	    .A_DIN(A_DIN),
	    .A_DLY(1'b0),		//Delay control, possibly for timing adjustments.
	    .A_DOUT(A_DOUT_1),
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
	    
	RM_IHPSG13_1P_1024x64_c2_bm_bist mem34_0_1024(
	    .A_CLK(clk),
	    .A_MEN(A_MEN_2),		//Memory enable, activates memory for read/write.
	    .A_WEN(A_WEN_2),		//Write enable, triggers write operation to memory.
	    .A_REN(A_REN_0),		//Read enable, triggers read operation from memory.
	    .A_ADDR(A_ADDR),
	    .A_DIN(A_DIN),
	    .A_DLY(1'b0),		//Delay control, possibly for timing adjustments.
	    .A_DOUT(A_DOUT_2),
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
	    
	RM_IHPSG13_1P_1024x64_c2_bm_bist mem34_1024_2048(
	    .A_CLK(clk),
	    .A_MEN(A_MEN_3),		//Memory enable, activates memory for read/write.
	    .A_WEN(A_WEN_3),		//Write enable, triggers write operation to memory.
	    .A_REN(A_REN_1),		//Read enable, triggers read operation from memory.
	    .A_ADDR(A_ADDR),
	    .A_DIN(A_DIN),
	    .A_DLY(1'b0),		//Delay control, possibly for timing adjustments.
	    .A_DOUT(A_DOUT_3),
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
	
	
	assign A_DOUT = A_REN_0 ? {A_DOUT_0, A_DOUT_2} : {A_DOUT_1, A_DOUT_3};


always@(posedge clk) begin
	if(rst) 
		doutb <= 0;
	else
		doutb <= A_DOUT;
end



endmodule





