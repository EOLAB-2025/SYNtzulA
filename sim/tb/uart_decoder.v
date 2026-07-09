/*module uart_decoder
  #(parameter BAUD_RATE = 115200)
   (
   	input rx,
    	output ready_next
    );

   localparam T = 1000000000/BAUD_RATE;

   integer i;
   reg [7:0] ch;

   initial forever begin
      @(negedge rx);
      #(T/2) ch = 0;
      for (i=0;i<8;i=i+1)
	#T ch[i] = rx;
      $write("%x",ch);
      $fflush;
   end
endmodule
*/

module uart_decoder
  #(parameter BAUD_RATE = 115200)
   (
    input        clk,       // aggiunto clock
    input        rx,
    output       valid // segnale di output: impulso di 1 ciclo quando ch == 'A'
    );

   localparam T = 1000000000 / BAUD_RATE;

   integer i;
   reg [7:0] ch;
   reg [7:0] ch_reg; // registrato per confronto sincrono

   // UART ricezione: sempre valida così com'è
   initial forever begin
      @(negedge rx);
      #(T/2) ch = 0;
      for (i = 0; i < 8; i = i + 1)
        #T ch[i] = rx;
      $write("%x", ch);
      $fflush;
      ch_reg = ch; // salva per logica sincrona
   end
   
   parameter IDLE = 0, READY = 1, WAIT = 2;
   reg [1:0] state, state_nxt;
   
   initial begin
   	 state = IDLE; 
   	 ready_next = 0;
   end
   
   
   always@(posedge clk) begin
   	state <= state_nxt;  
   end
   
   always@(*) begin
   	case(state) 
   		IDLE:  state_nxt  = ready_next ? READY : IDLE;
   		READY: state_nxt  = WAIT;
   		WAIT:  state_nxt  = ready_next ? WAIT : IDLE;  
   	endcase
   end
   
   assign valid = (state == READY) ? 1:0;
   reg ready_next;

   // Logica sincrona per generare impulso
   always @(posedge clk) begin
     if (i == 8)
       ready_next <= 1;
     else
       ready_next <= 0;
   end

endmodule
















