module uart_transmitter(reset, clk, Tx_DATA, baud_select, Tx_WR, Tx_EN, TxD, Tx_BUSY);
input reset, clk;
input [7:0] Tx_DATA;
input [2:0] baud_select;
input Tx_EN;
input Tx_WR;
output TxD;
output Tx_BUSY;

// Wires and Regs
wire Tx_sample_ENABLE;
wire [3:0]bit_cnt;
reg TxD, Tx_BUSY, next_data;
wire [3:0]state;
reg [3:0]next_state;



//------------------Baud Controller-------------------//
baud_controller baud_controller_tx_instance(
	.reset					(reset),
	.clk						(clk),
	.baud_select		(baud_select),
	.sample_ENABLE	(Tx_sample_ENABLE)
);

//-----------------Counter Generator------------------//
counter_generator counter_generator(
	.reset					(reset),
	.clk						(clk),
	.sample_ENABLE	(Tx_sample_ENABLE),
	.bit_cnt				(bit_cnt),
	.next_data			(next_data)
);

assign state = next_state;

always @ ( posedge clk or posedge reset ) begin
  if (reset == 1) begin
  	next_state <= 4'b0000;	//Go to OFF
  end
	else begin
	  case (state)
	    4'b0000: begin       //OFF
	      if (Tx_EN == 1'b1) begin
	        next_state <= 4'b0001;	//Go to IDLE
	      end
	      else begin
	        next_state <= 4'b0000;	//Stay here
	      end
	    end

	    4'b0001: begin       //IDLE
	      if (Tx_WR == 1'b1) begin
	        next_state <= 4'b0010;	//Go to START
	      end
	      else begin
	        next_state <= 4'b0001;	//Stay here
	      end
	    end

	    4'b0010: begin       //START
	      if (bit_cnt == 4'd1) begin
	        next_state <= 4'b0011;	//Go to DATA 0
	      end
	      else begin
	        next_state <= 4'b0010;	//Stay here
	      end
	    end

	    4'b0011: begin       //DATA 0
	      if (bit_cnt == 4'd2) begin
	        next_state <= 4'b0100;	//Go to DATA 1
	      end
	      else begin
	        next_state <= 4'b0011;	//Stay here
	      end
	    end
			4'b0100: begin       //DATA 1
	      if (bit_cnt == 4'd3) begin
	        next_state <= 4'b0101;	//Go to DATA 2
	      end
	      else begin
	        next_state <= 4'b0100;	//Stay here
	      end
	    end
			4'b0101: begin       //DATA 2
	      if (bit_cnt == 4'd4) begin
	        next_state <= 4'b0110;	//Go to DATA 3
	      end
	      else begin
	        next_state <= 4'b0101;	//Stay here
	      end
	    end
			4'b0110: begin       //DATA 3
	      if (bit_cnt == 4'd5) begin
	        next_state <= 4'b0111;	//Go to DATA 4
	      end
	      else begin
	        next_state <= 4'b0110;	//Stay here
	      end
	    end
			4'b0111: begin       //DATA 4
	      if (bit_cnt == 4'd6) begin
	        next_state <= 4'b1000;	//Go to DATA 5
	      end
	      else begin
	        next_state <= 4'b0111;	//Stay here
	      end
	    end
			4'b1000: begin       //DATA 5
	      if (bit_cnt == 4'd7) begin
	        next_state <= 4'b1001;	//Go to DATA 6
	      end
	      else begin
	        next_state <= 4'b1000;	//Stay here
	      end
	    end
			4'b1001: begin       //DATA 6
	      if (bit_cnt == 4'd8) begin
	        next_state <= 4'b1010;	//Go to DATA 7
	      end
	      else begin
	        next_state <= 4'b1001;	//Stay here
	      end
	    end
			4'b1010: begin       //DATA 7
	      if (bit_cnt == 4'd9) begin
	        next_state <= 4'b1011;	//Go to PARITY
	      end
	      else begin
	        next_state <= 4'b1010;	//Stay here
	      end
	    end

	    4'b1011: begin       //PARITY
	      if (bit_cnt == 4'd10) begin
	        next_state <= 4'b1100;	//Go to STOP
	      end
	      else begin
	        next_state <= 4'b1011;	//Stay here
	      end
	    end

	    4'b1100: begin       //STOP
				if (bit_cnt == 4'd11) begin
		      if (Tx_EN == 1'b0) begin
		        next_state <= 4'b0000;	//Go to OFF
		      end
					else begin
						next_state <= 4'b0001;	//Go to IDLE
					end
				end
	      else begin
	        next_state <= 4'b1100;		//Stay here
	      end
	    end

	    default: begin       //BACK TO OFF
	      next_state <= 4'b0000;	 //Go to OFF
	    end
	  endcase
	end
end

//~~~~~~~~~~~~~~~~~~~Update Signals~~~~~~~~~~~~~~~~~~~~~//

always @ (posedge clk) begin
  case (state)
    4'b0000: begin       //OFF
      TxD <= 1'b1;
      Tx_BUSY <= 1'b0;
			next_data <= 1'b1;
    end

    4'b0001: begin       //IDLE
      TxD <= 1'b1;
      Tx_BUSY <= 1'b0;
			next_data <= 1'b1;
    end

    4'b0010: begin       //START
      TxD <= 1'b0;      //starting bit
      Tx_BUSY <= 1'b1;
			next_data <= 1'b0;
    end

    4'b0011: begin       //DATA 0
      TxD <= Tx_DATA[0];
      Tx_BUSY <= 1'b1;
			next_data <= 1'b0;
    end

		4'b0100: begin       //DATA 1
			TxD <= Tx_DATA[1];
			Tx_BUSY <= 1'b1;
			next_data <= 1'b0;
		end

		4'b0101: begin       //DATA 2
			TxD <= Tx_DATA[2];
			Tx_BUSY <= 1'b1;
			next_data <= 1'b0;
		end

		4'b0110: begin       //DATA 3
			TxD <= Tx_DATA[3];
			Tx_BUSY <= 1'b1;
			next_data <= 1'b0;
		end

		4'b0111: begin       //DATA 4
			TxD <= Tx_DATA[4];
			Tx_BUSY <= 1'b1;
			next_data <= 1'b0;
		end

		4'b1000: begin       //DATA 5
			TxD <= Tx_DATA[5];
			Tx_BUSY <= 1'b1;
			next_data <= 1'b0;
		end

		4'b1001: begin       //DATA 6
			TxD <= Tx_DATA[6];
			Tx_BUSY <= 1'b1;
			next_data <= 1'b0;
		end

		4'b1010: begin       //DATA 7
			TxD <= Tx_DATA[7];
			Tx_BUSY <= 1'b1;
			next_data <= 1'b0;
		end

    4'b1011: begin       //PARITY
      TxD <= Tx_DATA[7]^Tx_DATA[6]^Tx_DATA[5]^Tx_DATA[4]^Tx_DATA[3]^Tx_DATA[2]^Tx_DATA[1]^Tx_DATA[0];
      Tx_BUSY <= 1'b1;
			next_data <= 1'b0;
    end

    4'b1100: begin       //STOP
      TxD <= 1'b1;      //stoping bit
      Tx_BUSY <= 1'b1;
			next_data <= 1'b0;
    end
    default: begin      //BACK TO OFF
      TxD <= 1'b1;
      Tx_BUSY <= 1'b0;
			next_data <= 1'b0;
    end
  endcase
end


endmodule
