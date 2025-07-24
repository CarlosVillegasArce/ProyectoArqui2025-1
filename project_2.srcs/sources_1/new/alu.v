
module alu(
    input [31:0] a, b,
    input [3:0] ALUControl,  // Ahora 4 bits
    input wire isSMULL,
    input wire isSDIV,
    output reg [31:0] ALUResult,
    output reg [31:0] ALUResulthi,
    output wire [3:0] ALUFlags
);

    wire neg, zero, carry, overflow;
    wire [31:0] condinvb;
    wire [32:0] sum;

    assign condinvb = ALUControl[0] ? ~b : b;
    assign sum = a + condinvb + ALUControl[0];

    // Resultado punto flotante
    wire [31:0] sumaFP;
    wire [31:0] mulFP;

    AddFP fpadd(.a(a), .b(b), .f(sumaFP));
    MulFP fpmul(.a(a), .b(b), .f(mulFP));

    always @(*) begin
        ALUResult = 32'd0;
        ALUResulthi = 32'd0;
        case (ALUControl)
            4'b0000: ALUResult = a + b;         // ADD
            4'b0001: ALUResult = a - b;         // SUB
            4'b0010: ALUResult = a & b;         // AND
            4'b0011: ALUResult = a | b;         // OR /ORR
            4'b0100: ALUResult = a * b;         // MUL (32-bit)
            4'b0101: begin                      // UMULL
                {ALUResulthi, ALUResult} = a * b;
            end
            4'b0110: begin                      // SMULL
                case ({a[31], b[31]})
                    2'b00: {ALUResulthi, ALUResult} = a * b;
                    2'b01: {ALUResulthi, ALUResult} = ~((a)*(~b+1)) + 1;
                    2'b10: {ALUResulthi, ALUResult} = ~((~a+1)*(b)) + 1;
                    2'b11: {ALUResulthi, ALUResult} = (~a+1) * (~b+1);
                endcase
            end
            4'b0111: ALUResult = a / b;         // UDIV
            4'b1000: begin                      // SDIV
                case ({a[31], b[31]})
                    2'b00: ALUResult = a / b;
                    2'b01: ALUResult = ~((a)/(~b+1)) + 1;
                    2'b10: ALUResult = ~((~a+1)/(b)) + 1;
                    2'b11: ALUResult = (~a+1) / (~b+1);
                endcase
            end
            4'b1001: ALUResult = b;             // MOV
            4'b1010: ALUResult = ~b;            // MVN 
            4'b1101: ALUResult = sumaFP;        // FP ADD*/
            4'b1110: ALUResult = mulFP;         // FP MUL
            default: begin
                ALUResult = 32'd0;
                ALUResulthi = 32'd0;
            end
        endcase
    end
    assign neg = ALUResult[31];
    assign zero = (ALUResult == 32'd0);
    assign carry = (ALUControl[3:0] == 4'b0000) && sum[32];
    assign overflow = (ALUControl[3:0] == 4'b0000) &&
                      ~(a[31] ^ b[31]) & (a[31] ^ sum[31]);

    assign ALUFlags = {neg, zero, carry, overflow};
endmodule


