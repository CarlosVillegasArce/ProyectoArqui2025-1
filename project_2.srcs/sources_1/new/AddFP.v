`timescale 1ns / 1ps

module AddFP(
  input  [31:0] a, b,
  output reg [31:0] f
);

  wire sign1 = a[31];
  wire sign2 = b[31];
  
  wire [7:0] exponent1 = a[30:23];
  wire [7:0] exponent2 = b[30:23];

  wire [23:0] mantissa1 = (exponent1 == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};//agregamos el valor oculto
  wire [23:0] mantissa2 = (exponent2 == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

  reg [23:0] mantissa_a, mantissa_b;
  reg [7:0] exponent_result;
  reg [24:0] mantissa_result; // Para overflow
  reg result_sign;
  reg [4:0] shift_count;

  reg [22:0] result_fraction;

  always @(*) begin
    if (exponent1 > exponent2) begin
      mantissa_a = mantissa1;
      mantissa_b = mantissa2 >> (exponent1 - exponent2);
      exponent_result = exponent1;
    end else begin
      mantissa_a = mantissa2;
      mantissa_b = mantissa1 >> (exponent2 - exponent1);
      exponent_result = exponent2;
    end

    if (sign1 == sign2) begin
      mantissa_result = mantissa_a + mantissa_b;
      result_sign = sign1;
      
      if (mantissa_result[24]) begin
        mantissa_result = mantissa_result >> 1;
        exponent_result = exponent_result + 1;
      end
      
    end else begin
      if (mantissa_a >= mantissa_b) begin
        mantissa_result = mantissa_a - mantissa_b;//restamos
        result_sign = (exponent1 >= exponent2) ? sign1 : sign2;//si el exponente de A es mayor a exponente de b colocamos el signo de A
      end else begin
        mantissa_result = mantissa_b - mantissa_a;
        result_sign = (exponent1 >= exponent2) ? sign2 : sign1;
      end
      
      shift_count = 0;
      
      while (mantissa_result[23] == 0 && exponent_result > 0 && mantissa_result != 0) begin
        mantissa_result = mantissa_result << 1;
        exponent_result = exponent_result - 1;
        shift_count = shift_count + 1;
      end
    end
    result_fraction = mantissa_result[22:0]; // Sin bit oculto
    f = (mantissa_result == 0) ? 32'b0 : {result_sign, exponent_result, result_fraction};
  end

endmodule
