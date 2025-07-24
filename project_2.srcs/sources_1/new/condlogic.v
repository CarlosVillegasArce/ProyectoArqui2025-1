`timescale 1ns / 1ps

module condlogic (
	clk,
	reset,
	Cond,
	ALUFlags,
	FlagW,
	PCS,
	NextPC,
	RegW,
	MemW,
	PCWrite,
	RegWrite,
	MemWrite
);
	input wire clk;
	input wire reset;
	input wire [3:0] Cond;
	input wire [3:0] ALUFlags;
	input wire [1:0] FlagW;
	input wire PCS;
	input wire NextPC;
	input wire RegW;
	input wire MemW;
	
	output wire PCWrite;
	output wire RegWrite;
	output wire MemWrite;
	
	wire [1:0] FlagWrite;
	wire [3:0] Flags;
	wire CondEx;
	
	// ADD CODE HERE
	wire PCIntermedio;
	wire CondExNew;
	
	//Declarar condictionalcheck
    condcheck cc (
      .Cond(Cond),
      .Flags(Flags),
      .CondEx(CondEx)
    );
    
    //Flop AluFlags-Flags
    flop2c #(2) flagreg1(
        .clk(clk),
        .reset(reset),
        .we(FlagWrite[1]),
        .d(ALUFlags[3:2]),
        .q(Flags[3:2])
    );

    //Flop AluFlags-Flags
    flop2c #(2) flagreg0(
        .clk(clk),
        .reset(reset),
        .we(FlagWrite[0]),
        .d(ALUFlags[1:0]),
        .q(Flags[1:0])
    );

    //flop para el condEX
    flopr #(1) flopcondEx(
        .clk(clk),
        .reset(reset),
        .d(CondEx),
        .q(CondExNew)
     );
	
	//AND
	assign FlagWrite= FlagW & {2 {CondEx}};
    assign RegWrite = RegW & CondExNew;//And regwrite
    assign MemWrite = MemW & CondExNew;//And memwrite
    assign PCIntermedio = PCS & CondExNew;//aand PCS y CondEx
    assign PCWrite = PCIntermedio | NextPC;//PCWrite = PCintermedio or NExtPC
    
endmodule
