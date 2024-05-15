module uart #(parameter baudrate = 115200)
(
	input clk,
//	input [7:0] data_byte
	input data_ready,
	input data_count,
	output output_tx,
	output reg [1:0] led
);
	wire test_output_tx, test_led;
	reg [7:0] data_byte = 0;
	uart_tx tx(clk, data_ready, data_count, test_output_tx, test_led);

	assign output_tx = test_output_tx;
//	assign led = test_led;
	
endmodule 