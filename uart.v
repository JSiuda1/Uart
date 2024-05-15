module uart #(parameter baudrate = 115200)
(
	input clk,
	input data_ready,
	input data_count,
	output output_tx,
	output reg [1:0] led
);

	wire test_output_tx, test_led;
	wire send;
	// wire data;
	reg [7:0] data = 0;
	
	// button_counter bc(clk, data_count, data);
	send_button sb(clk, data_ready, send);
	uart_tx tx(clk, send, test_output_tx);

	assign output_tx = test_output_tx;

endmodule 