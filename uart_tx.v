module uart_tx #(parameter baudrate = 115200)
(
	input clk,
//	input [7:0] data_byte
	input data_ready,
	input data_count,
	output reg output_tx,
	output reg [1:0] led
);
	// Temporary
	reg [7:0] data_byte = 0;  // 'a'

	// reg output_tx;
	// uart TX states
	parameter TX_IDLE = 2'b00;
	parameter TX_START = 2'b01;
	parameter TX_DATA = 2'b10;
	parameter TX_END = 2'b11;
	
	// system parameters
	parameter clk_freq = 10000000;
	
	// uart variables
	parameter clks_per_byte = clk_freq / baudrate;
	reg [2:0] tx_state = TX_IDLE, tx_next_state = TX_IDLE;
	reg [24:0] clk_count = 0;
	reg [3:0] tx_bit_index = 0;
	reg [3:0] next_tx_bit_index = 0;
	reg clk_rst = 0;
	reg tx_busy = 0;
	reg [1:0] led_state = 0;
	reg start_transmition = 0;
	
	reg [24:0] button_clk_count = 0;
	reg start_transmit = 0;
	reg wait_debouncing = 0;
	parameter debouncing_time = 5000000;
	
	reg [24:0] count_clk_count = 0;
	reg count_debouncing = 0;
	parameter count_time = 5000000;
	reg count_reset = 0;

	always @(posedge clk)
	begin
		case (tx_state)
			TX_IDLE:
			begin
				output_tx <= 1;	// Set tx line HIGH to indicate idle state
				if (start_transmit == 1)  // When data ready change state to TX_START
					begin
						clk_count <= 0;
						tx_state <= TX_START;
					end
			end
			TX_START:
			begin
				output_tx <= 0;  // Set tx line LOW - start transmition
				if (clk_count < clks_per_byte - 1)
					begin
					clk_count <= clk_count + 1;
					end
				else 
					begin
					clk_count <= 0;
					tx_state <= TX_DATA;
					end
			end
			
			TX_DATA:
			begin
				output_tx <= data_byte[tx_bit_index];
				if (clk_count < clks_per_byte - 1)
					begin
					clk_count <= clk_count + 1;
					end
				else
					begin
						clk_count <= 0;
						tx_bit_index <= tx_bit_index + 1;
					end
					
				if (tx_bit_index > 7)
					begin
						tx_bit_index <= 0;
						tx_state <= TX_END;
					end
				end
			
			TX_END:
			begin
				output_tx <= 1;
				if (clk_count < clks_per_byte - 1)
					begin
					clk_count <= clk_count + 1;
					end
				else 
					begin
						clk_count <= 0;
						tx_state <= TX_IDLE;
					end
			end
		endcase
	end
	
	always @(posedge clk)
	begin
		if (count_debouncing == 1) 
		begin
			count_clk_count = count_clk_count + 1;
			if (count_clk_count > count_time) 
			begin
				count_clk_count = 0;
				count_debouncing = 0;
				data_byte <= data_byte + 1;
			end
		end
		else
		begin
			if (data_count == 0)
			begin
				count_debouncing = 1;
			end
		end
	end
	
	always @(posedge clk)
	begin
		led = data_ready;
		if (wait_debouncing == 1) 
		begin
			start_transmit = 0;
			button_clk_count = button_clk_count + 1;
			if (button_clk_count > debouncing_time) 
			begin
				button_clk_count = 0;
				wait_debouncing = 0;
			end
		end
		else
		begin
			if (data_ready == 0 && start_transmit == 0)
			begin
				button_clk_count = 0;
				start_transmit = 1;
				wait_debouncing = 1;
			end
		end
	end
	

endmodule 