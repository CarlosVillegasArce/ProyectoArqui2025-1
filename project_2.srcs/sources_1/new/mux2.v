`timescale 1ns / 1ps

module mux2 (
d0,
d1,
s,//ALUSrcA [1:0]
y
);
parameter WIDTH = 8;
input wire [WIDTH - 1:0] d0;
input wire [WIDTH - 1:0] d1;
input  wire [1:0] s;
output wire [WIDTH - 1:0] y;

assign y = (s[0]) ? d1 : d0;
endmodule
