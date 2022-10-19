module sr_reg(
        rst,
        clk,
        set,
        clr,
        output
    );
    parameter init  = 1'b1;
    input rst;
    input clk;
    input set;
    input clr;
    output output;
endmodule 
