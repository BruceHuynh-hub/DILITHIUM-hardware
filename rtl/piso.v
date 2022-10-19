module piso(
        clk,
        en,
        sel,
        input,
        output
    );
    parameter [31:0]n  = 1344;
    parameter [31:0]m  = 64;
    input clk;
    input en;
    input sel;
    input [( n - 1 ):0] input;
    output [( m - 1 ):0] output;
    localparam regamount  = ( n / m );
    genvar i;
    reg [0:( ( n / m ) - 1 )]mux;
    reg [0:( ( n / m ) - 1 )]reg;
    assign mux[( ( n / m ) - 1 )] = input;
    generate
        for ( i = 0 ; ( i <= ( ( n / m ) - 2 ) ) ; i = ( i + 1 ) )
        begin : mux_gen
            always @ (  sel or  input or  reg)
            begin
                if ( sel == 1'b1 ) 
                begin
                    mux[i] <= input[( n - 1 ):( n - m )];
                end
                else
                begin 
                    if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/piso.vhd:36 
                    begin
                        mux[i] <= reg[( i + 1 )];
                    end
                end
            end
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= ( ( n / m ) - 1 ) ) ; i = ( i + 1 ) )
        begin : regX_gen
            always @ (  posedge clk)
            begin : regX
                if ( clk == 1'b1 ) 
                begin
                    if ( en == 1'b1 ) 
                    begin
                        reg[i] <= mux[i];
                    end
                end
            end
        end
    endgenerate
    assign output = reg[0];
endmodule 
