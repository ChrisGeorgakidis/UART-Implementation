module uart_tb ();

reg clk, reset, Tx_EN, Tx_WR;
reg [2:0]baud_select;
reg [7:0]Tx_DATA;
wire [7:0]Rx_DATA;

wire TxD, Tx_BUSY, Rx_FERROR, Rx_PERROR, Rx_VALID;

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
    .clk					(clk),
    .baud_select    (baud_select),
    .Rx_EN          (Tx_EN),
    .RxD            (TxD),
    .Rx_DATA        (Rx_DATA),
    .Rx_FERROR      (Rx_FERROR),
    .Rx_PERROR      (Rx_PERROR),
    .Rx_VALID       (Rx_VALID)
);


initial begin
  clk = 0;
  reset = 0;
  Tx_EN = 0;
  Tx_WR = 0;
  baud_select = 3'b0;
  Tx_DATA = 8'b00000000;
  #50 reset = 1;
  #500 reset = 0;
  #10 Tx_EN = 1;
  #50 Tx_DATA = 8'b10011001;
  Tx_WR = 1;
  #20 Tx_WR = 0;
  #900000 Tx_DATA = 8'b10101010;
  Tx_WR = 1;
  #20 Tx_WR = 0;
  #1500000 Tx_DATA = 8'b10101101;
  Tx_WR = 1;
  #20 Tx_WR = 0;
end

always begin
  #10 clk = ~clk;
end



endmodule
