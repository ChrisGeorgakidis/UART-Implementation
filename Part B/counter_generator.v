module counter_generator (clk, reset, sample_ENABLE, bit_cnt, next_data);
  input clk, reset, sample_ENABLE, next_data;
  output [3:0]bit_cnt;

  reg [3:0]counter;
  reg [3:0]bit_cnt;

  always @ ( posedge clk or posedge reset ) begin
    if (reset == 1'b1)
    begin
      counter <= 4'b0000;
      bit_cnt <= 4'b0000;
    end
    else
    begin
      if (next_data == 1'b0)
      begin
        if (sample_ENABLE == 1'b1)
        begin
          counter <= counter + 4'b0001;
          if (counter == 4'b1111)
          begin
            bit_cnt <= bit_cnt + 4'b0001;
          end
        end
      end
      else
      begin
        counter <= 4'b0000;
        bit_cnt <= 4'b0000;
      end
    end //end of else
  end //end of always
endmodule // counter_generator
