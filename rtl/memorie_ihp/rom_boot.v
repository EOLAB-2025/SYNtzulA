module rom_boot (
    input         A_CLK,
    input         A_REN,
    input  [7:0]  A_ADDR,
    output reg [31:0] A_DOUT
);

    always @(posedge A_CLK) begin
        if (A_REN) begin
            case (A_ADDR)
                8'd0:  A_DOUT <= 32'h40200737;
                8'd1:  A_DOUT <= 32'h00100793;
                8'd2:  A_DOUT <= 32'h00F72023;
                8'd3:  A_DOUT <= 32'h40210737;
                8'd4:  A_DOUT <= 32'h00F72023;
                8'd5:  A_DOUT <= 32'h40220737;
                8'd6:  A_DOUT <= 32'h00072783;
                8'd7:  A_DOUT <= 32'hFE078EE3;
                8'd8:  A_DOUT <= 32'h41000737;
                8'd9:  A_DOUT <= 32'h00072783;
                8'd10: A_DOUT <= 32'hFE078EE3;
                8'd11: A_DOUT <= 32'h00100793;
                8'd12: A_DOUT <= 32'h41010737;
                8'd13: A_DOUT <= 32'h40200637;
                8'd14: A_DOUT <= 32'h00072703;
                8'd15: A_DOUT <= 32'h402106B7;
                8'd16: A_DOUT <= 32'h00F62023;
                8'd17: A_DOUT <= 32'h00F6A023;
                8'd18: A_DOUT <= 32'h402206B7;
                8'd19: A_DOUT <= 32'h0006A783;
                8'd20: A_DOUT <= 32'hFE078EE3;
                8'd21: A_DOUT <= 32'h410006B7;
                8'd22: A_DOUT <= 32'h0006A783;
                8'd23: A_DOUT <= 32'hFE078EE3;
                8'd24: A_DOUT <= 32'h41010537;
                8'd25: A_DOUT <= 32'h00052683;
                8'd26: A_DOUT <= 32'h00871793;
                8'd27: A_DOUT <= 32'h00D7E7B3;
                8'd28: A_DOUT <= 32'h0A078E63;
                8'd29: A_DOUT <= 32'h11000737;
                8'd30: A_DOUT <= 32'h00E787B3;
                8'd31: A_DOUT <= 32'h00279F13;
                8'd32: A_DOUT <= 32'h44000337;
                8'd33: A_DOUT <= 32'h402008B7;
                8'd34: A_DOUT <= 32'h00100593;
                8'd35: A_DOUT <= 32'h40210837;
                8'd36: A_DOUT <= 32'h40220737;
                8'd37: A_DOUT <= 32'h410007B7;
                8'd38: A_DOUT <= 32'h00B8A023;
                8'd39: A_DOUT <= 32'h00B82023;
                8'd40: A_DOUT <= 32'h00072683;
                8'd41: A_DOUT <= 32'hFE068EE3;
                8'd42: A_DOUT <= 32'h0007A683;
                8'd43: A_DOUT <= 32'hFE068EE3;
                8'd44: A_DOUT <= 32'h00052603;
                8'd45: A_DOUT <= 32'h00B8A023;
                8'd46: A_DOUT <= 32'h00B82023;
                8'd47: A_DOUT <= 32'h00072683;
                8'd48: A_DOUT <= 32'hFE068EE3;
                8'd49: A_DOUT <= 32'h0007A683;
                8'd50: A_DOUT <= 32'hFE068EE3;
                8'd51: A_DOUT <= 32'h00052E83;
                8'd52: A_DOUT <= 32'h00B8A023;
                8'd53: A_DOUT <= 32'h00B82023;
                8'd54: A_DOUT <= 32'h00072683;
                8'd55: A_DOUT <= 32'hFE068EE3;
                8'd56: A_DOUT <= 32'h0007A683;
                8'd57: A_DOUT <= 32'hFE068EE3;
                8'd58: A_DOUT <= 32'h00052E03;
                8'd59: A_DOUT <= 32'h00B8A023;
                8'd60: A_DOUT <= 32'h00B82023;
                8'd61: A_DOUT <= 32'h00072683;
                8'd62: A_DOUT <= 32'hFE068EE3;
                8'd63: A_DOUT <= 32'h0007A683;
                8'd64: A_DOUT <= 32'hFE068EE3;
                8'd65: A_DOUT <= 32'h00052F83;
                8'd66: A_DOUT <= 32'h01861693;
                8'd67: A_DOUT <= 32'h010E9613;
                8'd68: A_DOUT <= 32'h00C6E6B3;
                8'd69: A_DOUT <= 32'h01F6E6B3;
                8'd70: A_DOUT <= 32'h008E1613;
                8'd71: A_DOUT <= 32'h00C6E6B3;
                8'd72: A_DOUT <= 32'h00D32023;
                8'd73: A_DOUT <= 32'h00430313;
                8'd74: A_DOUT <= 32'hF66F18E3;
                8'd75: A_DOUT <= 32'h420007B7;
                8'd76: A_DOUT <= 32'h00100713;
                8'd77: A_DOUT <= 32'h00E7A023;
                8'd78: A_DOUT <= 32'h00000513;
                8'd79: A_DOUT <= 32'h00008067;
                default: A_DOUT <= 32'h00000013; // NOP o reset-safe
            endcase
        end
    end

endmodule

