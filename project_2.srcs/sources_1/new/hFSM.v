module hFSM (
    input clk,
    input reset,
    input [15:0] data,
    output reg [3:0] digit,
    output reg [3:0] anode
);

    reg [1:0] digit_counter;
    always @(posedge clk or posedge reset) begin
        if (reset)
            digit_counter <= 2'b00;
        else
            digit_counter <= digit_counter + 1;
    end
    
    always @(*) begin
        // Valores por defecto 0:encendido y 1:apagado
        digit = 4'b0000;
        anode = 4'b1111;
        case(digit_counter)
            2'b00: begin
                digit = data[15:12];  // Dígito más significativo
                anode = 4'b0111;      // Display de la izquierda
            end
            2'b01: begin
                digit = data[11:8];
                anode = 4'b1011;
            end
            2'b10: begin
                digit = data[7:4];
                anode = 4'b1101;
            end
            2'b11: begin
                digit = data[3:0];    // Dígito menos significativo
                anode = 4'b1110;      // Display de la derecha
            end
        endcase
    end
endmodule


