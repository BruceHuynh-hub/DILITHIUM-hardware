module keccak_control(
        clk,
        rst,
        src_ready,
        src_read,
        dst_ready,
        dst_write,
        clr_len,
        sel_dec_size,
        last_word,
        spos,
        ein,
        en_ctr,
        en_len,
        en_output_len,
        sel_cin,
        sel_xor,
        sel_final,
        ld_rdctr,
        en_rdctr,
        wr_state,
        final_segment,
        sel_out,
        wr_piso,
        c,
        d,
        mode,
        mode_ctrl,
        output_size,
        last_out_word
    );
    input clk;
    input rst;
    input src_ready;
    inout src_read;
    input dst_ready;
    inout dst_write;
    output clr_len;
    output sel_dec_size;
    output last_word;
    output [1:0]spos;
    inout ein;
    inout en_ctr;
    inout en_len;
    inout en_output_len;
    output sel_cin;
    inout sel_xor;
    inout sel_final;
    inout ld_rdctr;
    inout en_rdctr;
    inout wr_state;
    input final_segment;
    output sel_out;
    output wr_piso;
    input [31:0]c;
    input [31:0]d;
    input [1:0]mode;
    output [1:0]mode_ctrl;
    inout [10:0]output_size;
    output last_out_word;
    wire block_ready_set;
    wire msg_end_set;
    wire load_next_block;
    wire block_ready_clr;
    wire msg_end_clr;
    wire block_ready;
    wire msg_end;
    wire output_write_set;
    wire output_busy_set;
    wire output_busy;
    wire output_write;
    wire output_write_clr;
    wire output_busy_clr;
    wire ein_wire;
    wire en_ctr_wire;
    wire en_len_wire;
    wire en_output_len_wire;
    wire wr_piso_wire;
    wire src_read_wire;
    wire dst_write_wire;
    wire sel_out_wire;
    wire sel_xor_wire;
    wire wr_state_wire;
    wire sel_final_wire;
    wire ld_rdctr_wire;
    wire en_rdctr_wire;
    wire eo_wire;
    wire [10:0]output_size_wire;
    reg wr_state;
    reg sel_xor;
    reg sel_final;
    reg ld_rdctr;
    reg en_rdctr;
    reg sel_out_wire2;
    keccak_fsm1 fsm1_gen (
            .c(c),
            .clk(clk),
            .final_segment(final_segment),
            .mode(mode),
            .rst(rst),
            .src_ready(src_ready),
            .clr_len(clr_len),
            .last_word(last_word),
            .sel_dec_size(sel_dec_size),
            .spos(spos),
            .block_ready_set(block_ready_set),
            .ein(ein_wire),
            .en_ctr(en_ctr_wire),
            .en_len(en_len_wire),
            .en_output_len(en_output_len_wire),
            .load_next_block(load_next_block),
            .msg_end_set(msg_end_set),
            .src_read(src_read_wire)
        );
    keccak_fsm2 fsm2_gen (
            .clk(clk),
            .d(d),
            .mode(mode),
            .rst(rst),
            .mode_ctrl(mode_ctrl),
            .block_ready(block_ready),
            .block_ready_clr(block_ready_clr),
            .en_rdctr(en_rdctr_wire),
            .ld_rdctr(ld_rdctr_wire),
            .lo(sel_out_wire),
            .msg_end(msg_end),
            .msg_end_clr(msg_end_clr),
            .output_busy(output_busy),
            .output_busy_set(output_busy_set),
            .output_size(output_size_wire),
            .output_write_set(output_write_set),
            .sel_final(sel_final_wire),
            .sel_xor(sel_xor_wire),
            .wr_state(wr_state_wire)
        );
    sha3_fsm3 fsm3_gen (
            .clk(clk),
            .dst_ready(dst_ready),
            .rst(rst),
            .last_out_word(last_out_word),
            .dst_write(dst_write_wire),
            .eo(eo_wire),
            .output_busy_clr(output_busy_clr),
            .output_size(output_size_wire),
            .output_write(output_write),
            .output_write_clr(output_write_clr)
        );
    assign load_next_block = (  ~( block_ready) | block_ready_clr );
    sr_reg sr_blk_ready (
            .clk(clk),
            .rst(rst),
            .clr(block_ready_clr),
            .output(block_ready),
            .set(block_ready_set)
        );
    sr_reg sr_msg_end (
            .clk(clk),
            .rst(rst),
            .clr(msg_end_clr),
            .output(msg_end),
            .set(msg_end_set)
        );
    sr_reg sr_output_write (
            .clk(clk),
            .rst(rst),
            .clr(output_write_clr),
            .output(output_write),
            .set(output_write_set)
        );
    sr_reg sr_output_busy (
            .clk(clk),
            .rst(rst),
            .clr(output_busy_clr),
            .output(output_busy),
            .set(output_busy_set)
        );
    assign ein = ein_wire;
    assign en_len = en_len_wire;
    assign en_output_len = en_output_len_wire;
    assign en_ctr = en_ctr_wire;
    assign src_read = src_read_wire;
    always @ (  posedge clk)
    begin : reg_out
        if ( clk == 1'b1 ) 
        begin
            wr_state <= wr_state_wire;
            sel_xor <= sel_xor_wire;
            sel_final <= sel_final_wire;
            ld_rdctr <= ld_rdctr_wire;
            en_rdctr <= en_rdctr_wire;
            sel_out_wire2 <= sel_out_wire;
        end
    end
    assign wr_piso_wire = ( eo_wire | sel_out_wire2 );
    assign dst_write = dst_write_wire;
    assign sel_out = sel_out_wire2;
    assign wr_piso = wr_piso_wire;
    assign output_size = output_size_wire;
endmodule 
