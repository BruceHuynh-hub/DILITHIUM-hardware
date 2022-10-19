module sipo(
        clk,
        en,
        input,
        output
    );
    parameter [31:0]n  = 1344;
    parameter [31:0]m  = 64;
    input clk;
    input en;
    input [( m - 1 ):0] input;
    output [( n - 1 ):0] output;
    localparam regamount  = ( n / m );
    genvar i;
    reg [0:( ( n / m ) - 1 )]reg;
    generate
        for ( i = ( ( n / m ) - 1 ) ; ( i >= 0 ) ; i = ( i - 1 ) )
        begin : output_gen
            assign output[( ( m * i ) + ( m - 1 ) ):( m * i )] = reg[( ( n / m ) - 1 )];
        end
    endgenerate
    generate
        for ( i = ( ( n / m ) - 2 ) ; ( i >= 0 ) ; i = ( i - 1 ) )
        begin : regX_gen
            always @ (  posedge clk)
            begin : regX
                if ( clk == 1'b1 ) 
                begin
                    if ( en == 1'b1 ) 
                    begin
                        reg[i] <= reg[( i + 1 )];
                    end
                end
            end
        end
    endgenerate
    always @ (  posedge clk)
    begin : regLast
        if ( clk == 1'b1 ) 
        begin
            if ( en == 1'b1 ) 
            begin
                reg[( ( n / m ) - 1 )] <= input;
            end
        end
    end
endmodule 
