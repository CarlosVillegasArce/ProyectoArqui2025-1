`timescale 1ns / 1ps

module top_tb;

    reg clk;
    reg reset;
    wire [7:0] catode;
    wire [3:0] anode;

    // Instancia del módulo top
    top uut (
        .clk(clk),
        .reset(reset),
        .catode(catode),
        .anode(anode)
    );

    // Generador de reloj (100 MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // Estímulos
    initial begin
        // Generar archivo de waveform
        $dumpfile("top_tb.vcd");       // Solo para simuladores que usan VCD (como GTKWave)
        $dumpvars(0, top_tb);

        // Reset inicial
        reset = 1;
        #50;
        reset = 0;

        // Deja correr la simulación por un tiempo suficiente
        #1000000000;

        // Finaliza la simulación
        $finish;
    end

endmodule

