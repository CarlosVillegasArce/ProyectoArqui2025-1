/*module MulFP(
  input [31:0] a, b,
  output reg [31:0] f
);
  wire sign1 = a[31], sign2 = b[31];
  wire [7:0] exponent1 = a[30:23], exponent2 = b[30:23];
  wire [22:0] fraction1 = a[22:0], fraction2 = b[22:0];
  wire [23:0] mantissa1 = {1'b1, fraction1}, mantissa2 = {1'b1, fraction2};

  reg [47:0] product_mantissa;
  reg [7:0] exponent_result;
  reg result_sign;
  reg [22:0] result_fraction;

  always @(*) begin
    result_sign = sign1 ^ sign2;
    exponent_result = exponent1 + exponent2 - 8'd127;
    product_mantissa = mantissa1 * mantissa2;

    if (product_mantissa[47]) begin
      product_mantissa = product_mantissa >> 1;
      exponent_result = exponent_result + 1;
    end

    result_fraction = product_mantissa[46:24];
    f = {result_sign, exponent_result, result_fraction};
  end
endmodule*/
`timescale 1ns / 1ps

module MulFP(
  input  [31:0] a, b,
  output reg [31:0] f
);
  wire sign_a = a[31], sign_b = b[31];
  wire [7:0] exp_a = a[30:23], exp_b = b[30:23];
  wire [22:0] frac_a = a[22:0], frac_b = b[22:0];

  wire [23:0] mant_a = (exp_a == 0) ? {1'b0, frac_a} : {1'b1, frac_a};
  wire [23:0] mant_b = (exp_b == 0) ? {1'b0, frac_b} : {1'b1, frac_b};

  reg [47:0] product_mant;
  reg [7:0] exp_result;
  reg sign_result;
  reg [22:0] frac_result;

  always @(*) begin
    if (a[30:0] == 0 || b[30:0] == 0) begin
      f = 32'b0;  // Resultado es 0
    end else begin
      sign_result = sign_a ^ sign_b;
      exp_result = exp_a + exp_b - 8'd127;
      product_mant = mant_a * mant_b;

      if (product_mant[47]) begin
        product_mant = product_mant >> 1;
        exp_result = exp_result + 1;
      end

      if (exp_result >= 8'hFF) begin
        f = {sign_result, 8'hFF, 23'b0};
      end else if (exp_result <= 0) begin
        f = {sign_result, 8'b0, 23'b0};
      end else begin
        frac_result = product_mant[46:24];  // 23 bits después de normalizar
        f = {sign_result, exp_result, frac_result};
      end
    end
  end
endmodule
