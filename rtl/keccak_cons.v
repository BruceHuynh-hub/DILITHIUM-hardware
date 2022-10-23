module keccak_cons(
        addr,
        rc
    );
    parameter [31:0]ur  = 1;
    input [4:0] addr;
    output [((ur * 64) - 1):0] rc;
    localparam my_rom  = {16'h0000000000000001, 
                          16'b1000000010000010, 
                          1'b0, 
                          1'b0, 
                          16'b1000000010001011, 
                          32'b10000000000000000000000000000001, 
                          1'b0, 
                          1'b0, 
                          8'b10001010, 
                          8'b10001000, 
                          32'b10000000000000001000000000001001, 
                          32'b10000000000000000000000000001010, 
                          32'b10000000000000001000000010001011, 
                          1'b0, 
                          1'b0, 
                          1'b0, 
                          1'b0, 
                          1'b0, 
                          16'b1000000000001010, 
                          1'b0, 
                          1'b0, 
                          1'b0, 
                          32'b10000000000000000000000000000001, 
                          1'b0, 
                          16'b0000000000000000, 
                          16'b0000000000000000, 
                          16'b0000000000000000, 
                          16'b0000000000000000, 
                          16'b0000000000000000, 
                          16'b0000000000000000, 
                          16'b0000000000000000, 
                          16'b0000000000000000 };
    function  CONV_INTEGER_5;
        input [4:0] arg;
    begin
    end
    endfunction 
    function  CONV_INTEGER_6;
        input [5:0] arg;
    begin
    end
    endfunction 
    generate
        if (ur == 1) 
        begin : l1_con
            assign rc = my_rom[CONV_INTEGER_5(unsigned'(addr))];
        end
    endgenerate
    generate
        if ( ur > 1 ) 
        begin : l2_con
        genvar i;
            generate
                for (i = 0 ; (i <= (ur - 1)); i = (i + 1))
                begin : l2_gen
                    assign rc[((64 * (i + 1)) - 1):(64 * i)] = my_rom[CONV_INTEGER_6(unsigned'((addr + i)))];
                end
            endgenerate
        end
    endgenerate
endmodule 
