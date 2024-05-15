module uart_tx #(parameter baudrate = 115200)
(
	input clk,
	input [7:0] data_byte,
	input data_ready,
	output reg output_tx
);
	// uart TX states
	parameter IDLE = 2'b00;
	parameter START = 2'b01;
	parameter DATA = 2'b10;
	parameter END = 2'b11;
	
	// system parameters
	parameter clk_freq = 10000000;

	// uart variables
	parameter clks_per_byte = clk_freq / baudrate;
	reg [2:0] state = IDLE;
	reg [24:0] clk_count = 0;
	reg [3:0] bit_index = 0;

	always @(posedge clk)
	begin
		case (state)
			IDLE:
			begin
				output_tx <= 1;	// Set tx line HIGH to indicate idle state
				if (data_ready == 1)  // When data ready change state to START
					begin
						clk_count <= 0;
						state <= START;
					end
			end
			START:
			begin
				output_tx <= 0;  // Set tx line LOW - start transmition
				clk_count <= clk_count + 1;
				if (clk_count == clks_per_byte)
					begin
					clk_count <= 0;
					state <= DATA;
					end
			end
			
			DATA:
			begin
				output_tx <= data_byte[bit_index];
				clk_count <= clk_count + 1;
				if (clk_count == clks_per_byte)
					begin
						clk_count <= 0;
						bit_index <= bit_index + 1;
					end
					
				if (bit_index > 7)
					begin
						bit_index <= 0;
						state <= END;
					end
				end
			
			END:
			begin
				output_tx <= 1;
				clk_count <= clk_count + 1;
				if (clk_count == clks_per_byte) 
					begin
						clk_count <= 0;
						state <= IDLE;
					end
			end
		endcase
	end

endmodule 