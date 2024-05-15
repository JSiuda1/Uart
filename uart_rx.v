module uart_rx (
	input clk,
	output reg [7:0] out_data,
	output reg done
);
	// uart RX states
	parameter IDLE = 2'b00;
	parameter TX_START = 2'b01;
	parameter TX_DATA = 2'b10;
	parameter TX_END = 2'b11;
	
	// system parameters
	parameter clk_freq = 10000000;
	
	// uart variables
//	parameter clks_per_byte = clk_freq / baudrate;
	reg [2:0] state = IDLE;
	reg [24:0] clk_count = 0;
	reg [3:0] bit_index = 0;

endmodule
