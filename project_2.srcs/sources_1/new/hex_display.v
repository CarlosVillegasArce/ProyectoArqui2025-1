`timescale 1ns / 1ps

module hex_display(
    input clk,
    input reset,
    input [15:0] data,
    output wire [7:0] catode,
    output wire [3:0] anode
);
    wire scl_clk;
    wire [3:0] digit;

    clock_divider sc(
        .in_clk(clk),
        .out_clk(scl_clk)
    );

    hFSM m(
        .clk(scl_clk),
        .reset(reset),
        .data(data),
        .digit(digit),
        .anode(anode)
    );

    HexTo7Segment decoder(
        .digit(digit),
        .catode(catode)
    );
endmodule








