/*数据寄存器，存放双指令中低8位指向地址的存放值*/
module dr(din, clk,rst, drload, dout);
input clk,rst,drload;
input [7:0] din;
output reg[7:0] dout;
always@(posedge clk or negedge rst)
begin
	if(rst==0)
		dout <= 0;
	else if(drload)
		dout <= din;
end
endmodule