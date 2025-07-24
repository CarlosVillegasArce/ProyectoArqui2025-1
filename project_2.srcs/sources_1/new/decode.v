`timescale 1ns / 1ps
/*
module decode (
	clk,
	reset,
	Op,
	Funct,
	Rd,
	FlagW,
	PCS,
	NextPC,
	RegW,
	MemW,
	IRWrite,
	AdrSrc,
	ResultSrc,
	ALUSrcA,
	ALUSrcB,
	ImmSrc,
	RegSrc,
	ALUControl,
	isMul,
	isMul64,
	isHi,
	isDiv
);
	input wire clk;
	input wire reset;
	input wire [1:0] Op;
	input wire [5:0] Funct;
	input wire [3:0] Rd;
	input wire isMul;
	output reg [1:0] FlagW;
	output wire PCS;
	output wire NextPC;
	output wire RegW;
	output wire MemW;
	output wire IRWrite;
	output wire AdrSrc;
	output wire [1:0] ResultSrc;
	output wire ALUSrcA;
	output wire [1:0] ALUSrcB;
	output wire [1:0] ImmSrc;
	output wire [1:0] RegSrc;
	output reg [2:0] ALUControl;
	output wire isHi;
	input wire isMul64;
	input wire isDiv;
	wire Branch;
	wire ALUOp;
     
	mainfsm fsm(
		.clk(clk),
		.reset(reset),
		.Op(Op),
		.Funct(Funct),
		.IRWrite(IRWrite),
		.AdrSrc(AdrSrc),
		.ALUSrcA(ALUSrcA),
		.ALUSrcB(ALUSrcB),
		.ResultSrc(ResultSrc),
		.NextPC(NextPC),
		.RegW(RegW),
		.MemW(MemW),
		.Branch(Branch),
		.ALUOp(ALUOp),
		.isMul(isMul),
		.isMul64(isMul64),
		.isHi(isHi),
		.isDiv(isDiv)
	);

 	always @(*) begin
        if (ALUOp) begin
            if(isDiv) begin
                ALUControl = 3'b110;
                end
            else if(isMul64) begin
              ALUControl = 3'b100;
        end else if (isMul) begin
            ALUControl = 3'b111;
            end else begin
                case (Funct[4:1])
                    4'b0100: ALUControl = 3'b000;
                    4'b0010: ALUControl = 3'b001;
                    4'b0000: ALUControl = 3'b010;
                    4'b1100: ALUControl = 3'b011;
                    default: ALUControl = 3'bxxx;
                endcase
            end
		FlagW[1] = Funct[0];
		FlagW[0] = Funct[0] & ((ALUControl == 3'b000) | (ALUControl == 3'b001));
	end else begin
		ALUControl = 3'b000;
		FlagW = 2'b00;
	end
end
	assign ImmSrc = Op;
  	assign RegSrc[1] = (isDiv) ? (Op == 2'b00) : (Op == 2'b01); // RegSrc1 is 1 for STR, 0 for DP and the rest don't care
	assign RegSrc[0] = (Op == 2'b10); // RegSrc0 is only 1 for B instructions
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule*/

module decode (
	clk,
	reset,
	Op,
	Funct,
	Rd,
	FlagW,
	PCS,
	NextPC,
	RegW,
	MemW,
	IRWrite,
	AdrSrc,
	ResultSrc,
	ALUSrcA,
	ALUSrcB,
	ImmSrc,
	RegSrc,
	ALUControl,
	isMul,
	isMul64,
	isHi,
	isDiv
);
	input wire clk;
	input wire reset;
	input wire [1:0] Op;
	input wire [5:0] Funct;
	input wire [3:0] Rd;
	input wire isMul;
	output reg [1:0] FlagW;
	output wire PCS;
	output wire NextPC;
	output wire RegW;
	output wire MemW;
	output wire IRWrite;
	output wire AdrSrc;
	output wire [1:0] ResultSrc;
	output wire ALUSrcA;
	output wire [1:0] ALUSrcB;
	output wire [1:0] ImmSrc;
	output wire [1:0] RegSrc;
	output reg [3:0] ALUControl;
	output wire isHi;
	input wire isMul64;
	input wire isDiv;
	wire Branch;
	wire ALUOp;
     
	mainfsm fsm(
		.clk(clk),
		.reset(reset),
		.Op(Op),
		.Funct(Funct),
		.IRWrite(IRWrite),
		.AdrSrc(AdrSrc),
		.ALUSrcA(ALUSrcA),
		.ALUSrcB(ALUSrcB),
		.ResultSrc(ResultSrc),
		.NextPC(NextPC),
		.RegW(RegW),
		.MemW(MemW),
		.Branch(Branch),
		.ALUOp(ALUOp),
		.isMul(isMul),
		.isMul64(isMul64),
		.isHi(isHi),
		.isDiv(isDiv)
	);

//ALUDecoder
 always @(*) begin
    if (ALUOp) begin
        if (isDiv) begin
            ALUControl = 4'b1000; // SDIV
        end else if (isMul64) begin
            ALUControl = 4'b0110; // SMULL / UMULL
        end else if (isMul) begin
            ALUControl = 4'b0100; // MUL
        end else begin
            case (Funct[4:1])
                4'b0100: ALUControl = 4'b0000; // ADD
                4'b0010: ALUControl = 4'b0001; // SUB
                4'b0000: ALUControl = 4'b0010; // AND
                4'b1100: ALUControl = 4'b0011; // OR
                4'b1101: ALUControl = 4'b1001; // MOV
                4'b1111: ALUControl = 4'b1010; // MVN
                4'b1011: ALUControl = 4'b1101; // FP ADD
                4'b1110: ALUControl = 4'b1110; // FP MUL
                default: ALUControl = 4'bxxxx;
            endcase
        end
        FlagW[1] = Funct[0];
        FlagW[0] = Funct[0] & ((ALUControl == 4'b0000) | (ALUControl == 4'b0001));
    end else begin
        ALUControl = 4'b0000;
        FlagW = 2'b00;
    end
end
	assign ImmSrc = Op;
  	assign RegSrc[1] = (isDiv) ? (Op == 2'b00) : (Op == 2'b01); // RegSrc1 is 1 for STR, 0 for DP and the rest don't care
	assign RegSrc[0] = (Op == 2'b10); // RegSrc0 is only 1 for B instructions
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule





