`timescale 1ns / 1ps

module datapath (
	clk,
	reset,
	Adr,
	WriteData,
	ReadData,
	Instr,
	ALUFlags,
	PCWrite,
	RegWrite,
	IRWrite,
	AdrSrc,
	RegSrc,
	ALUSrcA,
	ALUSrcB,
	ResultSrc,
	ImmSrc,
	ALUControl,
	isSMULL,
	isHi,
	isMul,
	isMul64,
	isDiv,
	isSDIV,
	wa3
);
	input wire clk;
	input wire reset;
	output wire [31:0] Adr;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;
	output wire [31:0] Instr;
	output wire [3:0] ALUFlags;
	input wire PCWrite;
	input wire RegWrite;
	input wire IRWrite;
	input wire AdrSrc;
	input wire [1:0] RegSrc;
	input wire ALUSrcA;
	input wire [1:0] ALUSrcB;
	input wire [1:0] ResultSrc;
	input wire [1:0] ImmSrc;
	input wire [3:0] ALUControl;
	wire [31:0] PCNext;
	wire [31:0] PC;
	wire [31:0] ExtImm;
	
	wire [31:0] SrcA;
	wire [31:0] SrcB;
	
	input wire isMul;
	input wire isSMULL;
	input wire isHi;
	input wire isMul64;
	input wire isDiv;
	input wire isSDIV;
	
	wire [31:0] ALUResulthi;
	wire [31:0] Result;
	wire [31:0] Data;
	wire [31:0] RD1;
	wire [31:0] RD2;
	wire [31:0] A;
	wire [31:0] ALUResult;
	wire [31:0] ALUOut;
	wire [31:0] ALUOut2;
	wire [3:0] RA1;
	wire [3:0] RA2;

    //Elegir operando 1 y operando 2, depende de si es dp o mul
    wire isnotdp;
    wire hi_mul_div;
    
    wire [3:0] operando1;
    wire [3:0] operando2;
    assign isnotdp = isMul || isMul64 || isDiv; // operacion fuera del tradicional dp
    assign hi_mul_div = isHi || isMul || isDiv; // operacion nueva fuera del dp

	// Your datapath hardware goes below. Instantiate each of the 
	// submodules that you need. Remember that you can reuse hardware
	// from previous labs. Be sure to give your instantiated modules 
	// applicable names such as pcreg (PC register), adrmux 
	// (Address Mux), etc. so that your code is easier to understand.

	// ADD CODE HERE
	wire [31:0] B;
    wire [31:0] A2;
	wire [31:0] B2;
	
	output wire [3:0] wa3;
    assign PCNext = Result;
    
	//flop PC',PC
	flop2c #(32) pcreg(
    .   clk(clk),
        .reset(reset),
        .we(PCWrite),
        .d(PCNext),
        .q(PC)
        );
    
    //mux low-higth
    mux2 #(4) lohi( // MUX de 19:16 o 15 
    .d0(Instr[15:12]),
    .d1(Instr[19:16]),
    .s(hi_mul_div),//entrega a mem
    .y(wa3)
    );
    
   //mux PC-ADR
    mux2 #(32) pcadr( // MUX de 19:16 o 15 
    .d0(PC),
    .d1(Result),
    .s(AdrSrc),//entrega a mem
    .y(Adr)
    );
    
    
    //flop ReadData-Instruccion    
     flop2c #(32) readinst(
        .clk(clk),
        .reset(reset),
        .we(IRWrite),
        .d(ReadData),
        .q(Instr)
        );
    
    //flop ReadData-Data
    flopr #(32) readdata(
         .clk(clk),
        .reset(reset),
        .d(ReadData),
        .q(Data)
        );
    
    //mux antes de mux RA1
    mux2 #(4) ra1muxmux( // MUX de 19:16 o 15 
    .d0(Instr[19:16]),
    .d1(Instr[3:0]),
    .s(isnotdp),
    .y(operando1)
    );
    
    //mux antes de mux RA2
    mux2 #(4) ra2muxmux(
    .d0(Instr[3:0]),
    .d1(Instr[11:8]),
    .s(isnotdp),
    .y(operando2)
    );
    
    
    //mux RA1
    mux2 #(4) ra1mux( // MUX de 19:16 o 15 
    .d0(operando1),
    .d1(4'd15),
    .s(RegSrc[0]),
    .y(RA1)
    );
    
    //mux RA2
    mux2 #(4) ra2mux(
    .d0(operando2),
    .d1(Instr[15:12]),
    .s(RegSrc[1]),
    .y(RA2)
    );
    
    //registerfile
    regfile rf(
        .clk(clk),
        .we3(RegWrite),
        .ra1(RA1),
        .ra2(RA2),
        .wa3(wa3),
        .wd3(Result),
        .r15(Result),
        .rd1(A2),
        .rd2(B2)
    );
    
    //Extend 
    extend ext(
        .Instr(Instr[23:0]),
        .ImmSrc(ImmSrc),
        .ExtImm(ExtImm)
    );
    
    //flopRD1-RD2
    flopr2 #(32) flopR1R2(
        .clk(clk),
        .reset(reset),
        .d0(A2),
        .d1(B2),
        .q0(A),
        .q1(WriteData)
    );
    
    //mux AluSrcA
    muxs1 #(32) srcamux(
        .d0(A),
        .d1(PC),
        .s(ALUSrcA),
        .y(SrcA)
    );
    
    //muxSrcB-3elecciones
    mux3 #(32) srcbmux (
	.d0(WriteData),
	.d1(ExtImm),
	.d2(32'd4),
	.s(ALUSrcB),
	.y(SrcB)
    );
    
    //ALU
    alu alu(
		.a(SrcA),
		.b(SrcB),
		.ALUControl(ALUControl),
		.ALUResult(ALUResult),
		.ALUFlags(ALUFlags),
		.isSMULL(isSMULL),
		.ALUResulthi(ALUResulthi),
		.isSDIV(isSDIV)
	);
	
	//Flop entre ALUResult y ALUOut
	flopr #(32) aluresultreg(
		.clk(clk),
		.reset(reset),
		.d(ALUResult),
		.q(ALUOut)
	);
	
	//Flop entre para ALUResulthi
	flopr #(32) aluresultreg2(
		.clk(clk),
		.reset(reset),
		.d(ALUResulthi),
		.q(ALUOut2)
	);
    	
	//mux4 entre el ALUOut y Result
    mux4 #(32) aluoutresult (
	.d0(ALUOut),
	.d1(Data),
	.d2(ALUResult),
	.d3(ALUOut2),
	.s(ResultSrc),
	.y(Result)
    );
    
endmodule