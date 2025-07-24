module clock_divider(in_clk,
out_clk);
    input in_clk;
    output reg out_clk;
    reg [17:0] counter = 1;
    always @(posedge in_clk) begin
        counter <= counter + 1;
        if (counter == 0) out_clk <= ~out_clk;
    end
 endmodule
 
 
 