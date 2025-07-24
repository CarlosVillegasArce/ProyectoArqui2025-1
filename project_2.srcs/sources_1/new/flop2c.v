`timescale 1ns / 1ps

module flop2c(
	clk,
	reset,
	we,
	d,
	q
);
	parameter WIDTH = 8;
	input wire clk;
	input wire reset;
	input wire we;
	input wire [WIDTH - 1:0] d;
	output reg [WIDTH - 1:0] q;
	always @(posedge clk or posedge reset) begin
		if (reset)
			q <= 0;
		else if (we)
			q <= d;
	end
endmodule
