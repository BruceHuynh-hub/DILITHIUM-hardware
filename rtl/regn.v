module regn(
        clk,
        rst,
        en,
        input,
        output
    );
    parameter [31:0]n  = 1600;
    parameter init  = { 1'b0 };
    input clk;
    input rst;
    input en;
    input [( n - 1 ):0] input;
    output [( n - 1 ):0] output;
    reg [( n - 1 ):0]output;
    always @ (  posedge clk)
    begin : gen
        if ( clk == 1'b1 ) 
        begin
            if ( rst == 1'b1 ) 
                output <= init;
            else
            begin 
                if ( en == 1'b1 ) 
                    output <= input;
            end
        end
    end
endmodule 
