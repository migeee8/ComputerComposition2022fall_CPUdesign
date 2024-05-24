/*CPU*/

//省略号中是自行设计的控制信号，需要自行补充
module cpu(data_in,clk_quick,clk_slow,clk_delay,rst,SW_choose,A1,cpustate,addr,pcdbus,data_out,r0dbus,r1dbus,read,write,clr);
input[7:0] data_in;//从存储器输入
input clk_quick,clk_slow,clk_delay;
input rst;
input SW_choose,A1;
input [1:0] cpustate;

output [15:0] addr; //ar与存储器的连接wire
output [15:0] pcdbus;//pc输出信号
output [7:0] data_out;//输出到存储器
output [7:0] r0dbus;//r0寄存器的输出
output [7:0] r1dbus;//r1寄存器的输出
output clr;//控制清零信号
output read,write;//读写信号的输出

wire clk_choose,clk_run;
wire[15:0] dbus,pcdbus,addr;
wire clr;
wire read,write;

//定义一些需要的内部信号
wire[3:0] alus;
wire[7:0]drdbus,trdbus,r1dbus,r0dbus,irdbus,xdbus,zdbus,aludbus;
wire pcbus,r0bus,r1bus,drlbus,drhbus,trbus,membus,busmem,arload,r0load,r1load,zload,xload,drload,irload,trload,pcload,pcinc,arinc;

//qtsj(clk_quick,clk_slow,clk_delay,clr,rst,SW_choose,A1,cpustate,clk_run,clk_choose);
qtsj qtdl(.clk_quick(clk_quick),.clk_slow(clk_slow),.clk_delay(clk_delay),.clr(clr),.rst(rst),.SW_choose(SW_choose),.A1(A1),.cpustate(cpustate),.clk_run(clk_run),.clk_choose(clk_choose));
//ar(din, clk, rst,arload, arinc, dout);
ar mar(.din(dbus),.clk(clk_choose),.rst(rst),.arload(arload),.arinc(arinc),.dout(addr));
//pc(din, clk, rst,pcload, pcinc, dout);
pc mpc(.din(dbus),.clk(clk_choose),.rst(rst),.pcload(pcload),.pcinc(pcinc),.dout(pcdbus));
//dr(din, clk,rst, drload, dout);补充dr实例化语句
dr mdr(.din(dbus[7:0]),.clk(clk_choose),.rst(rst),.drload(drload),.dout(drdbus));

//tr(din, clk,rst, trload, dout);补充tr实例化语句，如果需要tr的话
tr mtr(.din(drdbus),.clk(clk_choose),.rst(rst),.trload(trload),.dout(trdbus));

//ir(din,clk,rst,irload,dout);补充ir实例化语句
ir mir(.din(drdbus),.clk(clk_choose),.rst(rst),.irload(irload),.dout(irdbus));

//r0(din, clk, rst,r0load, dout);补充r0实例化语句
r0 mr0(.din(aludbus),.clk(clk_choose),.rst(rst),.r0load(r0load),.dout(r0dbus));

//r1(din, clk, rst,r1load, dout);补充r1实例化语句
r1 mr1(.din(dbus[7:0]),.clk(clk_choose),.rst(rst),.r1load(r1load),.dout(r1dbus));

// x(din, clk, rst,xload, dout);补充x实例化语句
x mx(.din(dbus[7:0]),.clk(clk_choose),.rst(rst),.xload(xload),.dout(xdbus));

//alu(alus,x, bus, dout);补充alu实例化语句
alu malu(.alus(alus),.x(xdbus),.bus(dbus[7:0]),.dout(aludbus));

//z(din,clk,rst, zload,dout);补充z实例化语句，如果需要的话
z mz(.din(aludbus),.clk(clk_choose),.rst(rst),.zload(zload),.dout(zdbus));

//control(din,clk,rst,z,cpustate,read,...,clr);补充control实例化语句
control mcontrol(.din(irdbus),.clk(clk_choose),.rst(rst),.z(zdbus),.cpustate(cpustate),.pcbus(pcbus),.r0bus(r0bus),.r1bus(r1bus),.drlbus(drlbus),.drhbus(drhbus),.trbus(trbus),.membus(membus),.busmem(busmem),.r0load(r0load),.r1load(r1load),.zload(zload),.xload(xload),.arload(arload),.drload(drload),.irload(irload),.trload(trload),.pcload(pcload),.alus(alus),.read(read),.write(write),.pcinc(pcinc),.arinc(arinc),.clr(clr));

//allocate dbus
assign dbus[15:0]=(pcbus)?pcdbus[15:0]:16'bzzzzzzzzzzzzzzzz;
assign dbus[15:8]=(drhbus)?drdbus[7:0]:8'bzzzzzzzz;
assign dbus[7:0]=(drlbus)?drdbus[7:0]:8'bzzzzzzzz;
//如果不需要tr的话，可以注释掉以下语句
assign dbus[7:0]=(trbus)?trdbus[7:0]:8'bzzzzzzzz;

assign dbus[7:0]=(r1bus)?r1dbus[7:0]:8'bzzzzzzzz;
assign dbus[7:0]=(r0bus)?r0dbus[7:0]:8'bzzzzzzzz;


assign dbus[7:0]=(membus)?data_in[7:0]:8'bzzzzzzzz;
assign data_out=(busmem)?dbus[7:0]:8'bzzzzzzzz;



endmodule
