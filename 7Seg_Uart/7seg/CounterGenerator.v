module CounterGenerator(clock, reset, counter);

input clock, reset;
output [3:0]counter;

wire clock, reset;
reg [3:0]counter;

//always @ (reset)
//begin
	//if (reset == 1)	
	//begin
	//	counter <= 6'b000000;
	//end
//end
		
always @ (posedge clock, posedge reset) 
begin
	if (reset == 1)
		counter <= 4'b0000;
	else
		counter <= counter + 4'b0001;
end


endmodule
