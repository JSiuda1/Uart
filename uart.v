module uart(
	input clk,
//	input [7:0] data_byte
	input data_ready,
	output reg output_tx,
	output reg [1:0] led
);
	// Temporary
	parameter [7:0] data_byte = 65;  // A

	// uart TX states
	parameter TX_IDLE = 2'b00;
	parameter TX_START = 2'b01;
	parameter TX_DATA = 2'b10;
	parameter TX_END = 2'b11;

	// uart parameters
	parameter baudrate = 115200;
	
	// uystem parameters
	parameter clk_freq = 10000000;  // TBD set correct clock freq
	
	// uart variables
	parameter clks_per_byte = clk_freq / baudrate;
	reg [1:0] tx_state = TX_IDLE;
	reg [7:0] clk_count = 0;
	reg tx_bit_index = 0;
	
	// always on positive clock edge
	always @(posedge clk)
	begin
		led <= ~tx_state;
		case (tx_state)
			TX_IDLE:
			begin
				output_tx <= 1;	// Set tx line HIGH to indicate idle state
				if (data_ready == 0)  // When data ready change state to TX_START
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
					if (tx_bit_index < 7)
						begin
						tx_bit_index <= tx_bit_index + 1;
						end
					else
						begin
						tx_bit_index <= 0;
						tx_state <= TX_END;
						end
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