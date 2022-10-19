module countern(
        clk,
        rst,
        load,
        en,
        input,
        output
    );
    parameter [31:0]n  = 11;
    parameter [31:0]step  = 1;
    parameter [31:0]style  = 1;
    input clk;
    input rst;
    input load;
    input en;
    input [( n - 1 ):0] input;
    output [( n - 1 ):0] output;
endmodule 
