module fsm_on_off(

	input clk, rst, 
	input on, off,
	output gated

);

	parameter ON = 1, OFF = 0;
	
	reg state, state_nxt;
	
	always@(posedge clk) begin
		if(rst)
			state <= ON;
		else 
			state <= state_nxt;
	end
	
	always@(*) begin
		case(state)
			ON:  state_nxt = off ? OFF: ON;
			OFF: state_nxt = on  ? ON: OFF;
		endcase
	end
	
	assign gated = state;
	

endmodule
