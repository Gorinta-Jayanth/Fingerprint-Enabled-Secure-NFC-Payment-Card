module MODIFIED_DUALCLCG_USING_CS3A(clk,start,x0,y0,p0,q0,Zi);

input clk,start;
input [3:0]x0,y0,p0,q0;//initial seeds

output  Zi ;//random bit

wire [3:0] lcg_out1,lcg_out2,lcg_out3,lcg_out4;///internal lcg outputs
wire Cout1,Cout2 ;//comparator outputs

parameter a1 = 4'd5,a2 = 4'd9,a3 = 4'd5,a4 = 4'd9;//a=2^r +1
parameter b1 = 4'd7,b2 = 4'd11,b3 = 4'd5,b4 = 4'd3;//b= prime values

LCG lcg1(.x0(x0),.start(start),.clk(clk),.a(a1),.b1(b1),.xip1(lcg_out1));//1
LCG lcg2(.x0(y0),.start(start),.clk(clk),.a(a2),.b1(b2),.xip1(lcg_out2));//1
LCG lcg3(.x0(p0),.start(start),.clk(clk),.a(a3),.b1(b3),.xip1(lcg_out3));//2
LCG lcg4(.x0(q0),.start(start),.clk(clk),.a(a4),.b1(b4),.xip1(lcg_out4));//2


//comparator1

comparator32bit comp1(.A(lcg_out1),.B(lcg_out2),.Y(Cout1));

//comparator2
comparator32bit comp2(.A(lcg_out3),.B(lcg_out4),.Y(Cout2));


mux mux1( .A(Cout1) , .B(Cout2) , .Sel(lcg_out2[0]) ,.Y(Zi) ) ;


endmodule

//MUX
module mux ( A , B , Sel ,Y ) ;

input  A , B , Sel   ;
output reg Y ;

always @ *

begin
	if(Sel) Y = A ;
	else Y = B ;
end

endmodule 
//LCG

module LCG(x0,start,clk,a,b1,xip1);
input [3:0]x0;
input [3:0]a,b1;
input start,clk;
output reg [3:0]xip1;
wire [3:0]xi,lsr,add3 ;
wire [1:0]r ;
//parameter b1 = 8'd1;
assign xi = start ? x0 : xip1 ;//mux4 logic
//a= 2^r+1 --> a=5;r=2
rgen rg1(.a(a),.r(r));
assign lsr = xi<<r ;//r bit logical shifting

//assign add3 = xi + lsr + b1 ;
carry_save_adder csa(.a(xi),.b(lsr),.c(b1),.s(add3));

always @(posedge clk)
begin 
	if(start) xip1 <= 4'd0 ;
	else xip1 <= add3 ;
end
endmodule 
//r genaration 

//r generation
module rgen(a,r);
input [3:0]a;
output reg [1:0]r;//2
always @(a)
begin 
	case (a)//0,1
	4'd5   : r = 2 ;
	4'd9   : r = 3 ;
	default  r = 0 ; 
	endcase
end
endmodule

///Three-operand modulo-2^n carry-save adder.
module carry_save_adder(a,b,c,s);
input [3:0]a,b,c;
output [3:0]s ;

fulladder fa1(.a(a[0]),.b(b[0]),.c(c[0]),.sum(s[0]),.carry(c1));

fulladder fa2(.a(a[1]),.b(b[1]),.c(c[1]),.sum(is1),.carry(c2));
fulladder fa3(.a(a[2]),.b(b[2]),.c(c[2]),.sum(is2),.carry(c3));
fulladder fa4(.a(a[3]),.b(b[3]),.c(c[3]),.sum(is3),.carry(c4));

fulladder fa25(.a(c1),.b(is1),.c(1'b0),.sum(s[1]),.carry(cc5));
fulladder fa26(.a(c2),.b(is2),.c(cc5),.sum(s[2]),.carry(cc6));
fulladder fa27(.a(c3),.b(is3),.c(cc6),.sum(s[3]),.carry(cc7));

endmodule 

//full adder

module fulladder(a,b,c,sum,carry);
input a,b,c;
output sum,carry;

assign sum = a ^ b ^ c ;
assign carry = (a & b) | (b & c) | (a & c) ;

endmodule 

//4 BIT MAGNITUDE COMPARATOR


module comparator32bit(A,B,Y);
input [3:0] A,B;
output reg Y ;

always @ *
begin
	if( A > B )  Y = 1 ;
	else Y = 0 ;//A=B ,A<B

end 


endmodule
