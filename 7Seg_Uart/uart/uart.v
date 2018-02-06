module uart (reset, clk, Tx_DATA, /*baud_select, Tx_EN,*/ Tx_WR,
            Rx_DATA, Rx_FERROR, Rx_PERROR, Rx_VALID, Tx_BUSY);

input reset, clk;
input [7:0] Tx_DATA;
//input [2:0] baud_select;
//input Tx_EN;
input Tx_WR;
output [7:0] Rx_DATA;
output Rx_FERROR; // Framing Error //
output Rx_PERROR; // Parity Error //
output Rx_VALID; // Rx_DATA is Valid //
output Tx_BUSY;

wire TxD, Rx_FERROR, Rx_PERROR, Rx_VALID;
reg Tx_EN;
reg [2:0]baud_select;

always @ ( * ) begin
    Tx_EN <= 1;
    baud_select <= 3'b0;
end

uart_transmitter DUT_Transmitter(
  .reset        (reset),
  .clk          (clk),
  .Tx_DATA      (Tx_DATA),
  .baud_select  (baud_select),
  .Tx_WR        (Tx_WR),
  .Tx_EN        (Tx_EN),
  .TxD          (TxD),
  .Tx_BUSY      (Tx_BUSY)
);

uart_receiver DUT_Receiver(
    .reset          (reset),
    .clk            (clk),
    .baud_select    (baud_select),
    .Rx_EN          (Tx_EN),
    .RxD            (TxD),
    .Rx_DATA        (Rx_DATA),
    .Rx_FERROR      (Rx_FERROR),
    .Rx_PERROR      (Rx_PERROR),
    .Rx_VALID       (Rx_VALID)
);

endmodule
