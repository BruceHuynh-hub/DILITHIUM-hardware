module keccak_fsm2(
        clk,
        rst,
        wr_state,
        sel_xor,
        sel_final,
        ld_rdctr,
        en_rdctr,
        block_ready_clr,
        msg_end_clr,
        block_ready,
        msg_end,
        lo,
        output_write_set,
        output_busy_set,
        output_busy,
        d,
        output_size,
        mode,
        mode_ctrl
    );
    input clk;
    input rst;
    output wr_state;
    output sel_xor;
    output sel_final;
    output ld_rdctr;
    output en_rdctr;
    output block_ready_clr;
    output msg_end_clr;
    input block_ready;
    input msg_end;
    output lo;
    output output_write_set;
    output output_busy_set;
    input output_busy;
    input [31:0] d;
    output [10:0] output_size;
    input [1:0] mode;
    output [1:0] mode_ctrl;
    localparam roundnr  = 24;
    function  log2_32;
        input [31:0] n;
    begin
    end
    endfunction 
    localparam log2roundnr  = log2_32(24);
    localparam log2roundnrzeros  = { (((((log2_32(24)-1)-0) <0)) ? ((-( 1)*((log2_32(24)-1)-0))) : (((log2_32(24)-1)-0))) { 1'b0 } };
    wire [( log2_32(24) - 1 ):0] pc;
    wire sel_xor_wire;
    reg [31:0]b;
    reg ziroundnr;
    function  CONV_STD_LOGIC_VECTOR_32_32;
        input [31:0] arg;
        input [31:0] size;
    begin
    end
    endfunction 
    reg [3:0]cstate;
    reg [31:0]cnt_output_size_r;
    reg [10:0]output_size_r;
    reg [1:0]mode_r;
    reg hashing_started_r;
    reg [31:0]cnt_output_size_next;
    reg [10:0]output_size_next;
    reg [1:0]mode_next;
    reg hashing_started_next;
    reg [3:0]nstate;
    reg output_data_s;
    reg block_ready_clr;
    reg ei;
    reg li;
    reg sel_xor_set;
    reg sel_xor_clr;
    reg sel_final;
    reg ld_rdctr;
    reg en_rdctr;
    reg wr_state;
    reg msg_end_clr;
    always @ ( mode_r)
    begin
        if ( mode_r == 2'b11 ) 
            b <= 1088;
        else
            b <= 1344;
    end
    countern #(
            .n(log2_32(24))
        ) proc_counter_gen (
            .clk(clk),
            .en(ei),
            .input({ 1'b0 }),
            .load(li),
            .rst(rst),
            .output(pc)
        );
    always @ (  pc)
    begin
        if ( pc == CONV_STD_LOGIC_VECTOR_32_32(( 24 - 1 ),log2_32(24)) ) 
            ziroundnr <= 1'b1;
        else
            ziroundnr <= 1'b0;
    end
    always @ (  posedge clk)
    begin : cstate_proc
        if ( clk == 1'b1 ) 
        begin
            if ( rst == 1'b1 ) 
            begin
                cstate <= 0'b0;
                cnt_output_size_r <= { 1'b0 };
                output_size_r <= { 1'b0 };
                mode_r <= { 1'b0 };
                hashing_started_r <= 1'b0;
            end
            else
            begin 
                cstate <= nstate;
                cnt_output_size_r <= cnt_output_size_next;
                output_size_r <= output_size_next;
                mode_r <= mode_next;
                hashing_started_r <= hashing_started_next;
            end
        end
    end
    always @ ( cstate or msg_end or output_busy or block_ready or ziroundnr or d or cnt_output_size_r or b or mode or hashing_started_r or output_size_r or mode_r)
    begin : nstate_proc
        cnt_output_size_next <= cnt_output_size_r;
        output_size_next <= output_size_r;
        mode_next <= mode_r;
        hashing_started_next <= hashing_started_r;
        nstate <= cstate;
        case ( cstate ) 
        0'b0:
        begin
            nstate <= 1'b1;
        end
        1'b1:
        begin
            if ( ( block_ready == 1'b1 ) & ( msg_end == 1'b0 ) ) 
            begin
                nstate <= 1'b10;
                if ( hashing_started_r == 1'b0 ) 
                begin
                    cnt_output_size_next <= d;
                    mode_next <= mode;
                    hashing_started_next <= 1'b1;
                end
            end
            else
            begin 
                if ( ( block_ready == 1'b1 ) & ( msg_end == 1'b1 ) ) 
                begin
                    nstate <= 2'b11;
                    if ( hashing_started_r == 1'b0 ) 
                    begin
                        cnt_output_size_next <= d;
                        mode_next <= mode;
                        hashing_started_next <= 1'b1;
                    end
                end
                else
                    nstate <= 1'b1;
            end
        end
        1'b10:
        begin
            if ( ( ziroundnr == 1'b0 ) | ( ( ( ziroundnr == 1'b1 ) & ( msg_end == 1'b0 ) ) & ( block_ready == 1'b1 ) ) ) 
                nstate <= 1'b10;
            else
            begin 
                if ( ( ziroundnr == 1'b1 ) & ( msg_end == 1'b1 ) ) 
                    nstate <= 2'b11;
                else
                    nstate <= 1'b1;
            end
        end
        2'b11:
        begin
            if ( ziroundnr == 1'b0 ) 
                nstate <= 2'b11;
            else
            begin 
                if ( ziroundnr == 1'b1 ) 
                begin
                    if ( ( mode_r == 2'b00 ) | ( mode_r == 2'b01 ) ) 
                        nstate <= 2'b101;
                    else
                        nstate <= 1'b100;
                end
                else
                    nstate <= 1'b1;
            end
        end
        2'b101:
        begin
            if ( mode_r == 2'b00 ) 
                output_size_next <= CONV_STD_LOGIC_VECTOR_32_32(256,11);
            else
                begin 
                    if ( mode_r == 2'b01 ) 
                        output_size_next <= CONV_STD_LOGIC_VECTOR_32_32(512,11);
                end
            if ( output_busy == 1'b1 ) 
                begin
                    hashing_started_next <= 1'b0;
                    nstate <= 3'b111;
                end
            else
            begin 
                if ( ( block_ready == 1'b1 ) & ( msg_end == 1'b1 ) ) 
                begin
                    cnt_output_size_next <= d;
                    mode_next <= mode;
                    nstate <= 2'b11;
                end
                else
                begin 
                    if ( block_ready == 1'b1 ) 
                    begin
                        cnt_output_size_next <= d;
                        mode_next <= mode;
                        nstate <= 1'b10;
                    end
                    else
                    begin 
                        hashing_started_next <= 1'b0;
                        nstate <= 1'b1;
                    end
                end
            end
        end
        3'b111:
        begin
            if ( output_busy == 1'b1 ) 
                nstate <= 3'b111;
            else
            begin 
                if ( ( block_ready == 1'b1 ) & ( msg_end == 1'b1 ) ) 
                begin
                    cnt_output_size_next <= d;
                    hashing_started_next <= 1'b1;
                    mode_next <= mode;
                    nstate <= 2'b11;
                end
                else
                begin 
                    if ( block_ready == 1'b1 ) 
                    begin
                        cnt_output_size_next <= d;
                        hashing_started_next <= 1'b1;
                        mode_next <= mode;
                        nstate <= 1'b10;
                    end
                    else
                        nstate <= 1'b1;
                end
            end
        end
        1'b100:
        begin
            if ( cnt_output_size_r > b ) 
            begin
                nstate <= 1'b1000;
                output_size_next <= CONV_STD_LOGIC_VECTOR_32_32(b,11);
            end
            else
            begin 
                output_size_next <= cnt_output_size_r[10:0];
                if ( output_busy == 1'b1 ) 
                begin
                    nstate <= 2'b110;
                    hashing_started_next <= 1'b0;
                end
                else
                begin 
                    if (( block_ready == 1'b1 ) & (msg_end == 1'b1 )) 
                    begin
                        cnt_output_size_next <= d;
                        mode_next <= mode;
                        nstate <= 2'b11;
                    end
                    else
                    begin 
                        if ( block_ready == 1'b1 ) 
                        begin
                            cnt_output_size_next <= d;
                            mode_next <= mode;
                            nstate <= 1'b10;
                        end
                        else
                        begin 
                            hashing_started_next <= 1'b0;
                            nstate <= 1'b1;
                        end
                    end
                end
            end
        end
        2'b110:
        begin
            if ( output_busy == 1'b1 ) 
                nstate <= 2'b110;
            else
            begin 
                if (( block_ready == 1'b1 ) & ( msg_end == 1'b1 )) 
                begin
                    nstate <= 2'b11;
                    cnt_output_size_next <= d;
                    mode_next <= mode;
                    hashing_started_next <= 1'b1;
                end
                else
                begin 
                    if ( block_ready == 1'b1 ) 
                    begin
                        nstate <= 1'b10;
                        cnt_output_size_next <= d;
                        mode_next <= mode;
                        hashing_started_next <= 1'b1;
                    end
                    else
                        nstate <= 1'b1;
                end
            end
        end
        1'b1000:
        begin
            if ( ziroundnr == 1'b0 ) 
                nstate <= 1'b1000;
            else
            begin 
                if ( ziroundnr == 1'b1 ) 
                begin
                    if ( output_busy == 1'b1 ) 
                        nstate <= 2'b1001;
                    else
                    begin 
                        cnt_output_size_next <= ( cnt_output_size_r - b );
                        nstate <= 1'b100;
                    end
                end
                else
                    nstate <= 1'b1;
            end
        end
        2'b1001:
        begin
            if ( output_busy == 1'b0 ) 
            begin
                cnt_output_size_next <= ( cnt_output_size_r - b );
                nstate <= 1'b100;
            end
        end
        endcase
    end
    assign output_size = output_size_r;
    assign mode_ctrl = mode_r;
    always @ (cstate or output_busy)
    begin
        if ((((cstate == 2'b101) | (cstate == 1'b100)) & (output_busy == 1'b0)) | (((cstate == 3'b111) | (cstate == 2'b110)) & (output_busy == 1'b0))) 
            output_data_s <= 1'b1;
        else
        begin 
                output_data_s <= 1'b0;
    end
    assign output_write_set = output_data_s;
    assign output_busy_set = output_data_s;
    assign lo = output_data_s;
    always @ ( cstate or pc)
    begin
        if (((cstate == 1'b10) | (cstate == 2'b11)) & (pc == 4)) 
            block_ready_clr <= 1'b1;
        else
            block_ready_clr <= 1'b0;
    end
    always @ ( cstate)
    begin
        if (((cstate == 1'b10) | (cstate == 2'b11)) | (cstate == 1'b1000)) 
            ei <= 1'b1;
        else
            ei <= 1'b0;
    end
    always @ (  cstate or  ziroundnr)
    begin
        if (((cstate == 0'b0) | (cstate == 1'b1)) | (ziroundnr == 1'b1)) 
            li <= 1'b1;
        else
            li <= 1'b0;
    end
    sr_reg #(
            .init(1'b1)
        ) sf_gen (
            .clk(clk),
            .clr(sel_xor_clr),
            .rst(rst),
            .set(sel_xor_set),
            .output(sel_xor_wire)
        );
    always @ (cstate or ziroundnr)
    begin
        if ((( cstate == 0'b0) | ((cstate == 2'b11) & (ziroundnr == 1'b1))) | ((cstate == 1'b1000) & (ziroundnr == 1'b1))) 
            sel_xor_set <= 1'b1;
        else
            sel_xor_set <= 1'b0;
    end
    always @ ( sel_xor_wire or cstate or block_ready or output_busy)
    begin
        if ((sel_xor_wire == 1'b1) & ((((cstate == 1'b1) & (block_ready == 1'b1)) | ((((cstate == 2'b101) | (cstate == 1'b100)) & (output_busy == 1'b0)) & (block_ready == 1'b1))) | ((((cstate == 3'b111) | (cstate == 2'b110)) & (block_ready == 1'b1)) & (output_busy == 1'b0)))) 
            sel_xor_clr <= 1'b1;
        else
            sel_xor_clr <= 1'b0;
    end
    assign sel_xor = sel_xor_wire;
    always @ (  cstate or  block_ready or  ziroundnr or  output_busy or  cnt_output_size_r or  b)
    begin
        if ((((((cstate == 1'b1) & (block_ready == 1'b1)) | ((cstate == 1'b10) & (ziroundnr == 1'b1))) | ((((cstate == 1'b100) & (output_busy == 1'b0)) & (block_ready == 1'b1 )) & ( cnt_output_size_r <= b ))) | (((cstate == 2'b101 ) & ( output_busy == 1'b0 ) ) & (block_ready == 1'b1))) | ((((cstate == 3'b111) | (cstate == 2'b110)) & (output_busy == 1'b0)) & (block_ready == 1'b1))) 
            sel_final <= 1'b1;
        else
            sel_final <= 1'b0;
    end
    always @ ( cstate or block_ready or ziroundnr)
    begin
        if ((((( cstate == 1'b1) & (block_ready == 1'b1)) | (((cstate == 1'b10) & (ziroundnr == 1'b1)) & (block_ready == 1'b1))) | ((cstate == 2'b11) & (ziroundnr == 1'b1 ))) | ((cstate == 1'b1000) & (ziroundnr == 1'b1))) 
            ld_rdctr <= 1'b1;
        else
            ld_rdctr <= 1'b0;
    end
    always @ (  cstate or  ziroundnr)
    begin
        if (((( cstate == 1'b10) | (cstate == 2'b11)) | (cstate == 1'b1000)) & (ziroundnr == 1'b0)) 
            en_rdctr <= 1'b1;
        else
            en_rdctr <= 1'b0;
    end
    always @ ( cstate or block_ready or ziroundnr or msg_end or output_busy or cnt_output_size_r or  b)
    begin
        if (((((((((cstate == 1'b1) & (block_ready == 1'b1)) | ((cstate == 1'b10) & (ziroundnr == 1'b0))) | (((cstate == 1'b10) & (ziroundnr == 1'b1)) & ((( msg_end == 1'b0 ) & ( block_ready == 1'b1 )) | ( msg_end == 1'b1 )))) | ( cstate == 2'b11 )) | (((( cstate == 1'b100 ) & ( output_busy == 1'b0 )) & ( block_ready == 1'b1 )) & ( cnt_output_size_r <= b ))) | ((( cstate == 2'b101 ) & ( output_busy == 1'b0 )) & ( block_ready == 1'b1 ))) | (((( cstate == 3'b111 ) | ( cstate == 2'b110 )) & ( output_busy == 1'b0 )) & ( block_ready == 1'b1 ))) | ( cstate == 1'b1000 )) 
            wr_state <= 1'b1;
        else
            wr_state <= 1'b0;
    end
    always @ ( cstate or block_ready or msg_end or ziroundnr or output_busy or cnt_output_size_r or b)
    begin
        if ((((((( cstate == 1'b1 ) & ( block_ready == 1'b1 )) & ( msg_end == 1'b1 )) | (((( cstate == 1'b10 ) & ( block_ready == 1'b1 )) & ( msg_end == 1'b1 )) & ( ziroundnr == 1'b1 ))) | (((( cstate == 2'b101 ) & ( output_busy == 1'b0 ) ) & ( block_ready == 1'b1 )) & ( msg_end == 1'b1 ))) | ((((( cstate == 1'b100 ) & ( output_busy == 1'b0 )) & ( block_ready == 1'b1 )) & ( msg_end == 1'b1 )) & ( cnt_output_size_r <= b ))) | (((((cstate == 3'b111) | (cstate == 2'b110)) & (output_busy == 1'b0)) & (block_ready == 1'b1)) & (msg_end == 1'b1 ))) 
            msg_end_clr <= 1'b1;
        else
            msg_end_clr <= 1'b0;
    end
endmodule 
