module keccak_top(
        rst,
        clk,
        src_ready,
        src_read,
        dst_ready,
        dst_write,
        din,
        dout
    );
    parameter [31:0]hs  = 256;
    input rst;
    input clk;
    input src_ready;
    output src_read;
    input dst_ready;
    output dst_write;
    input [63:0] din;
    output [63:0] dout;
    localparam version  = 3;
    wire ein;
    wire final_segment;
    wire sel_xor;
    wire sel_final;
    wire wr_state;
    wire en_ctr;
    wire [31:0] c;
    wire [31:0] d;
    wire en_len;
    wire en_output_len;
    wire ld_rdctr;
    wire en_rdctr;
    wire sel_piso;
    wire last_block;
    wire wr_piso;
    wire [1:0] spos;
    wire [1:0] mode;
    wire [1:0] mode_ctrl;
    wire sel_dec_size;
    wire clr_len;
    wire last_word;
    wire last_out_word;
    wire [10:0] output_size;
    keccak_control control_gen (
            .clk(clk),
            .clr_len(clr_len),
            .dst_ready(dst_ready),
            .ein(ein),
            .en_ctr(en_ctr),
            .en_len(en_len),
            .en_output_len(en_output_len),
            .en_rdctr(en_rdctr),
            .last_out_word(last_out_word),
            .last_word(last_word),
            .ld_rdctr(ld_rdctr),
            .mode_ctrl(mode_ctrl),
            .output_size(output_size),
            .rst(rst),
            .sel_dec_size(sel_dec_size),
            .sel_final(sel_final),
            .sel_xor(sel_xor),
            .spos(spos),
            .src_ready(src_ready),
            .wr_piso(wr_piso),
            .wr_state(wr_state),
            .c(c),
            .d(d),
            .dst_write(dst_write),
            .final_segment(final_segment),
            .mode(mode),
            .src_read(src_read),
            .sel_out(sel_piso)
        );
    keccak_datapath #(
            .version(3)
        ) datapath_gen (
            .clk(clk),
            .clr_len(clr_len),
            .din(din),
            .ein(ein),
            .en_ctr(en_ctr),
            .en_len(en_len),
            .en_output_len(en_output_len),
            .en_rdctr(en_rdctr),
            .last_out_word(last_out_word),
            .last_word(last_word),
            .ld_rdctr(ld_rdctr),
            .mode_ctrl(mode_ctrl),
            .output_size(output_size),
            .rst(rst),
            .sel_dec_size(sel_dec_size),
            .sel_final(sel_final),
            .sel_piso(sel_piso),
            .sel_xor(sel_xor),
            .spos(spos),
            .wr_piso(wr_piso),
            .wr_state(wr_state),
            .c(c),
            .d(d),
            .dout(dout),
            .final_segment(final_segment),
            .mode(mode)
        );
endmodule 
