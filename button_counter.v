module button_counter (
	input clk,
	input button_pin,
	output reg [7:0] value
);
	reg [24:0] count_clk_count = 0;
	reg debouncing = 0;
	parameter count_time = 5000000;
	reg count_reset = 0;

	always @(posedge clk)
	begin
		if (debouncing == 1) 
		begin
			count_clk_count = count_clk_count + 1;
			if (count_clk_count > count_time) 
			begin
				count_clk_count = 0;
				debouncing = 0;
				value <= value + 1;
			end
		end
		else
		begin
			if (button_pin == 0)
			begin
				debouncing = 1;
			end
		end
	end
	

endmodule