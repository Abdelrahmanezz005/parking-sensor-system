module sevenSegments (bcd,dec);
input [3:0]bcd;
output reg [6:0] dec;
always@(bcd)
		begin 
			case(bcd)
				4'b0000 : dec = ~7'b1111110; // 0
				4'b0001 : dec = ~7'b0110000; // 1
				4'b0010 : dec = ~7'b1101101; // 2
				4'b0011 : dec = ~7'b1111001; // 3
				4'b0100 : dec = ~7'b0110011; // 4
				4'b0101 : dec = ~7'b1011011; // 5
				4'b0110 : dec = ~7'b1011111; // 6
				4'b0111 : dec = ~7'b1110000; // 7
			default : dec = ~7'b1111110; //0 default  
			endcase 
		end
endmodule
/*
*  -- a --
 * |       |
 * f       b
 * |       |
 *  -- g --
 * |       |
 * e       c
 * |       |
 *  -- d --
*/