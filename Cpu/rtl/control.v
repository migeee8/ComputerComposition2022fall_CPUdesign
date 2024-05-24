/*组合逻辑控制单元，根据时钟生成为控制信号和内部信号*/
/*
输入：
       din：指令，8位，来自IR；
       clk：时钟信号，1位，上升沿有效；
       rst：复位信号，1位，与cpustate共同组成reset信号；
       cpustate：当前CPU的状态（IN，CHECK，RUN），2位；
       z：零标志，1位，零标志寄存器的输出，如果指令中涉及到z，可加上，否则可去掉；
输出：
      clr：清零控制信号
     自行设计的各个控制信号
*/
//省略号中是自行设计的控制信号，需要自行补充，没用到z的话去掉z
module control(din,clk,rst,z,cpustate,pcbus,r0bus,r1bus,drlbus,drhbus,trbus,membus,busmem,r0load,r1load,zload,xload,arload,drload,irload,trload,pcload,alus,read,write,pcinc,arinc,clr);
input [7:0]din;
input clk;
input rst,z;
input [1:0] cpustate;

//输出端口说明
output pcbus,r0bus,r1bus,drlbus,drhbus,trbus,membus,busmem;
output arload,r0load,r1load,zload,xload,drload,irload,trload,pcload,pcinc,arinc,read,write;
output [3:0]alus;//alu运算控制信号 4位
output clr;//清零控制信号

//parameter's define
wire pcbus,r0bus,r1bus,drlbus,drhbus,trbus,membus,busmem,arload,r0load,r1load,zload,xload,drload,irload,trload,pcload,read,write,pcinc,arinc;
reg [3:0]alus;

wire reset;

//在下方加上自行定义的状态
wire fetch1,fetch2,fetch3,nop1,add1,add2,sub1,sub2,and1,and2,or1,or2,xor1,xor2,inc1,inc2,not1,not2,clr1,shr1,shr2,mvr1,lad1,lad2,lad3,lad4,lad5,sto1,sto2,sto3,sto4,jmp1,jmp2,jmp3,jpz1,jpz2,jpz3,jpnz1,jpnz2,jpnz3;

//加上自行设计的指令，这里是译码器的输出，所以nop指令经译码器输出后为inop。
//类似地，add指令指令经译码器输出后为iadd；inac指令经译码器输出后为iinac，......
reg inop,iadd,isub,iand,ior,ixor,iinc,inot,iclr,ishr,imvr,ilad,isto,ijmp,ijpz,ijpnz;

//时钟节拍，8个为一个指令周期，t0-t2分别对应fetch1-fetch3，t3-t7分别对应各指令的执行周期，当然不是所有指令都需要5个节拍的。例如add指令只需要2个节拍：t3和t4
reg t0,t1,t2,t3,t4,t5,t6,t7; //时钟节拍，8个为一个cpu周期

