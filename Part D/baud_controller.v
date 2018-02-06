module baud_controller(reset, clk, baud_select, sample_ENABLE);

input reset, clk;
input [2:0] baud_select;
output sample_ENABLE;

wire [2:0] baud_select;
reg [16:0] baud_rate;
reg sample_ENABLE;
reg [13:0] counter;
//Find how many bits have to be the counter
// 1. 50000000 / (16 x 300)     = 10416.666666666 ~ 10417 =>  10100010110001  ->  14bits
// 2. 50000000 / (16 x 1200)    = 2604.1666666667 ~ 2604  =>  101000101100    ->  12bits
// 3. 50000000 / (16 x 4800)    = 651.0416666667  ~ 651   =>  1010001011      ->  10bits
// 4. 50000000 / (16 x 9600)    = 325.5208333333  ~ 326   =>  101000110       ->  9bits
// 5. 50000000 / (16 x 19200)   = 162.7604166667  ~ 163   =>  10100011        ->  8bits
// 6. 50000000 / (16 x 38400)   = 81.3802083333   ~ 81    =>  1010001         ->  7bits
// 7. 50000000 / (16 x 57600)   = 54.2534722222   ~ 54    =>  110110          ->  6bits
// 8. 50000000 / (16 x 115200)  = 27.1267361111   ~ 27    =>  11011           ->  5bits
// Counter must be 14bits long so it can represent 10417

always @ ( baud_select )
begin
	case (baud_select)
	3'b000: baud_rate <= 17'd300;			//00000000100101100  //300 bits/sec
	3'b001: baud_rate <= 17'd1200;			//00000010010110000  //1200 bits/sec
	3'b010: baud_rate <= 17'd4800;			//00001001011000000  //4800 bits/sec
	3'b011: baud_rate <= 17'd9600;		//00010010110000000  //9600 bits/sec
	3'b100: baud_rate <= 17'd19200;		//00100101100000000  //19200 bits/sec
	3'b101: baud_rate <= 17'd38400;		//01001011000000000  //38400 bits/sec
	3'b110: baud_rate <= 17'd57600; 		//01110000100000000  //57600 bits/sec
	3'b111: baud_rate <= 17'd115200;		//11100001000000000  //115200 bits/sec
  default:baud_rate <= 17'd300;
  endcase
end

always @ ( posedge clk or posedge reset )
begin
	if (reset == 1)
	begin
		counter <= 14'b0;
		sample_ENABLE <= 0;
	end
	else
	begin
    
		if (counter == baud_rate)
		begin
			counter <= 14'b0;
			sample_ENABLE <= 1'b1;
		end
		else
		begin
			counter <= counter + 14'b1;
			sample_ENABLE <= 1'b0;
		end
	end
end

endmodule
