module Uart_7seg (clk, reset, Tx_DATA, Tx_WR, an3, an2, an1, an0, a, b, c, d, e, f, g, dp,
	Rx_FERROR, Rx_PERROR, Rx_VALID, Tx_BUSY);

//Uart inputs
input reset, clk;
input [7:0] Tx_DATA;
input Tx_WR;
//LED driver outputs
output an3, an2, an1, an0;
output a, b, c, d, e, f, g, dp;
output Rx_FERROR, Rx_PERROR, Rx_VALID, Tx_BUSY;

wire [7:0]Rx_DATA;

FourDigitLEDdriver FourDigitLEDdriver (
	.reset		(reset),
	.clock		(clk),
	.Data_in	(Rx_DATA),
	.an3		(an3),
	.an2		(an2),
	.an1		(an1),
	.an0		(an0),
	.a			(a),
	.b			(b),
	.c			(c),
	.d			(d),
	.e			(e),
	.f			(f),
	.g			(g),
	.dp			(dp)
);

uart uart(
	.reset			(reset),
	.clk			(clk),
	.Tx_DATA		(Tx_DATA),
	.Tx_WR			(Tx_WR),
    .Rx_DATA		(Rx_DATA),
	.Rx_FERROR		(Rx_FERROR),
	.Rx_PERROR		(Rx_PERROR),
	.Rx_VALID		(Rx_VALID),
	.Tx_BUSY		(Tx_BUSY)
);
endmodule
