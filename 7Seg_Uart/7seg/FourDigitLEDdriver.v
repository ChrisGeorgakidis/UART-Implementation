module FourDigitLEDdriver (reset, clock, Data_in, an3, an2, an1, an0, a, b, c, d, e, f, g, dp);

input clock, reset;
input [7:0]Data_in;
output an3, an2, an1, an0;
output a, b, c, d, e, f, g, dp;


wire clock, reset;
wire an3, an2, an1, an0;
wire a, b, c, d, e, f, g;
wire dp;


wire [3:0]char;
wire [3:0]counter;
wire [6:0]LED;
//wire [5:0]counterClock;
wire newClock;

NewClockGenerator NewClockGenerator (
	.clock (clock),
	.reset (reset),
	.newClock (newClock)
);

CharGenerator CharGenerator(
	.clock		(clock),
	.counter 	(counter),
	.Data_in	(Data_in),
	.char		(char)
);

CounterGenerator CounterGenerator(
	.clock			(newClock),
	.reset			(reset),
	.counter		(counter)
);

LEDdecoder LEDdecoder(
	.char	(char),
	.LED	(LED)
);


assign a = LED[6];
assign b = LED[5];
assign c = LED[4];
assign d = LED[3];
assign e = LED[2];
assign f = LED[1];
assign g = LED[0];
assign dp = 1'b1;

AnodeSelector AnodeSelector(
	.counter	(counter),
	.an3		(an3),
	.an2		(an2),
	.an1		(an1),
	.an0		(an0)
);


endmodule
