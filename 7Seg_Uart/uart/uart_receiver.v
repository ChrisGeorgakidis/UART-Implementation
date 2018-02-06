module uart_receiver(reset, clk, Rx_DATA, baud_select, Rx_EN, RxD, Rx_FERROR, Rx_PERROR, Rx_VALID);
input reset, clk;
input [2:0] baud_select;
input Rx_EN;
input RxD;
output [7:0] Rx_DATA;
output Rx_FERROR; // Framing Error //
output Rx_PERROR; // Parity Error //
output Rx_VALID; // Rx_DATA is Valid //

wire [3:0]state;
reg [3:0]next_state;
reg [2:0]f_sampling;
wire [7:0]Rx_DATA;
reg [7:0]DATA;
reg Rx_FERROR, Rx_PERROR, Rx_VALID, next_data;
wire Rx_sample_ENABLE;
wire [3:0]counter;
wire [3:0]bit_cnt;

//------------------Baud Controller-------------------//
baud_controller baud_controller_rx_instance(
  .reset          (reset),
  .clk            (clk),
  .baud_select    (baud_select),
  .sample_ENABLE  (Rx_sample_ENABLE)
);

//-------------Receiver Counter Generator------------//
receiver_counter_generator receiver_counter_generator(
  .reset          (reset),
  .clk            (clk),
  .sample_ENABLE  (Rx_sample_ENABLE),
  .bit_cnt        (bit_cnt),
  .counter        (counter),
  .next_data      (next_data)
);

