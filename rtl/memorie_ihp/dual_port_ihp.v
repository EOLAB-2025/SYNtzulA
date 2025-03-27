module ihp_dualport_256x48_dualmem #(
  parameter RAM_WIDTH = 4,                  
  parameter RAM_DEPTH = 64,                 
  parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE", 
  parameter INIT_FILE = ""                       
)
(
  input [10:0] addra,  
  input [10:0] addrb,  
  input [31:0] dina,           
  input clk,                           
  input wea,                            
  input ena,                            
  input enb,                            
  input rst,                           
  input regceb,                         
  
  output reg [31:0] doutb                 
);


wire en_w;
assign en_w = ena && wea;

parameter R0_W1 = 0, WAIT_1 = 1, R1_W0 = 2, WAIT_2 = 3, INIT = 4;
reg [2:0] state, state_next;
wire NEXT;

always@(posedge clk) begin
	if(rst)
		state <= INIT;
	else
		state <= state_next;
end

always@(*) begin
	case(state)
		INIT:    state_next = NEXT ? R0_W1 : INIT;
		
		R0_W1:   state_next = NEXT ? WAIT_1 : R0_W1;
		WAIT_1:  state_next = R1_W0;
		R1_W0:   state_next = NEXT ? WAIT_2 : R1_W0;
		WAIT_2:  state_next = R0_W1;
		default: state_next = INIT;
	endcase
end

reg [5:0] control;
reg [9:0] AD_0, AD_1;
wire [31:0] DO_0, DO_1;

assign {en_0, ren0, wren0, en_1, ren1, wren1} = control;

always@(*) begin
	case(state)
	
		INIT:    begin  control = {1'b0, 1'b0, 1'b0, en_w, 1'b0, en_w}; AD_0 = addrb; AD_1 = addra; doutb =  32'b0; end
			
		R0_W1:   begin  control = {enb, enb, 1'b0, en_w, 1'b0, en_w}; AD_0 = addrb; AD_1 = addra; doutb = DO_0; end
		WAIT_1:  begin  control = {enb, enb, 1'b0, en_w, 1'b0, en_w}; AD_0 = addrb; AD_1 = addra; doutb = DO_0; end
		
		R1_W0:   begin  control = {en_w, 1'b0, en_w, enb, enb, 1'b0}; AD_0 = addra; AD_1 = addrb; doutb = DO_1; end
		WAIT_2:  begin  control = {en_w, 1'b0, en_w, enb, enb, 1'b0}; AD_0 = addra; AD_1 = addrb; doutb = DO_1; end
		
		default: begin  control = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}; AD_0 = 10'b0; AD_1 = 10'b0; doutb = 32'b0; end
	endcase
end




