module uart #(parameter baudrate = 115200)
(
	input clk,
	input send_button,
	input count_button,
	input rx_line,
	output output_tx,
	output [3:0] led
);

	wire test_output_tx, test_led;
	wire send;
	wire [7:0] data;
	
	button_counter bc(clk, count_button, data);
	send_button sb(clk, send_button, send);
	uart_tx tx(clk, data, send, test_output_tx);
	
	wire [7:0] out_data;
	wire done;
	uart_rx rx(clk, rx_line, out_data, done);

	assign output_tx = test_output_tx;
	assign led = out_data;
	

endmodule 