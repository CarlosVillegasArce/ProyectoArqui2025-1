`timescale 1ns / 1ps

module mux3 (
	d0,
	d1,
	d2,
	s,//ALUSrcB[1:0]
	y
);
	parameter WIDTH = 8;
	input wire [WIDTH - 1:0] d0;
	input wire [WIDTH - 1:0] d1;
	input wire [WIDTH - 1:0] d2;
	input wire [1:0] s;
	output reg [WIDTH - 1:0] y;

    always @(*) begin
        case (s)
            2'b00: y = d0;
            2'b01: y = d1;
            2'b10: y = d2;
            default: y = {WIDTH{1'b0}}; // default: cero
        endcase
    end
endmodule