module keccak_fsm1(
        clk,
        rst,
        c,
        load_next_block,
        final_segment,
        ein,
        en_ctr,
        en_len,
        en_output_len,
        clr_len,
        sel_dec_size,
        last_word,
        spos,
        block_ready_set,
        msg_end_set,
        src_ready,
        src_read,
        mode
    );
    input clk;
    input rst;
    input [31:0] c;
    input load_next_block;
    input final_segment;
    output ein;
    output en_ctr;
    output en_len;
    output en_output_len;
    output clr_len;
    output sel_dec_size;
    output last_word;
    output [1:0] spos;
    output block_ready_set;
    output msg_end_set;
    input src_ready;
    output src_read;
    input [1:0] mode;
    localparam mwseg  = ( 1344 / 64 );
    function [33:0] log2_32;
        input [31:0] n;
    begin
        if ( n == 0 ) 
        begin
            log2_32 = 0;
        end
        else
        begin 
            if ( n <= 2 ) 
            begin
                log2_32 = 1;
            end
            else
            begin 
                if ( ( n % 2 ) == 0 ) 
                begin
                    log2_32 = ( 1 + log2_32(( n / 2 )) );
                end
                else
                begin 
                    log2_32 = ( 1 + log2_32(( ( n + 1 ) / 2 )) );
                end
            end
        end
    end
    endfunction 
    localparam log2mwseg  = log2_32(( 1344 / 64 ));
    localparam log2mwsegzeros  = { ( ( ( ( ( log2_32(( 1344 / 64 )) - 1 ) - 0 ) < 0 ) ) ? ( (  -( 1) * ( ( log2_32(( 1344 / 64 )) - 1 ) - 0 ) ) ) : ( ( ( log2_32(( 1344 / 64 )) - 1 ) - 0 ) ) ) { 1'b0 } } ;
    wire [( log2_32(( 1344 / 64 )) - 1 ):0] wc;
    wire f;
    wire start_pad;
    wire full_block;
    localparam zeros  = { ( ( ( ( 63 - 0 ) < 0 ) ) ? ( (  -( 1) * ( 63 - 0 ) ) ) : ( ( 63 - 0 ) ) ) { 1'b0 } } ;
    reg comp_lb_e0_128;
    reg comp_lb_e0_256;
    reg comp_lb_e0_512;
    reg comp_lb_e0;
    reg [31:0]mw;
    reg [31:0]mw_seg_2;
    reg zc0;
    reg zc_more_than_block;
    reg extra_block;
    reg zjfin;
    function  CONV_STD_LOGIC_VECTOR_32_32;
        input [31:0] arg;
        input [31:0] size;
    begin
    end
    endfunction 
    reg [2:0]cstate_fsm1;
    reg [2:0]nstate;
    reg src_read;
    reg ej;
    reg block_ready_set;
    reg msg_end_set;
    reg lf;
    reg ef;
    reg en_len;
    reg en_output_len;
    reg en_ctr;
    reg lj;
    reg set_full_block;
    reg clr_full_block;
    reg [1:0]spos_sig;
    reg set_start_pad;
    reg clr_start_pad;
    reg last_word;
    reg clr_len;
    always @ (  c)
    begin
        if ( c[10:6] == zeros ) 
        begin
            comp_lb_e0_128 <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/keccak_fsm1.vhd:73 
            begin
                comp_lb_e0_128 <= 1'b0;
            end
        end
    end
    always @ (  c)
    begin
        if ( c[10:6] == zeros ) 
        begin
            comp_lb_e0_256 <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/keccak_fsm1.vhd:74 
            begin
                comp_lb_e0_256 <= 1'b0;
            end
        end
    end
    always @ (  c)
    begin
        if ( c[9:6] == zeros ) 
        begin
            comp_lb_e0_512 <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/keccak_fsm1.vhd:75 
            begin
                comp_lb_e0_512 <= 1'b0;
            end
        end
    end
    always @ (  mode or  comp_lb_e0_128 or  comp_lb_e0_256 or  comp_lb_e0_512)
    begin
        if ( mode == 2'b10 ) 
        begin
            comp_lb_e0 <= comp_lb_e0_128;
        end
        else
        begin 
            if ( mode == 2'b00 ) 
            begin
                comp_lb_e0 <= comp_lb_e0_256;
            end
            else
            begin 
                if ( mode == 2'b01 ) 
                begin
                    comp_lb_e0 <= comp_lb_e0_512;
                end
                else
                begin 
                    if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/keccak_fsm1.vhd:77 
                    begin
                        comp_lb_e0 <= comp_lb_e0_256;
                    end
                end
            end
        end
    end
    always @ (  mode)
    begin
        if ( mode == 2'b00 ) 
        begin
            mw <= 1088;
        end
        else
        begin 
            if ( mode == 2'b01 ) 
            begin
                mw <= 576;
            end
            else
            begin 
                if ( mode == 2'b10 ) 
                begin
                    mw <= 1344;
                end
                else
                begin 
                    if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/keccak_fsm1.vhd:82 
                    begin
                        mw <= 1088;
                    end
                end
            end
        end
    end
    always @ (  mode)
    begin
        if ( mode == 2'b00 ) 
        begin
            mw_seg_2 <= ( 1088 / 64 );
        end
        else
        begin 
            if ( mode == 2'b01 ) 
            begin
                mw_seg_2 <= ( 576 / 64 );
            end
            else
            begin 
                if ( mode == 2'b10 ) 
                begin
                    mw_seg_2 <= ( 1344 / 64 );
                end
                else
                begin 
                    if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/keccak_fsm1.vhd:87 
                    begin
                        mw_seg_2 <= ( 1088 / 64 );
                    end
                end
            end
        end
    end
    always @ (  c)
    begin
        if ( c == 0 ) 
        begin
            zc0 <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/keccak_fsm1.vhd:92 
            begin
                zc0 <= 1'b0;
            end
        end
    end
    always @ (  c or  mw)
    begin
        if ( c >= mw ) 
        begin
            zc_more_than_block <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/keccak_fsm1.vhd:93 
            begin
                zc_more_than_block <= 1'b0;
            end
        end
    end
    always @ (  c)
    begin
        if ( c[6:0] == 64 ) 
        begin
            extra_block <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/keccak_fsm1.vhd:97 
            begin
                extra_block <= 1'b0;
            end
        end
    end
    sr_reg sr_final_segment (
            .clk(clk),
            .clr(lf),
            .rst(rst),
            .set(ef),
            .output(f)
        );
    countern #(
            .n(log2_32(( 1344 / 64 )))
        ) word_counter_gen (
            .clk(clk),
            .en(ej),
            .input({ 1'b0 }),
            .load(lj),
            .rst(1'b0),
            .output(wc)
        );
    always @ (  wc)
    begin
        if ( wc == CONV_STD_LOGIC_VECTOR_32_32(( mw_seg_2 - 1 ),log2_32(( 1344 / 64 ))) ) 
        begin
            zjfin <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/sha3_pkg.vhd:113 
            begin
                zjfin <= 1'b0;
            end
        end
    end
    always @ (  posedge clk)
    begin : cstate_proc
        if ( clk == 1'b1 ) 
        begin
            if ( rst == 1'b1 ) 
            begin
                cstate_fsm1 <= 0'b0;
            end
            else
            begin 
                cstate_fsm1 <= nstate;
            end
        end
    end
    always @ (  cstate_fsm1 or  src_ready or  load_next_block or  zjfin or  zc0 or  final_segment or  f or  full_block)
    begin : nstate_proc
        case ( cstate_fsm1 ) 
        0'b0:
        begin
            nstate <= 1'b1;
        end
        1'b1:
        begin
            if ( src_ready == 1'b1 ) 
            begin
                nstate <= 1'b1;
            end
            else
            begin 
                nstate <= 2'b11;
            end
        end
        2'b11:
        begin
            if ( load_next_block == 1'b0 ) 
            begin
                nstate <= 2'b11;
            end
            else
            begin 
                nstate <= 1'b10;
            end
        end
        1'b10:
        begin
            if ( ( ( src_ready == 1'b1 ) & ( ( ( f == 1'b0 ) | ( zc0 == 1'b0 ) ) | ( full_block == 1'b1 ) ) ) | ( zjfin == 1'b0 ) ) 
            begin
                nstate <= 1'b10;
            end
            else
            begin 
                if ( ( ( zjfin == 1'b1 ) & ( full_block == 1'b0 ) ) & ( f == 1'b1 ) ) 
                begin
                    nstate <= 1'b100;
                end
                else
                begin 
                    if ( ( ( ( src_ready == 1'b0 ) & ( zjfin == 1'b1 ) ) & ( f == 1'b0 ) ) & ( zc0 == 1'b1 ) ) 
                    begin
                        nstate <= 1'b1;
                    end
                    else
                    begin 
                        nstate <= 2'b11;
                    end
                end
            end
        end
        1'b100:
        begin
            if ( load_next_block == 1'b0 ) 
            begin
                nstate <= 1'b100;
            end
            else
            begin 
                nstate <= 1'b1;
            end
        end
        endcase
    end
    always @ (  cstate_fsm1 or  src_ready or  zc0 or  full_block)
    begin
        if ( ( ( cstate_fsm1 == 1'b1 ) & ( src_ready == 1'b0 ) ) | ( ( ( cstate_fsm1 == 1'b10 ) & ( src_ready == 1'b0 ) ) & ( ( zc0 == 1'b0 ) | ( full_block == 1'b1 ) ) ) ) 
        begin
            src_read <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/keccak_fsm1.vhd:168 
            begin
                src_read <= 1'b0;
            end
        end
    end
    assign ein = ej;
    always @ (  cstate_fsm1 or  src_ready or  zc0 or  f or  full_block)
    begin
        if ( ( cstate_fsm1 == 1'b10 ) & ( ( ( src_ready == 1'b0 ) & ( ( ( zc0 == 1'b0 ) | ( f == 1'b0 ) ) | ( full_block == 1'b1 ) ) ) | ( ( ( zc0 == 1'b1 ) & ( f == 1'b1 ) ) & ( full_block == 1'b0 ) ) ) ) 
        begin
            ej <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/keccak_fsm1.vhd:174 
            begin
                ej <= 1'b0;
            end
        end
    end
    always @ (  cstate_fsm1 or  zjfin or  src_ready or  zc0 or  f or  full_block)
    begin
        if ( ( ( cstate_fsm1 == 1'b10 ) & ( zjfin == 1'b1 ) ) & ( ( ( src_ready == 1'b0 ) & ( ( ( zc0 == 1'b0 ) | ( f == 1'b0 ) ) | ( full_block == 1'b1 ) ) ) | ( ( ( zc0 == 1'b1 ) & ( f == 1'b1 ) ) & ( full_block == 1'b0 ) ) ) ) 
        begin
            block_ready_set <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/keccak_fsm1.vhd:178 
            begin
                block_ready_set <= 1'b0;
            end
        end
    end
    always @ (  cstate_fsm1 or  zjfin or  full_block or  f)
    begin
        if ( ( ( ( cstate_fsm1 == 1'b10 ) & ( zjfin == 1'b1 ) ) & ( full_block == 1'b0 ) ) & ( f == 1'b1 ) ) 
        begin
            msg_end_set <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/keccak_fsm1.vhd:183 
            begin
                msg_end_set <= 1'b0;
            end
        end
    end
    always @ (  cstate_fsm1 or  load_next_block)
    begin
        if ( ( cstate_fsm1 == 0'b0 ) | ( ( cstate_fsm1 == 1'b100 ) & ( load_next_block == 1'b1 ) ) ) 
        begin
            lf <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/keccak_fsm1.vhd:186 
            begin
                lf <= 1'b0;
            end
        end
    end
    always @ (  cstate_fsm1 or  final_segment)
    begin
        if ( ( cstate_fsm1 == 1'b1 ) & ( final_segment == 1'b1 ) ) 
        begin
            ef <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/keccak_fsm1.vhd:189 
            begin
                ef <= 1'b0;
            end
        end
    end
    always @ (  src_ready or  cstate_fsm1)
    begin
        if ( ( src_ready == 1'b0 ) & ( cstate_fsm1 == 1'b1 ) ) 
        begin
            en_len <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/keccak_fsm1.vhd:191 
            begin
                en_len <= 1'b0;
            end
        end
    end
    always @ (  src_ready or  cstate_fsm1)
    begin
        if ( ( src_ready == 1'b0 ) & ( cstate_fsm1 == 1'b1 ) ) 
        begin
            en_output_len <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/keccak_fsm1.vhd:192 
            begin
                en_output_len <= 1'b0;
            end
        end
    end
    always @ (  cstate_fsm1 or  load_next_block or  zc_more_than_block or  full_block or  src_ready or  zc0)
    begin
        if ( ( ( ( cstate_fsm1 == 2'b11 ) & ( load_next_block == 1'b1 ) ) & ( zc_more_than_block == 1'b1 ) ) | ( ( ( ( cstate_fsm1 == 1'b10 ) & ( full_block == 1'b0 ) ) & ( src_ready == 1'b0 ) ) & ( zc0 == 1'b0 ) ) ) 
        begin
            en_ctr <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/keccak_fsm1.vhd:193 
            begin
                en_ctr <= 1'b0;
            end
        end
    end
    always @ (  cstate_fsm1)
    begin
        if ( ( ( cstate_fsm1 == 0'b0 ) | ( cstate_fsm1 == 2'b11 ) ) | ( cstate_fsm1 == 1'b100 ) ) 
        begin
            lj <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/keccak_fsm1.vhd:198 
            begin
                lj <= 1'b0;
            end
        end
    end
    sr_reg sr_full_block (
            .clk(clk),
            .clr(clr_full_block),
            .rst(rst),
            .set(set_full_block),
            .output(full_block)
        );
    always @ (  cstate_fsm1 or  zc_more_than_block)
    begin
        if ( ( cstate_fsm1 == 2'b11 ) & ( zc_more_than_block == 1'b1 ) ) 
        begin
            set_full_block <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/sr_reg.vhd:210 
            begin
                set_full_block <= 1'b0;
            end
        end
    end
    always @ (  cstate_fsm1 or  zjfin or  ej)
    begin
        if ( ( ( cstate_fsm1 == 1'b10 ) & ( zjfin == 1'b1 ) ) & ( ej == 1'b1 ) ) 
        begin
            clr_full_block <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/sr_reg.vhd:212 
            begin
                clr_full_block <= 1'b0;
            end
        end
    end
    sr_reg sr_pos1 (
            .clk(clk),
            .clr(clr_start_pad),
            .rst(rst),
            .set(set_start_pad),
            .output(start_pad)
        );
    always @ (  cstate_fsm1 or  full_block or  f or  comp_lb_e0 or  start_pad)
    begin
        if ( ( ( ( ( cstate_fsm1 == 1'b10 ) & ( full_block == 1'b0 ) ) & ( f == 1'b1 ) ) & ( comp_lb_e0 == 1'b1 ) ) & ( start_pad == 1'b0 ) ) 
        begin
            spos_sig <= 2'b00;
        end
        else
        begin 
            if ( ( ( ( ( cstate_fsm1 == 1'b10 ) & ( full_block == 1'b0 ) ) & ( f == 1'b1 ) ) & ( comp_lb_e0 == 1'b1 ) ) & ( start_pad == 1'b1 ) ) 
            begin
                spos_sig <= 2'b01;
            end
            else
            begin 
                if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/sr_reg.vhd:224 
                begin
                    spos_sig <= 2'b11;
                end
            end
        end
    end
    assign spos = spos_sig;
    always @ (  cstate_fsm1 or  final_segment)
    begin
        if ( ( cstate_fsm1 == 1'b1 ) & ( final_segment == 1'b1 ) ) 
        begin
            set_start_pad <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/sr_reg.vhd:230 
            begin
                set_start_pad <= 1'b0;
            end
        end
    end
    always @ (  cstate_fsm1 or  full_block or  f or  comp_lb_e0 or  start_pad or  ej)
    begin
        if ( ( ( ( ( ( cstate_fsm1 == 1'b10 ) & ( full_block == 1'b0 ) ) & ( f == 1'b1 ) ) & ( comp_lb_e0 == 1'b1 ) ) & ( start_pad == 1'b1 ) ) & ( ej == 1'b1 ) ) 
        begin
            clr_start_pad <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/sr_reg.vhd:232 
            begin
                clr_start_pad <= 1'b0;
            end
        end
    end
    always @ (  cstate_fsm1 or  zjfin or  full_block or  f)
    begin
        if ( ( ( ( cstate_fsm1 == 1'b10 ) & ( zjfin == 1'b1 ) ) & ( full_block == 1'b0 ) ) & ( f == 1'b1 ) ) 
        begin
            last_word <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/sr_reg.vhd:236 
            begin
                last_word <= 1'b0;
            end
        end
    end
    assign sel_dec_size = set_full_block;
    always @ (  cstate_fsm1 or  full_block or  f or  comp_lb_e0 or  src_ready or  ej)
    begin
        if ( ( ( ( ( ( cstate_fsm1 == 1'b10 ) & ( full_block == 1'b0 ) ) & ( f == 1'b1 ) ) & ( comp_lb_e0 == 1'b1 ) ) & ( src_ready == 1'b0 ) ) & ( ej == 1'b1 ) ) 
        begin
            clr_len <= 1'b1;
        end
        else
        begin 
            if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/sr_reg.vhd:241 
            begin
                clr_len <= 1'b0;
            end
        end
    end
endmodule 
