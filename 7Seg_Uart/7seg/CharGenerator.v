module CharGenerator (clock, counter, Data_in, char);

input clock;
input [3:0]counter;
input [7:0]Data_in;
output [3:0]char;

wire [3:0]counter;
reg [3:0]char;

always @ (posedge clock)
begin
	case (counter)
		4'b0000:	char <= Data_in[7:4];
		4'b0001:	char <= Data_in[7:4];
		4'b0010:	char <= Data_in[7:4];

		4'b0100:	char <= Data_in[3:0];
		4'b0101:	char <= Data_in[3:0];
		4'b0110:	char <= Data_in[3:0];

		4'b1000:	char <= Data_in[7:4];
		4'b1001:	char <= Data_in[7:4];
		4'b1010:	char <= Data_in[7:4];

		4'b1100:	char <= Data_in[3:0];
		4'b1101:	char <= Data_in[3:0];
		4'b1110:	char <= Data_in[3:0];
		default: char <= 4'b0000;
	endcase
end

endmodule
