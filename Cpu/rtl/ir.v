/*指令寄存器，存储要执行的指令*/

//注意：该寄存器是时钟的下降沿有效
module ir(din,clk,rst,irload,dout);
input clk,rst,irload;
input [7:0] din;
output reg[7:0] dout;
always@(negedge clk or negedge rst)
begin
	if(rst==0)
		dout <= 0;
	else if(irload)
		dout <= din;
end
endmodule