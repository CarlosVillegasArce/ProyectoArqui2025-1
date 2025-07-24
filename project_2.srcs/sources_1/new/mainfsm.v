`timescale 1ns / 1ps

module mainfsm (
	clk,
	reset,
	Op,
	Funct,
	IRWrite,
	AdrSrc,
	ALUSrcA,
	ALUSrcB,
	ResultSrc,
	NextPC,
	RegW,
	MemW,
	Branch,
	ALUOp,
	isMul,
	isMul64,
	isHi,
	isDiv
);

	input wire clk;
	input wire reset;
	
    input wire isMul;
    input wire isMul64;
    input wire isDiv;
    
	input wire [1:0] Op;
	input wire [5:0] Funct;
	output wire IRWrite;
	output wire AdrSrc;
	output wire ALUSrcA;
	output wire [1:0] ALUSrcB;
	output wire [1:0] ResultSrc;
	output wire NextPC;
	output wire RegW;
	output wire MemW;
	output wire Branch;
	output wire ALUOp;
	output reg isHi;

	reg [3:0] state;
	reg [3:0] nextstate;
	reg [11:0] controls;
	
	localparam [3:0] FETCH = 0;
	localparam [3:0] DECODE = 1;
	localparam [3:0] MEMADR = 2;
    localparam [3:0] MEMREAD =3;
	localparam [3:0] MEMWB =4;
	localparam [3:0] MEMWRITE =5;
    localparam [3:0] EXECUTER = 6;
	localparam [3:0] EXECUTEI = 7;
	localparam [3:0] ALUWB =8;
	localparam [3:0] BRANCH = 9;
	localparam [3:0] UNKNOWN = 10;
	localparam [3:0] EXECUTEMUL = 11;
    localparam [3:0] EXECUTEMUL64 = 12;
    localparam [3:0] MULWB_LO = 13;
    localparam [3:0] MULWB_HI = 14;
    localparam [3:0] EXECUTEDIV = 15;
	// state register
	always @(posedge clk or posedge reset)begin
		if (reset)
			state <= FETCH;
		else
			state <= nextstate;
	end

	always @(*)
		casex (state)
			FETCH: nextstate = DECODE;
			DECODE:
			     if (isDiv)
					 nextstate = EXECUTEDIV;
				else case (Op)
					2'b00:
					   if (isMul64)
					       nextstate = EXECUTEMUL64;
					   else if(isMul)
					       nextstate = EXECUTEMUL;
						else if (Funct[5])
							nextstate = EXECUTEI;// tipo I
						else
							nextstate = EXECUTER;// tipo R
					2'b01: nextstate = MEMADR;// LDR/STR
					2'b10: nextstate = BRANCH;
					default: nextstate = FETCH;
				endcase
			MEMADR:    nextstate = (Funct[0]) ? MEMWRITE : MEMREAD; // STR vs LDR
			MEMREAD:   nextstate = MEMWB;
			MEMWB:     nextstate = FETCH;
			MEMWRITE:  nextstate = FETCH;
			EXECUTER:  nextstate = ALUWB;
			EXECUTEI:  nextstate = ALUWB;
			ALUWB:     nextstate = FETCH;
			BRANCH:    nextstate = FETCH;
			EXECUTEMUL: nextstate = ALUWB;
			EXECUTEMUL64: nextstate = MULWB_LO;
			MULWB_LO: nextstate = MULWB_HI;
			MULWB_HI: nextstate = FETCH;
			EXECUTEDIV: nextstate = ALUWB;
			default:   nextstate = FETCH;
		endcase

	always @(*) begin
	    isHi = 1'b0;
		case (state)      //          NBMRIARsAAbO
			FETCH:     controls = 12'b100010101100; // PC ← PC+4, IRWrite //0
			 //                       NBMRIARsAAbO
			DECODE:    controls = 12'b000000101100;    
			 //                       NBMRIARsAAbO                     //1
			MEMADR:    controls = 12'b000000000010; // ALU = Rn + Imm       //2
			// //                     NBMRIARsAAbO
			MEMREAD:   controls = 12'b000001000000; // leer memoria         //3  adrsrc
			// //                     NBMRIARsAAbO
			MEMWB:     controls = 12'b000100010000; // RegW=1, ResultSrc=01 //4
			// //                     NBMRIARsAAbO
			MEMWRITE:  controls = 12'b001001000000; // MemW=1, AdrSrc=1     //5  adrsrc
			// //                     NBMRIARsAAbO
			EXECUTER:  controls = 12'b000000000001; // ALU = Rn op Rm       //6
			// //                     NBMRIARsAAbO
			EXECUTEI:  controls = 12'b000000000011; // ALU = Rn op Imm      //7
			// //                     NBMRIARsAAbO
			ALUWB:     controls = 12'b000100000000; // RegW=1               //8
			// //                     NBMRIARsAAbO
			BRANCH:    controls = 12'b010000100010; // PC = R15 + offset    //9
			
			EXECUTEMUL: controls = 12'b000000000001; // Solo activa ALUOp
			
			EXECUTEMUL64: controls = 12'b000000000001; // Solo activa ALUOp
			
			MULWB_LO: begin controls = 12'b000100000000; isHi = 1'b0; end// Solo activa ALUOp ResultSrc = 00
			
			MULWB_HI: begin controls = 12'b000100110000; isHi = 1'b1; end// Solo activa ALUOp ResultSrc = 11
            
            EXECUTEDIV: controls = 12'b000000000001; // Solo activa ALUOp
            
			default:   controls = 12'b000000000000;
		endcase
	end    //                                     posicion6
	      //  0      0       0     0       0       0       00          0       00      0
	assign {NextPC, Branch, MemW, RegW, IRWrite, AdrSrc, ResultSrc, ALUSrcA, ALUSrcB, ALUOp} = controls;
endmodule