// 内部信号：clr清零，inc自增
wire clr;
wire inc;
assign reset = rst&(cpustate == 2'b11);
// assign signals for the cunter

//clr信号是每条指令执行完毕后必做的清零，下面clr赋值语句要修改，需要“或”各指令的最后一个周期
assign clr=nop1||add2||sub2||and2||or2||xor2||inc2||not2||clr1||shr2||mvr1||lad5||sto4||jmp3||jpz3||jpnz3;

assign inc=~clr;

//generate the control signal using state information
//取公过程-取指
assign fetch1=t0;
assign fetch2=t1;
assign fetch3=t2;

//什么都不做的译码
assign nop1=inop&&t3;//inop表示nop指令，nop1是nop指令的执行周期的第一个状态也是最后一个状态，因为只需要1个节拍t3完成

//以下写出各条指令状态的表达式
assign add1=iadd&&t3;
assign add2=iadd&&t4;
assign sub1=isub&&t3;
assign sub2=isub&&t4;
assign and1=iand&&t3;
assign and2=iand&&t4;
assign or1=ior&&t3;
assign or2=ior&&t4;
assign xor1=ixor&&t3;
assign xor2=ixor&&t4;
assign inc1=iinc&&t3;
assign inc2=iinc&&t4;
assign not1=inot&&t3;
assign not2=inot&&t4;
assign clr1=iclr&&t3;
assign mvr1=imvr&&t3;
assign shr1=ishr&&t3;
assign shr2=ishr&&t4;
assign lad1=ilad&&t3;
assign lad2=ilad&&t4;
assign lad3=ilad&&t5;
assign lad4=ilad&&t6;
assign lad5=ilad&&t7;
assign sto1=isto&&t3;
assign sto2=isto&&t4;
assign sto3=isto&&t5;
assign sto4=isto&&t6;
assign jmp1=ijmp&&t3;
assign jmp2=ijmp&&t4;
assign jmp3=ijmp&&t5;
assign jpz1=ijpz&&t3;
assign jpz2=ijpz&&t4;
assign jpz3=ijpz&&t5;
assign jpnz1=ijpnz&&t3;
assign jpnz2=ijpnz&&t4;
assign jpnz3=ijpnz&&t5;


//以下给出了pcbus的逻辑表达式，写出其他控制信号的逻辑表达式
assign pcbus=fetch1||fetch3;
assign r0bus=add1||sub1||and1||or1||xor1||inc1||not1||shr1||mvr1||sto4;
assign r1bus=add2||sub2||and2||or2||xor2;
assign drlbus=lad5;
assign drhbus=lad3||sto3||jmp3||(jpz3&&z)||(jpnz3&&(!z));
assign trbus=jmp3||(jpz3&&z)||(jpnz3&&(!z))||lad3||sto3;
assign membus=fetch2||jmp1||jmp2||(jpz1&&z)||(jpz2&&z)||(jpnz1&&(!z))||(jpnz2&&(!z))||lad1||lad2||lad4||sto1||sto2;
assign busmem=sto4;
assign r0load=add2||sub2||and2||or2||xor2||inc2||not2||clr1||shr2||lad5;
assign r1load=mvr1;
assign zload=add2||sub2||and2||or2||xor2||inc2||not2||shr2||clr1;
assign xload=add1||sub1||and1||or1||xor1||inc1||not1||shr1;
assign arload=fetch1||fetch3||lad3||sto3;
assign drload=fetch2||lad1||lad2||lad4||sto1||sto2||jmp1||jmp2||(jpz1&&z)||(jpz2&&z)||(jpnz1&&(!z))||(jpnz2&&(!z));
assign irload=fetch3;
assign trload=lad2||sto2||jmp2||(jpz2&&z)||(jpnz2&&(!z));
assign pcload=jmp3||(jpz3&&z)||(jpnz3&&(!z));
assign read=fetch2||lad1||lad2||lad4||sto1||sto2||jmp1||jmp2||(jpz1&&z)||(jpz2&&z)||(jpnz1&&(!z))||(jpnz2&&(!z));
assign write=sto4;
assign pcinc=fetch2||lad1||lad2||sto1||sto2||(jpz1&&(!z))||(jpz2&&(!z))||(jpnz1&&z)||(jpnz2&&z);
assign arinc=lad1||sto1||jmp1||(jpz1&&z)||(jpnz1&&(!z));


//the finite state

always@(posedge clk or negedge reset)
begin
	if(!reset)
		begin//各指令清零，以下已为nop指令清零，请补充其他指令，为其他指令清零
			inop<=0;
			iadd<=0;
			isub<=0;
			iand<=0;
			ior<=0;
			ixor<=0;
			iinc<=0;
			inot<=0;
			ishr<=0;
			iclr<=0;
			imvr<=0;
			ilad<=0;
			isto<=0;
			ijmp<=0;	
		   ijpz<=0;	
			ijpnz<=0;
			alus<= 4'bx;
		end
	else 
	begin
		//alus初始化为x，加上将alus初始化为x的语句，后续根据不同指令为alus赋值
		alus<= 4'bx;
		if(din[3:0]==0000)//译码处理过程
		begin
			case(din[7:4])
			4'd0: begin//指令高4位为0，应该是nop指令，因此这里inop的值是1，而其他指令应该清零，请补充为其他指令清零的语句
				inop<=1;
				iadd<=0;
				isub<=0;
				iand<=0;
				ior<=0;
				ixor<=0;
				iinc<=0;
				inot<=0;
				ishr<=0;
				iclr<=0;
				imvr<=0;
				ilad<=0;
				isto<=0;
				ijmp<=0;	
				ijpz<=0;	
				ijpnz<=0;				
				end
			4'd1:  begin
				//指令高4位为0001，应该是add指令，因此iadd指令为1，其他指令都应该是0。
				//该指令需要做加法运算，详见《示例机的设计Quartus II和使用说明文档》中“ALU的设计”，因此这里要对alus赋值
				//后续各分支类似，只有一条指令为1，其他指令为0，以下分支都给出nop指令的赋值，需要补充其他指令，注意涉及到运算的都要对alus赋值
				inop<=0;
				iadd<=1;
				isub<=0;
				iand<=0;
				ior<=0;
				ixor<=0;
				iinc<=0;
				inot<=0;
				ishr<=0;
				iclr<=0;
				imvr<=0;
				ilad<=0;
				isto<=0;
				ijmp<=0;	
				ijpz<=0;	
				ijpnz<=0;				
				alus<=4'b0001;
				end
			4'd2:  begin
			//SUB	00100000
				inop<=0;
				iadd<=0;
				isub<=1;
				iand<=0;
				ior<=0;
				ixor<=0;
				iinc<=0;
				inot<=0;
				ishr<=0;
				iclr<=0;
				imvr<=0;
				ilad<=0;
				isto<=0;
				ijmp<=0;	
				ijpz<=0;	
				ijpnz<=0;
				alus<=4'b0010;
				end
			4'd3:  begin
			//AND	00110000
				inop<=0;
				iadd<=0;
				isub<=0;
				iand<=1;
				ior<=0;
				ixor<=0;
				iinc<=0;
				inot<=0;
				ishr<=0;
				iclr<=0;
				imvr<=0;
				ilad<=0;
				isto<=0;
				ijmp<=0;	
				ijpz<=0;	
				ijpnz<=0;
				alus<=4'b0011;
				end
			4'd4:  begin
			//OR	01000000
				inop<=0;
				iadd<=0;
				isub<=0;
				iand<=0;
				ior<=1;
				ixor<=0;
				iinc<=0;
				inot<=0;
				ishr<=0;
				iclr<=0;
				imvr<=0;
				ilad<=0;
				isto<=0;
				ijmp<=0;	
				ijpz<=0;	
				ijpnz<=0;
				alus<=4'b0100;
				end
			4'd5:  begin
			//XOR	01010000
				inop<=0;
				iadd<=0;
				isub<=0;
				iand<=0;
				ior<=0;
				ixor<=1;
				iinc<=0;
				inot<=0;
				ishr<=0;
				iclr<=0;
				imvr<=0;
				ilad<=0;
				isto<=0;
				ijmp<=0;	
				ijpz<=0;	
				ijpnz<=0;
				alus<=4'b0101;
				end
			4'd6:	begin
			//INC	01100000
				inop<=0;
				iadd<=0;
				isub<=0;
				iand<=0;
				ior<=0;
				ixor<=0;
				iinc<=1;
				inot<=0;
				ishr<=0;
				iclr<=0;
				imvr<=0;
				ilad<=0;
				isto<=0;
				ijmp<=0;	
				ijpz<=0;	
				ijpnz<=0;
				alus<=4'b0110;
				end
			4'd7:	begin
			//NOT	01110000
				inop<=0;
				iadd<=0;
				isub<=0;
				iand<=0;
				ior<=0;
				ixor<=0;
				iinc<=0;
				inot<=1;
				ishr<=0;
				iclr<=0;
				imvr<=0;
				ilad<=0;
				isto<=0;
				ijmp<=0;	
				ijpz<=0;	
				ijpnz<=0;
				alus<=4'b0111;
				end
			4'd8:	begin
			//CLR	10000000
				inop<=0;
				iadd<=0;
				isub<=0;
				iand<=0;
				ior<=0;
				ixor<=0;
				iinc<=0;
				inot<=0;
				ishr<=0;
				iclr<=1;
				imvr<=0;
				ilad<=0;
				isto<=0;
				ijmp<=0;	
				ijpz<=0;	
				ijpnz<=0;
				alus<=4'b0000;
				end
			4'd9:	begin
			//SHR	10010000
				inop<=0;
				iadd<=0;
				isub<=0;
				iand<=0;
				ior<=0;
				ixor<=0;
				iinc<=0;
				inot<=0;
				ishr<=1;
				iclr<=0;
				imvr<=0;
				ilad<=0;
				isto<=0;
				ijmp<=0;	
				ijpz<=0;	
				ijpnz<=0;
				alus<=4'b1001;
				end
			4'd10:	begin
			//MVR	10100000
				inop<=0;
				iadd<=0;
				isub<=0;
				iand<=0;
				ior<=0;
				ixor<=0;
				iinc<=0;
				inot<=0;
				ishr<=0;
				iclr<=0;
				imvr<=1;
				ilad<=0;
				isto<=0;
				ijmp<=0;	
				ijpz<=0;	
				ijpnz<=0;
				end
			4'd11:	begin
			//JMP	10110000  A
				inop<=0;
				iadd<=0;
				isub<=0;
				iand<=0;
				ior<=0;
				ixor<=0;
				iinc<=0;
				inot<=0;
				ishr<=0;
				iclr<=0;
				imvr<=0;
				ilad<=0;
				isto<=0;
				ijmp<=1;	
				ijpz<=0;	
				ijpnz<=0;
				end
			4'd12:	begin
			//JPZ		11000000  A
				inop<=0;
				iadd<=0;
				isub<=0;
				iand<=0;
				ior<=0;
				ixor<=0;
				iinc<=0;
				inot<=0;
				ishr<=0;
				iclr<=0;
				imvr<=0;
				ilad<=0;
				isto<=0;
				ijmp<=0;	
				ijpz<=1;	
				ijpnz<=0;
				end
			4'd13:	begin
			//JPNZ	11010000  A
				inop<=0;
				iadd<=0;
				isub<=0;
				iand<=0;
				ior<=0;
				ixor<=0;
				iinc<=0;
				inot<=0;
				ishr<=0;
				iclr<=0;
				imvr<=0;
				ilad<=0;
				isto<=0;
				ijmp<=0;	
				ijpz<=0;	
				ijpnz<=1;
				end
			4'd14:	begin
			//LAD	11100000  A
				inop<=0;
				iadd<=0;
				isub<=0;
				iand<=0;
				ior<=0;
				ixor<=0;
				iinc<=0;
				inot<=0;
				ishr<=0;
				iclr<=0;
				imvr<=0;
				ilad<=1;
				isto<=0;
				ijmp<=0;	
				ijpz<=0;	
				ijpnz<=0;
				alus<=4'b1010;
				end
			4'd15:	begin
			//STO	11110000  A
				inop<=0;
				iadd<=0;
				isub<=0;
				iand<=0;
				ior<=0;
				ixor<=0;
				iinc<=0;
				inot<=0;
				ishr<=0;
				iclr<=0;
				imvr<=0;
				ilad<=0;
				isto<=1;
				ijmp<=0;	
				ijpz<=0;	
				ijpnz<=0;
				end
				//如果还有分支，可以继续写，如果没有分支了，写上defuault语句	
				default:begin
				inop<=0;
				iadd<=0;
				isub<=0;
				iand<=0;
				ior<=0;
				ixor<=0;
				iinc<=0;
				inot<=0;
				ishr<=0;
				iclr<=0;
				imvr<=0;
				ilad<=0;
				isto<=0;
				ijmp<=0;	
				ijpz<=0;	
				ijpnz<=0;
				end
			endcase
		end
	end
end

/*——————8个节拍t0-t7————*/
always @(posedge clk or negedge reset)
begin
	if(!reset) //reset清零
	begin
		t0<=1;
		t1<=0;
		t2<=0;
		t3<=0;
		t4<=0;
		t5<=0;
		t6<=0;
		t7<=0;
	end
	else
	begin
		if(inc) //运行
		begin
			t7<=t6;
			t6<=t5;
			t5<=t4;
			t4<=t3;
			t3<=t2;
			t2<=t1;
			t1<=t0;
			t0<=0;
	end
		else if(clr) //清零
		begin
			t0<=1;
			t1<=0;
			t2<=0;
			t3<=0;
			t4<=0;
			t5<=0;
			t6<=0;
			t7<=0;
		end
	end
end
/*—————结束—————*/
endmodule
	
		