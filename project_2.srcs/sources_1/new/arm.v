`timescale 1ns / 1ps

module arm (
	clk,
	reset,
	MemWrite,
	Adr,
	WriteData,
	ReadData
);
	input wire clk;
	input wire reset;
	output wire MemWrite;
	output wire [31:0] Adr;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;

	wire [31:0] Instr;
	wire [3:0] ALUFlags;
	wire PCWrite;
	wire RegWrite;
	wire IRWrite;
	wire AdrSrc;
	wire [1:0] RegSrc;
	wire ALUSrcA;
	wire [1:0] ALUSrcB;
	wire [1:0] ImmSrc;
	wire [3:0] ALUControl;
	wire [1:0] ResultSrc;
	wire isMul;
	wire isUMULL;
	wire isSMULL;  
	wire isMul64;
	wire isHi;
	wire isSDIV;
	wire isUDIV;  
	wire isDiv;
	wire isMul;
	
	assign isMul   = (Instr[27:24] == 4'b0000) && (Instr[23] == 1'b0) && (Instr[7:4] == 4'b1001);
    assign isUMULL = (Instr[27:24] == 4'b0000) && (Instr[23:22] == 2'b10)&& (Instr[7:4] == 4'b1001);    
    assign isSMULL = (Instr[27:24] == 4'b0000) && (Instr[23:22] == 2'b11) && (Instr[7:4] == 4'b1001);
    assign isMul64 = isSMULL || isUMULL;
    assign isSDIV = (Instr[27:22] == 6'b011100) && (Instr[21:20] == 2'b01)&& (Instr[7:4] == 4'b0001);
    assign isUDIV = (Instr[27:22] == 6'b011100) && (Instr[21:20] == 2'b11) && (Instr[7:4] == 4'b0001);
    assign isDiv = isUDIV || isSDIV; 
	
	controller c(
		.clk(clk),
		.reset(reset),
		.Instr(Instr[31:12]),
		.isMul(isMul),
		.ALUFlags(ALUFlags),
		.PCWrite(PCWrite),
		.MemWrite(MemWrite),
		.RegWrite(RegWrite),
		.IRWrite(IRWrite),
		.AdrSrc(AdrSrc),
		.RegSrc(RegSrc),
		.ALUSrcA(ALUSrcA),
		.ALUSrcB(ALUSrcB),
		.ResultSrc(ResultSrc),
		.ImmSrc(ImmSrc),
		.ALUControl(ALUControl),
		.isMul64(isMul64),
		.isHi(isHi),
		.isDiv(isDiv),
		.wa3(wa3)
	);
	
	datapath dp(
		.clk(clk),
		.reset(reset),
		.Adr(Adr),
		.WriteData(WriteData),
		.ReadData(ReadData),
		.Instr(Instr),
		.ALUFlags(ALUFlags),
		.PCWrite(PCWrite),
		.RegWrite(RegWrite),
		.IRWrite(IRWrite),
		.AdrSrc(AdrSrc),
		.RegSrc(RegSrc),
		.ALUSrcA(ALUSrcA),
		.ALUSrcB(ALUSrcB),
		.ResultSrc(ResultSrc),
		.ImmSrc(ImmSrc),
		.ALUControl(ALUControl),
		.isSMULL(isSMULL),
		.isHi(isHi),
		.isMul(isMul),
		.isMul64(isMul64),
		.isDiv(isDiv),
		.isSDIV(isSDIV),
		.wa3(wa3)
	);
endmodule

