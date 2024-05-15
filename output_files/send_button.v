module send_button(
	input clk,
	input button_pin,
	output reg send
);

reg [24:0] button_clk_count = 0;
reg start_transmit = 0;
reg wait_debouncing = 0;
parameter debouncing_time = 5000000;

always @(posedge clk)
	begin
		if (wait_debouncing == 1) 
		begin
			send <= 0;
			button_clk_count = button_clk_count + 1;
			if (button_clk_count > debouncing_time) 
			begin
				button_clk_count = 0;
				wait_debouncing = 0;
			end
		end
		else
		begin
			if (button_pin == 0)
			begin
				button_clk_count = 0;
				send <= 1;
				wait_debouncing = 1;
			end
		end
	end
	
endmodule