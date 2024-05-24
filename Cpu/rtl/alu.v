/*算术逻辑单元*/
module alu(alus,x, bus, dout);
input [3:0]alus;
input [7:0]x;
input [7:0]bus;
output [7:0]dout;
reg [7:0]dout;
always @(alus or x or bus)
begin
case(alus)
			4'b0000:	dout=8'b00000000;
			4'b0001:	dout=x + bus;
			4'b0010:	dout=x - bus;
			4'b0011:	dout=x & bus;
			4'b0100:	dout=x | bus;
			4'b0101:	dout=x ^ bus;
			4'b0110:	dout=x + 8'b00000001;
			4'b0111:	dout= ~ x;	
			4'b1000: dout=x - 8'b00000001;
			4'b1001: dout=(x >> 1);
			4'b1010: dout=bus + 8'b00000000;
			default:dout = 8'bx;
endcase
end
endmodule
