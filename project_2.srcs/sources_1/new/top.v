`timescale 1ns / 1ps

module top(
    input  wire        clk,
    input  wire        reset,
    output wire [7:0]  catode,
    output wire [3:0]  anode
);
    wire [31:0] ReadData;
    wire [31:0] WriteData;
    wire [31:0] Adr;
    wire MemWrite;
    wire clk_slow;
    
    clock_divider2 slow_clk(
        .in_clk(clk),
        .out_clk(clk_slow)  
    );
   
    arm u_arm (
        .clk(clk),//Clock_lento
        .reset(reset),
        .MemWrite(MemWrite),
        .Adr(Adr),
        .WriteData(WriteData),
        .ReadData(ReadData)
    );

    mem u_mem (
        .clk (clk),//clock lento
        .we  (MemWrite),
        .a   (Adr),
        .wd  (WriteData),
        .rd  (ReadData)
    );

    wire [15:0] hex_value = Adr[31:0];//OUTPUT Del Basys

    hex_display u_disp (
        .clk    (clk),//clock normal
        .reset  (reset),
        .data   (hex_value),
        .catode (catode),
        .anode  (anode)
    );

endmodule


