module AnodeSelector (counter, an3, an2, an1, an0);

input [3:0]counter;
output an3, an2, an1, an0;

wire [3:0]counter;
reg an3, an2, an1, an0;

always @ (counter)
begin
	case (counter)
		4'b0001:	
			begin
				an3 <= 1'b0;
				an2 <= 1'b1;
				an1 <= 1'b1;
				an0 <= 1'b1;
			end
					
		4'b0101:	
			begin
				an3 <= 1'b1;
				an2 <= 1'b0;
				an1 <= 1'b1;
				an0 <= 1'b1;	
			end
		
		4'b1001:	
			begin
				an3 <= 1'b1;
				an2 <= 1'b1;
				an1 <= 1'b0;
				an0 <= 1'b1;
			end
		
		4'b1101:	
			begin
				an3 <= 1'b1;
				an2 <= 1'b1;
				an1 <= 1'b1;
				an0 <= 1'b0;
			end
		
		default:	
			begin
				an3 <= 1'b1;
				an2 <= 1'b1;
				an1 <= 1'b1;
				an0 <= 1'b1;
			end
	endcase
end
endmodule
