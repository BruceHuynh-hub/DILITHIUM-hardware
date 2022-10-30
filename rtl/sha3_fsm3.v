module sha3_fsm3(
        clk,
        rst,
        eo,
        output_write,
        output_write_clr,
        output_busy_clr,
        dst_ready,
        dst_write,
        output_size,
        last_out_word
    );
    parameter [31:0]w  = 64;
    input clk;
    input rst;
    output eo;
    input output_write;
    output output_write_clr;
    output output_busy_clr;
    input dst_ready;
    output dst_write;
    input [10:0] output_size;
    output last_out_word;
    wire [10:0] hseg;
    wire [31:0] outsize_div_w;
    wire [31:0] b_div_w;
    wire [10:0] kc;
    localparam log2hsegzeros  = { ( ( ( ( 10 - 0 ) < 0 ) ) ? ( (  -( 1) * ( 10 - 0 ) ) ) : ( ( 10 - 0 ) ) ) { 1'b0 } } ;
    function  CONV_INTEGER_1;
        input arg;
    begin
    end
    endfunction 
    function  divceil_32_32;
        input [31:0] a;
        input [31:0] b;
    begin
    end
    endfunction 
    function  CONV_STD_LOGIC_VECTOR_32_32;
        input [31:0] arg;
        input [31:0] size;
    begin
    end
    endfunction 
    reg zkfin;
    reg [1:0]cstate_fsm3;
    reg [1:0]nstate;
    reg dst_write;
    reg output_write_clr;
    reg output_busy_clr;
    reg ek;
    reg lk;
    reg eo;
    assign outsize_div_w = divceil_32_32(CONV_INTEGER_1((output_size)),w);
    assign hseg = CONV_STD_LOGIC_VECTOR_32_32(outsize_div_w,11);
    countern #(
            .n(11)
        ) kcount_gen (
            .clk(clk),
            .en(ek),
            .data_in({ 1'b0 }),
            .load(lk),
            .rst(1'b0),
      .data_out(kc) //renamed input and output to data_in/data_out
        );
    always @ (  kc or  hseg)
    begin
        if ( kc == ( hseg - 1 ) ) 
        begin
            zkfin <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/sha3_pkg.vhd:61 
            begin
                zkfin <= 1'b0;
            end
        end
    end
    always @ (  posedge clk)
    begin : cstate_proc
        if ( clk == 1'b1 ) 
        begin
            if ( rst == 1'b1 ) 
            begin
                cstate_fsm3 <= 0'b0;
            end
            else
            begin 
                cstate_fsm3 <= nstate;
            end
        end
    end
    always @ (  cstate_fsm3 or  dst_ready or  output_write or  zkfin)
    begin : nstate_proc
        case ( cstate_fsm3 ) 
        0'b0:
        begin
            if ( output_write == 1'b1 ) 
            begin
                nstate <= 1'b1;
            end
            else
            begin 
                nstate <= 0'b0;
            end
        end
        1'b1:
        begin
            if ( ( dst_ready == 1'b0 ) & ( zkfin == 1'b1 ) ) 
            begin
                nstate <= 0'b0;
            end
            else
            begin 
                nstate <= 1'b1;
            end
        end
        endcase
    end
    always @ (  cstate_fsm3 or  dst_ready)
    begin
        if ( ( cstate_fsm3 == 1'b1 ) & ( dst_ready == 1'b0 ) ) 
        begin
            dst_write <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/sha3_fsm3.vhd:93 
            begin
                dst_write <= 1'b0;
            end
        end
    end
    always @ (  cstate_fsm3 or  output_write)
    begin
        if ( ( cstate_fsm3 == 0'b0 ) & ( output_write == 1'b1 ) ) 
        begin
            output_write_clr <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/sha3_fsm3.vhd:94 
            begin
                output_write_clr <= 1'b0;
            end
        end
    end
    always @ (  cstate_fsm3 or  dst_ready or  zkfin)
    begin
        if ( ( ( cstate_fsm3 == 1'b1 ) & ( dst_ready == 1'b0 ) ) & ( zkfin == 1'b1 ) ) 
        begin
            output_busy_clr <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/sha3_fsm3.vhd:95 
            begin
                output_busy_clr <= 1'b0;
            end
        end
    end
    always @ (  cstate_fsm3 or  dst_ready or  zkfin)
    begin
        if ( ( ( cstate_fsm3 == 1'b1 ) & ( dst_ready == 1'b0 ) ) & ( zkfin == 1'b0 ) ) 
        begin
            ek <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/sha3_fsm3.vhd:96 
            begin
                ek <= 1'b0;
            end
        end
    end
    always @ (  cstate_fsm3 or  dst_ready or  zkfin or  output_write)
    begin
        if ( ( ( ( cstate_fsm3 == 1'b1 ) & ( dst_ready == 1'b0 ) ) & ( zkfin == 1'b1 ) ) | ( ( cstate_fsm3 == 0'b0 ) & ( output_write == 1'b1 ) ) ) 
        begin
            lk <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/sha3_fsm3.vhd:97 
            begin
                lk <= 1'b0;
            end
        end
    end
    always @ (  cstate_fsm3 or  dst_ready)
    begin
        if ( ( cstate_fsm3 == 1'b1 ) & ( dst_ready == 1'b0 ) ) 
        begin
            eo <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/sha3_fsm3.vhd:98 
            begin
                eo <= 1'b0;
            end
        end
    end
    assign last_out_word = zkfin;
endmodule 
