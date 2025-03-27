module uart_decoder
  #(parameter BAUD_RATE = 115200)
   (input rx);

   localparam T = 270;

   integer i;
   reg [7:0] ch;

   initial forever begin
      @(negedge rx);
      #(T/2) ch = 0;
      for (i=0;i<8;i=i+1)
	#T ch[i] = rx;
      $write("%c",ch);
      $fflush;
   end
endmodule