RM_IHPSG13_1P_256x48_c2_bm_bist mem0(
    .A_CLK(clk),
    .A_MEN(en_0),
    .A_WEN(wren0),
    .A_REN(ren0),
    .A_ADDR(AD_0),
    .A_DIN(dina),
    .A_DLY(1'b0),
    .A_DOUT(DO_0),
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

RM_IHPSG13_1P_256x48_c2_bm_bist mem1(
    .A_CLK(clk),
    .A_MEN(en_1),
    .A_WEN(wren1),
    .A_REN(ren1),
    .A_ADDR(AD_1),
    .A_DIN(dina),
    .A_DLY(1'b0),
    .A_DOUT(DO_1),
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

parameter IDLE = 0, WAIT = 1, FINISH = 2;
reg [1:0] state2, state2_next;

always@(posedge clk) begin
	if(rst) 
		state2 <= IDLE;
	else 
		state2 <= state2_next;
end 

always@(state, addra, addrb) begin
	case(state2)
		IDLE: state2_next = ((addra == 0) && (addrb == 0)) ? IDLE : WAIT;
		WAIT: state2_next = ((addra == 0) && (addrb == 0)) ? FINISH : WAIT;
		FINISH: state2_next = IDLE;
		default state2_next = IDLE;
	endcase
end

assign NEXT = (state2 == FINISH) ? 1 : 0;


endmodule

/*
  _______ ____  
 |__   __|  _ \ 
    | |  | |_) |
    | |  |  _ < 
    | |  | |_) |
    |_|  |____/ 
                
*/                



module ihp_dualport_256x48_dualmem_tb #(
  parameter RAM_WIDTH = 4,                  
  parameter RAM_DEPTH = 64,                 
  parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE", 
  parameter INIT_FILE = ""                       
)
(
  input [10:0] addra,  
  input [10:0] addrb,  
  input [31:0] dina,           
  input clk,                           
  input wea,                            
  input ena,                            
  input enb,                            
  input rst,                           
  input regceb,                         
  
  output reg [31:0] doutb                 
);



assign en_w = ena && wea;

parameter R0_W1 = 0, WAIT_1 = 1, R1_W0 = 2, WAIT_2 = 3;
reg [1:0] state, state_next;
wire NEXT;

always@(posedge clk) begin
	if(rst)
		state <= R0_W1;
	else
		state <= state_next;
end

always@(*) begin
	case(state)
		R0_W1:   state_next = NEXT ? WAIT_1 : R0_W1;
		WAIT_1:  state_next = R1_W0;
		R1_W0:   state_next = NEXT ? WAIT_2 : R1_W0;
		WAIT_2:  state_next = R0_W1;
	endcase
end

reg [5:0] control;
reg [9:0] AD_0, AD_1;
wire [31:0] DO_0, DO_1;


assign {en_0, ren0, wren0, en_1, ren1, wren1} = control;

always@(*) begin
	case(state)

		R0_W1:   begin  control = {enb, enb, 1'b0, en_w, 1'b0, en_w}; AD_0 = addrb; AD_1 = addra; doutb = DO_0; end
		WAIT_1:  begin  control = {enb, enb, 1'b0, en_w, 1'b0, en_w}; AD_0 = addrb; AD_1 = addra; doutb = DO_0; end
		
		R1_W0:   begin  control = {en_w, 1'b0, en_w, enb, enb, 1'b0}; AD_0 = addra; AD_1 = addrb; doutb = DO_1; end
		WAIT_2:  begin  control = {en_w, 1'b0, en_w, enb, enb, 1'b0}; AD_0 = addra; AD_1 = addrb; doutb = DO_1; end
		
	endcase
end




RM_IHPSG13_1P_256x48_c2_bm_bist #(.INIT_FILE(INIT_FILE)) mem0(
    .A_CLK(clk),
    .A_MEN(en_0),
    .A_WEN(wren0),
    .A_REN(ren0),
    .A_ADDR(AD_0),
    .A_DIN(dina),
    .A_DLY(1'b0),
    .A_DOUT(DO_0),
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

RM_IHPSG13_1P_256x48_c2_bm_bist mem1(
    .A_CLK(clk),
    .A_MEN(en_1),
    .A_WEN(wren1),
    .A_REN(ren1),
    .A_ADDR(AD_1),
    .A_DIN(dina),
    .A_DLY(1'b0),
    .A_DOUT(DO_1),
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

parameter IDLE = 0, WAIT = 1, FINISH = 2;
reg [1:0] state2, state2_next;

always@(posedge clk) begin
	if(rst) 
		state2 <= IDLE;
	else 
		state2 <= state2_next;
end 

always@(state, addra, addrb) begin
	case(state2)
		IDLE: state2_next = ((addra == 0) && (addrb == 0)) ? IDLE : WAIT;
		WAIT: state2_next = ((addra == 0) && (addrb == 0)) ? FINISH : WAIT;
		FINISH: state2_next = IDLE;
		default state2_next = IDLE;
	endcase
end

assign NEXT = (state2 == FINISH) ? 1 : 0;



endmodule





