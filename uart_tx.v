module uart_tx #(parameter baudrate = 115200)
(
	input clk,
//	input [7:0] data,
	input data_ready,
	output reg output_tx
);
	// Temporary
	reg [7:0] data_byte = 32;  // 'a'

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

	always @(posedge clk)
	begin
		case (tx_state)
			TX_IDLE:
			begin
				output_tx <= 1;	// Set tx line HIGH to indicate idle state
				if (data_ready == 1)  // When data ready change state to TX_START
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

endmodule 