assign state = next_state;
assign Rx_DATA = DATA[7:0];

  always @ ( posedge clk or posedge reset ) begin
    if (reset == 1'b1) begin
      next_state <= 4'b0000; //Go to OFF
    end
    else begin
      case (state)
        4'd0: begin    //OFF
          if (Rx_EN == 1'b1) begin
            next_state <= 4'd1; //Go to WAITING
          end
          else begin
            next_state <= 4'd0; //Stay here
          end
        end

        4'd1: begin    //WAITING
          if (RxD == 1'b0) begin
            next_state <= 4'd2; //Go to START
          end
          else begin
            next_state <= 4'd1; //Stay here
          end
        end
        4'd2: begin    //START
          if (bit_cnt == 4'd1) begin
            if (f_sampling == 3'b000) begin
              next_state <= 4'd3;
            end
            else begin
              next_state <= 4'd14; //Go to IDLE
            end
          end
          else begin
            next_state <= 4'd2;
          end
        end
        4'd3: begin    //DATA 0
          if (bit_cnt == 4'd2) begin
            next_state <= 4'd4; //Go to DATA 1
          end
          else begin
            next_state <= 4'd3; //Stay here
          end
        end
        4'd4: begin    //DATA 1
          if (bit_cnt == 4'd3) begin
            next_state <= 4'd5; //Go to DATA 2
          end
          else begin
            next_state <= 4'd4; //Stay here
          end
        end
        4'd5: begin    //DATA 2
          if (bit_cnt == 4'd4) begin
            next_state <= 4'd6; //Go to DATA 3
          end
          else begin
            next_state <= 4'd5; //Stay here
          end
        end
        4'd6: begin    //DATA 3
          if (bit_cnt == 4'd5) begin
            next_state <= 4'd7; //Go to DATA 4
          end
          else begin
            next_state <= 4'd6; //Stay here
          end
        end
        4'd7: begin    //DATA 4
          if (bit_cnt == 4'd6) begin
            next_state <= 4'd8; //Go to DATA 5
          end
          else begin
            next_state <= 4'd7; //Stay here
          end
        end
        4'd8: begin    //DATA 5
          if (bit_cnt == 4'd7) begin
            next_state <= 4'd9; //Go to DATA 6
          end
          else begin
            next_state <= 4'd8; //Stay here
          end
        end
        4'd9: begin    //DATA 6
          if (bit_cnt == 4'd8) begin
            next_state <= 4'd10; //Go to DATA 7
          end
          else begin
            next_state <= 4'd9; //Stay here
          end
        end
        4'd10: begin    //DATA 7
          if (bit_cnt == 4'd9) begin
            next_state <= 4'd11; //Go to PARITY
          end
          else begin
            next_state <= 4'd10; //Stay here
          end
        end
        4'd11: begin    //PARITY
          if (bit_cnt == 4'd10) begin
            if (RxD != ^DATA) begin
              next_state <= 4'd1; //Go to WAITING
            end
            else begin
              next_state <= 4'd12; //Go to FRAMING
            end
          end
          else begin
            next_state <= 4'd11; //Stay here
          end
        end
        4'd12: begin    //FRAMING
          if (bit_cnt == 4'd11) begin
            if (f_sampling == 3'b111) begin
              next_state <= 4'd13; //Go to DONE
            end
            else begin
              next_state <= 4'd1; //Go to WAITING
            end
          end
          else begin
            next_state <= 4'd12; //Stay here
          end
        end
        4'd13: begin    //DONE
          if (Rx_EN == 1'b0) begin
            next_state <= 4'd0;	//Go to OFF
          end
          else begin
            next_state <= 4'd1;	//Go to WAITING
          end
        end
        4'd14: begin    //IDLE
          if (bit_cnt == 4'd11) begin
            next_state <= 4'd1; //Go to WAITING
          end
          else begin
            next_state <= 4'd14; //Stay here
          end
        end
        default: begin    //BACK TO OFF
          next_state <= 4'd0; //Go to OFF
        end
      endcase
    end
  end


  always @ (posedge clk or posedge reset) begin
    if (reset == 1'b1) begin
      DATA <= 8'b00000000;
      Rx_FERROR <= 1'b0;
      Rx_PERROR <= 1'b0;
      Rx_VALID <= 1'b0;
      next_data <= 1'b1;
      f_sampling <= 3'b111;
    end else begin
      case (state)
        4'd0: begin    //OFF
          DATA <= 8'bxxxxxxxx;
          Rx_FERROR <= 1'b0;
          Rx_PERROR <= 1'b0;
          Rx_VALID <= 1'b0;
          next_data <= 1'b1;
        end
        4'd1: begin    //WAITING
          DATA <= 8'bxxxxxxxx;
          Rx_FERROR <= 1'b0;
          Rx_PERROR <= 1'b0;
          Rx_VALID <= 1'b0;
          next_data <= 1'b1;
          f_sampling <= 3'b111;
        end
        4'd2: begin    //START
          DATA <= 8'bxxxxxxxx;
          if ((counter == 4'b1110 || counter == 4'b1111) && (Rx_sample_ENABLE == 1'b1)) begin
            if (f_sampling == 3'b000) begin
              Rx_FERROR <= 1'b0;
            end
            else begin
              Rx_FERROR <= 1'b1;
            end
          end
          Rx_PERROR <= 1'b0;
          Rx_VALID <= 1'b0;
          next_data <= 1'b0;
          if ((counter == 4'b0100) && (Rx_sample_ENABLE == 1'b1)) begin
            f_sampling[0] <= RxD;
          end
          if ((counter == 4'b1000) && (Rx_sample_ENABLE == 1'b1)) begin
            f_sampling[1] <= RxD;
          end
          if ((counter == 4'b1100) && (Rx_sample_ENABLE == 1'b1)) begin
            f_sampling[2] <= RxD;
          end
        end
        4'd3: begin    //DATA 0
          if ((counter == 4'b1000) && (Rx_sample_ENABLE == 1'b1)) begin
            DATA <= {RxD, DATA[7:1]};
          end
          Rx_FERROR <= 1'b0;
          Rx_PERROR <= 1'b0;
          Rx_VALID <= 1'b0;
          next_data <= 1'b0;
        end
        4'd4: begin    //DATA 1
          if ((counter == 4'b1000) && (Rx_sample_ENABLE == 1'b1)) begin
            DATA <= {RxD, DATA[7:1]};
          end
          Rx_FERROR <= 1'b0;
          Rx_PERROR <= 1'b0;
          Rx_VALID <= 1'b0;
          next_data <= 1'b0;
        end
        4'd5: begin    //DATA 2
          if ((counter == 4'b1000) && (Rx_sample_ENABLE == 1'b1)) begin
            DATA <= {RxD, DATA[7:1]};
          end
          Rx_FERROR <= 1'b0;
          Rx_PERROR <= 1'b0;
          Rx_VALID <= 1'b0;
          next_data <= 1'b0;
        end
        4'd6: begin    //DATA 3
          if ((counter == 4'b1000) && (Rx_sample_ENABLE == 1'b1)) begin
            DATA <= {RxD, DATA[7:1]};
          end
          Rx_FERROR <= 1'b0;
          Rx_PERROR <= 1'b0;
          Rx_VALID <= 1'b0;
          next_data <= 1'b0;
        end
        4'd7: begin    //DATA 4
          if ((counter == 4'b1000) && (Rx_sample_ENABLE == 1'b1)) begin
            DATA <= {RxD, DATA[7:1]};
          end
          Rx_FERROR <= 1'b0;
          Rx_PERROR <= 1'b0;
          Rx_VALID <= 1'b0;
          next_data <= 1'b0;
        end
        4'd8: begin    //DATA 5
          if ((counter == 4'b1000) && (Rx_sample_ENABLE == 1'b1)) begin
            DATA <= {RxD, DATA[7:1]};
          end
          Rx_FERROR <= 1'b0;
          Rx_PERROR <= 1'b0;
          Rx_VALID <= 1'b0;
          next_data <= 1'b0;
        end
        4'd9: begin    //DATA 6
          if ((counter == 4'b1000) && (Rx_sample_ENABLE == 1'b1)) begin
            DATA <= {RxD, DATA[7:1]};
          end
          Rx_FERROR <= 1'b0;
          Rx_PERROR <= 1'b0;
          Rx_VALID <= 1'b0;
          next_data <= 1'b0;
        end
        4'd10: begin    //DATA 7
          if ((counter == 4'b1000) && (Rx_sample_ENABLE == 1'b1)) begin
            DATA <= {RxD, DATA[7:1]};
          end
          Rx_FERROR <= 1'b0;
          Rx_PERROR <= 1'b0;
          Rx_VALID <= 1'b0;
          next_data <= 1'b0;
        end
        4'd11: begin    //PARITY
          Rx_FERROR <= 1'b0;
          if ((counter == 4'b1000) && (Rx_sample_ENABLE == 1'b1)) begin
            if (RxD != ^DATA) begin
              Rx_PERROR <= 1'b1;
            end
            else begin
              Rx_PERROR <= 1'b0;
            end
          end
          Rx_VALID <= 1'b0;
          next_data <= 1'b0;
        end
        4'd12: begin    //FRAMING
          if ((counter == 4'b1110 || counter == 4'b1111) && (Rx_sample_ENABLE == 1'b1)) begin
            if (f_sampling == 3'b111) begin
              Rx_FERROR <= 1'b0;
            end
            else begin
              Rx_FERROR <= 1'b1;
            end
          end
          Rx_PERROR <= 1'b0;
          Rx_VALID <= 1'b0;
          next_data <= 1'b0;
          if ((counter == 4'b0100) && (Rx_sample_ENABLE == 1'b1)) begin
            f_sampling[0] <= RxD;
          end
          if ((counter == 4'b1000) && (Rx_sample_ENABLE == 1'b1)) begin
            f_sampling[1] <= RxD;
          end
          if ((counter == 4'b1100) && (Rx_sample_ENABLE == 1'b1)) begin
            f_sampling[2] <= RxD;
          end
        end
        4'd13: begin    //DONE
          Rx_FERROR <= 1'b0;
          Rx_PERROR <= 1'b0;
          Rx_VALID <= 1'b1;
          next_data <= 1'b0;
        end
        4'd14: begin    //IDLE
          Rx_FERROR <= 1'b1;
          Rx_PERROR <= 1'b0;
          Rx_VALID <= 1'b0;
          next_data <= 1'b0;
        end
        default: begin    //BACK TO OFF
          DATA <= 8'bxxxxxxxx;
          Rx_FERROR <= 1'b0;
          Rx_PERROR <= 1'b0;
          Rx_VALID <= 1'b0;
          next_data <= 1'b1;
        end
      endcase
    end
  end
endmodule
