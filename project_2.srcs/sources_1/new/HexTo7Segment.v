module HexTo7Segment (
    input [3:0] digit,  // 4-bit hexadecimal input
    output reg [7:0] catode  // 7-segment output (7 segments + DP)
);
    always @(*) begin
        case(digit)
            //                abcdefg.  0:encendido
            4'h0: catode = 8'b00000011;
            4'h1: catode = 8'b10011111;
            4'h2: catode = 8'b00100101;
            4'h3: catode = 8'b00001101;
            4'h4: catode = 8'b10011001;
            4'h5: catode = 8'b01001001;
            4'h6: catode = 8'b01000001;
            4'h7: catode = 8'b00011111;
            4'h8: catode = 8'b00000001;
            4'h9: catode = 8'b00011001;
            4'hA: catode = 8'b00010001;
            4'hB: catode = 8'b11000001;
            4'hC: catode = 8'b01100011;
            4'hD: catode = 8'b10000101;
            4'hE: catode = 8'b01100001;
            4'hF: catode = 8'b01110001;
            default: catode = 8'b11111111;  // Blank display
        endcase
    end
endmodule



