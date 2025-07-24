`timescale 1ns / 1ps

module mem (
	clk,
	we,
	a,
	wd,
	rd
);
	input wire clk;
	input wire we;
	input wire [31:0] a;
	input wire [31:0] wd;
	output wire [31:0] rd;
	reg [31:0] RAM [63:0];
	initial $readmemh("memfile.dat", RAM);
	assign rd = RAM[a[31:2]]; // word aligned
	always @(posedge clk)
		if (we)
			RAM[a[31:2]] <= wd;
endmodule
/*
module mem (
    input wire clk,
    input wire we,
    input wire [31:0] a,
    input wire [31:0] wd,
    output wire [31:0] rd
);
    reg [31:0] RAM [0:63];

    initial begin
    
    RAM[0]  = 32'hE04F000F;
    RAM[1]  = 32'hE2802005;
    RAM[2]  = 32'hE2403002;
    RAM[3]  = 32'hE0C45392;
    RAM[4]  = 32'hE5805064;
    RAM[5]  = 32'hE5804068;

        
        RAM[0]  = 32'hE3A00080;
        RAM[1]  = 32'hE3A0143D;
        RAM[2]  = 32'hE3A02607;
        RAM[3]  = 32'hE0811002;
        RAM[4]  = 32'hE3A02101;
        RAM[5]  = 32'hE3A03843;
        RAM[6]  = 32'hE3A04903;
        RAM[7]  = 32'hE0822003;
        RAM[8]  = 32'hE0822004;
        RAM[9]  = 32'hE3A0343D;
        RAM[10] = 32'hE3A0473E;
        RAM[11] = 32'hE0833004;
        RAM[12] = 32'hE3A044BE;
        RAM[13] = 32'hE3A0589E;
        RAM[14] = 32'hE0844005;
        RAM[15] = 32'hE1A05003;
        RAM[16] = 32'hE3A06C01;
        RAM[17] = 32'hE5865000;
        RAM[18] = 32'h00000000;
        RAM[19] = 32'h00000000;
        
    end

    // Lectura
    assign rd = RAM[a[31:2]];

    // Escritura
    always @(posedge clk) begin
        if (we)
            RAM[a[31:2]] <= wd;
    end
endmodule */
