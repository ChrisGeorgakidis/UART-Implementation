module uart_tb_r ();

reg clk, reset, Rx_EN, RxD;
reg [2:0]baud_select;

wire [7:0]Rx_DATA;
//wire Rx_BUSY;
wire Rx_FERROR, Rx_PERROR, Rx_VALID;

uart_receiver DUT(
  .reset        (reset),
  .clk          (clk),
  .Rx_DATA      (Rx_DATA),
  .baud_select  (baud_select),
  .Rx_EN        (Rx_EN),
  .RxD          (RxD),
  .Rx_FERROR    (Rx_FERROR),
  .Rx_PERROR    (Rx_PERROR),
  .Rx_VALID     (Rx_VALID)
);

initial begin
  clk = 0;
  reset = 0;
  Rx_EN = 0;
  RxD = 1;
  baud_select = 3'b0;
  #10 Rx_EN = 1;
  #50 reset = 1;
  #50 reset = 0;
  #400000 RxD = 0;
  #1100000 RxD = 1;
end

always begin
  #10 clk = ~clk;
end
endmodule
