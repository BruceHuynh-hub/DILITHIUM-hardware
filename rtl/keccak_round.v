module keccak_round(
        rc,
        rin,
        rout
    );
    inout [63:0] rc;
    inout [1599:0] rin;
    inout [1599:0] rout;
    wire  theta_in;
    wire  theta_out;
    wire  pi_in;
    wire  pi_out;
    wire  rho_in;
    wire  rho_out;
    wire  chi_in;
    wire  chi_out;
    wire  iota_in;
    wire  iota_out;
    wire  round_in;
    wire  round_out;
    wire  sum_sheet;
    genvar i;
    genvar y;
    genvar x;
    generate
        for ( i = 0 ; ( i <= 4 ) ; i = ( i + 1 ) )
        begin : in_outer_gen
        genvar j;
            generate
                for ( j = 0 ; ( j <= 4 ) ; j = ( j + 1 ) )
                begin : in_inner_gen
                    assign round_in[i][j] = edautils_unknown_funcdecl;
                end
            endgenerate
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 4 ) ; i = ( i + 1 ) )
        begin : out_outer_gen
        genvar j;
            generate
                for ( j = 0 ; ( j <= 4 ) ; j = ( j + 1 ) )
                begin : out_inner_gen
                    assign rout[( 1599 - ( 64 * j ) ):( 1536 - ( 64 * j ) )] = round_out[i][j];
                end
            endgenerate
        end
    endgenerate
    assign theta_in = round_in;
    assign pi_in = rho_out;
    assign rho_in = theta_out;
    assign chi_in = pi_out;
    assign iota_in = chi_out;
    assign round_out = iota_out;
    generate
        for ( y = 0 ; ( y <= 4 ) ; y = ( y + 1 ) )
        begin : chi01_gen
        genvar x;
            generate
                for ( x = 0 ; ( x <= 2 ) ; x = ( x + 1 ) )
                begin : chi02_gen
                    generate
                        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
                        begin : chi03_gen
                            assign chi_out[y][x][i] = ( chi_in[y][x][i] ^ (  ~( chi_in[y][( x + 1 )][i]) & chi_in[y][( x + 2 )][i] ) );
                        end
                    endgenerate
                end
            endgenerate
        end
    endgenerate
    generate
        for ( y = 0 ; ( y <= 4 ) ; y = ( y + 1 ) )
        begin : chi11_gen
            generate
                for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
                begin : chi12_gen
                    assign chi_out[y][3][i] = ( chi_in[y][3][i] ^ (  ~( chi_in[y][4][i]) & chi_in[y][0][i] ) );
                end
            endgenerate
        end
    endgenerate
    generate
        for ( y = 0 ; ( y <= 4 ) ; y = ( y + 1 ) )
        begin : chi21_gen
            generate
                for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
                begin : chi21_gen
                    assign chi_out[y][4][i] = ( chi_in[y][4][i] ^ (  ~( chi_in[y][0][i]) & chi_in[y][1][i] ) );
                end
            endgenerate
        end
    endgenerate
    generate
        for ( x = 0 ; ( x <= 4 ) ; x = ( x + 1 ) )
        begin : theta01_gen
            generate
                for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
                begin : theta02_gen
                    assign sum_sheet[x][i] = ( ( ( ( theta_in[0][x][i] ^ theta_in[1][x][i] ) ^ theta_in[2][x][i] ) ^ theta_in[3][x][i] ) ^ theta_in[4][x][i] );
                end
            endgenerate
        end
    endgenerate
    generate
        for ( y = 0 ; ( y <= 4 ) ; y = ( y + 1 ) )
        begin : theta11_gen
            generate
                for ( x = 1 ; ( x <= 3 ) ; x = ( x + 1 ) )
                begin : theta12_gen
                    assign theta_out[y][x][0] = ( ( theta_in[y][x][0] ^ sum_sheet[( x - 1 )][0] ) ^ sum_sheet[( x + 1 )][63] );
                    generate
                        for ( i = 1 ; ( i <= 63 ) ; i = ( i + 1 ) )
                        begin : theta13_gen
                            assign theta_out[y][x][i] = ( ( theta_in[y][x][i] ^ sum_sheet[( x - 1 )][i] ) ^ sum_sheet[( x + 1 )][( i - 1 )] );
                        end
                    endgenerate
                end
            endgenerate
        end
    endgenerate
    generate
        for ( y = 0 ; ( y <= 4 ) ; y = ( y + 1 ) )
        begin : theta21_gen
            assign theta_out[y][0][0] = ( ( theta_in[y][0][0] ^ sum_sheet[4][0] ) ^ sum_sheet[1][63] );
            generate
                for ( i = 1 ; ( i <= 63 ) ; i = ( i + 1 ) )
                begin : theta22_gen
                    assign theta_out[y][0][i] = ( ( theta_in[y][0][i] ^ sum_sheet[4][i] ) ^ sum_sheet[1][( i - 1 )] );
                end
            endgenerate
        end
    endgenerate
    generate
        for ( y = 0 ; ( y <= 4 ) ; y = ( y + 1 ) )
        begin : theta31_gen
            assign theta_out[y][4][0] = ( ( theta_in[y][4][0] ^ sum_sheet[3][0] ) ^ sum_sheet[0][63] );
            generate
                for ( i = 1 ; ( i <= 63 ) ; i = ( i + 1 ) )
                begin : theta32_gen
                    assign theta_out[y][4][i] = ( ( theta_in[y][4][i] ^ sum_sheet[3][i] ) ^ sum_sheet[0][( i - 1 )] );
                end
            endgenerate
        end
    endgenerate
    generate
        for ( y = 0 ; ( y <= 4 ) ; y = ( y + 1 ) )
        begin : pi01_gen
            generate
                for ( x = 0 ; ( x <= 4 ) ; x = ( x + 1 ) )
                begin : pi02_gen
                    generate
                        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
                        begin : pi03_gen
                            assign pi_out[( ( ( 2 * x ) + ( 3 * y ) ) % 5 )][( ( 0 * x ) + ( 1 * y ) )][i] = pi_in[y][x][i];
                        end
                    endgenerate
                end
            endgenerate
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rho01_gen
            assign rho_out[0][0][i] = rho_in[0][0][i];
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rho11_gen
            assign rho_out[0][1][i] = rho_in[0][1][( ( i - 1 ) % 64 )];
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rho21_gen
            assign rho_out[0][2][i] = rho_in[0][2][( ( i - 62 ) % 64 )];
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rho31_gen
            assign rho_out[0][3][i] = rho_in[0][3][( ( i - 28 ) % 64 )];
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rho41_gen
            assign rho_out[0][4][i] = rho_in[0][4][( ( i - 27 ) % 64 )];
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rho51_gen
            assign rho_out[1][0][i] = rho_in[1][0][( ( i - 36 ) % 64 )];
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rho61_gen
            assign rho_out[1][1][i] = rho_in[1][1][( ( i - 44 ) % 64 )];
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rho71_gen
            assign rho_out[1][2][i] = rho_in[1][2][( ( i - 6 ) % 64 )];
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rho81_gen
            assign rho_out[1][3][i] = rho_in[1][3][( ( i - 55 ) % 64 )];
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rho91_gen
            assign rho_out[1][4][i] = rho_in[1][4][( ( i - 20 ) % 64 )];
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rhoa1_gen
            assign rho_out[2][0][i] = rho_in[2][0][( ( i - 3 ) % 64 )];
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rhob1_gen
            assign rho_out[2][1][i] = rho_in[2][1][( ( i - 10 ) % 64 )];
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rhoc1_gen
            assign rho_out[2][2][i] = rho_in[2][2][( ( i - 43 ) % 64 )];
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rhod1_gen
            assign rho_out[2][3][i] = rho_in[2][3][( ( i - 25 ) % 64 )];
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rhoe1_gen
            assign rho_out[2][4][i] = rho_in[2][4][( ( i - 39 ) % 64 )];
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rhof1_gen
            assign rho_out[3][0][i] = rho_in[3][0][( ( i - 41 ) % 64 )];
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rhog1_gen
            assign rho_out[3][1][i] = rho_in[3][1][( ( i - 45 ) % 64 )];
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rhoh1_gen
            assign rho_out[3][2][i] = rho_in[3][2][( ( i - 15 ) % 64 )];
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rhoi1_gen
            assign rho_out[3][3][i] = rho_in[3][3][( ( i - 21 ) % 64 )];
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rhoj1_gen
            assign rho_out[3][4][i] = rho_in[3][4][( ( i - 8 ) % 64 )];
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rhok1_gen
            assign rho_out[4][0][i] = rho_in[4][0][( ( i - 18 ) % 64 )];
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rhol1_gen
            assign rho_out[4][1][i] = rho_in[4][1][( ( i - 2 ) % 64 )];
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rhom1_gen
            assign rho_out[4][2][i] = rho_in[4][2][( ( i - 61 ) % 64 )];
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rhon1_gen
            assign rho_out[4][3][i] = rho_in[4][3][( ( i - 56 ) % 64 )];
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : rhoo1_gen
            assign rho_out[4][4][i] = rho_in[4][4][( ( i - 14 ) % 64 )];
        end
    endgenerate
    generate
        for ( y = 1 ; ( y <= 4 ) ; y = ( y + 1 ) )
        begin : iota01_gen
            generate
                for ( x = 0 ; ( x <= 4 ) ; x = ( x + 1 ) )
                begin : iota02_gen
                    generate
                        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
                        begin : iota03_gen
                            assign iota_out[y][x][i] = iota_in[y][x][i];
                        end
                    endgenerate
                end
            endgenerate
        end
    endgenerate
    generate
        for ( x = 1 ; ( x <= 4 ) ; x = ( x + 1 ) )
        begin : iota11_gen
            generate
                for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
                begin : iota12_gen
                    assign iota_out[0][x][i] = iota_in[0][x][i];
                end
            endgenerate
        end
    endgenerate
    generate
        for ( i = 0 ; ( i <= 63 ) ; i = ( i + 1 ) )
        begin : iota21_gen
            assign iota_out[0][0][i] = ( iota_in[0][0][i] ^ edautils_unknown_funcdecl );
        end
    endgenerate
endmodule 
