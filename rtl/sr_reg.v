module sr_reg(
        rst,
        clk,
        set,
        clr,
        data_out
    );
    parameter init  = 1'b1;
    input rst;
    input clk;
    input set;
    input clr;
    output data_out;
endmodule 
