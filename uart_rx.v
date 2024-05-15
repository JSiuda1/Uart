module uart_rx #(parameter baudrate = 115200) (
	input clk,
	input rx,
	output reg [7:0] out_data,
	output reg done
);
	// uart RX states
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
	reg [7:0] data = 0;
	
	always @(posedge clk) 
	begin
		case (state)
			IDLE: 
			begin
				done <= 0;
				// IDLE uart has always high state on line
				if (rx == 0)
				begin			
					bit_index <= 0;
					clk_count <= 0;
					state <= START;
				end
			end
			
			START:
			begin
				clk_count <= clk_count + 1;
				if (clk_count == (clks_per_byte / 2)) 
				begin
					clk_count <= 0;
					state <= DATA;
				end
			end
			
			DATA:
			begin
				clk_count <= clk_count + 1;
				if (clk_count == clks_per_byte)
				begin
					data[bit_index] = rx;
					clk_count <= 0;
					bit_index <= bit_index + 1;
					if (bit_index >= 7) 
					begin			
						state <= END;
					end
				end
			end

			END:	// TO DO: check that end is high
			begin
				clk_count <= clk_count + 1;
				if (clk_count == clks_per_byte) 
				begin
					done <= 1;
					out_data <= data;
					clk_count <= 0;
					state <= IDLE;
				end
			end
		endcase
	end

endmodule
