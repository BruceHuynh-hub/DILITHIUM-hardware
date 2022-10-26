module keccak_datapath(        
        clk,
        rst,
        din,
        dout,
        en_len,
        en_output_len,
        en_ctr,
        ein,
        c,
        d,
        final_segment,
        mode,
        sel_xor,
        sel_final,
        wr_state,
        ld_rdctr,
        en_rdctr,
        clr_len,
        sel_dec_size,
        spos,
        last_word,
        sel_piso,
        wr_piso,
        mode_ctrl,
        output_size,
        last_out_word
    );
    parameter [31:0]version  = 3;
    input clk;
    input rst;
    input [63:0] din;
    output [63:0] dout;
    input en_len;
    input en_output_len;
    input en_ctr;
    input ein;
    output [31:0] c;
    output [31:0] d;
    output final_segment;
    inout [1:0] mode;
    input sel_xor;
    input sel_final;
    input wr_state;
    input ld_rdctr;
    input en_rdctr;
    input clr_len;
    input sel_dec_size;
    input [1:0] spos;
    input last_word;
    input sel_piso;
    input wr_piso;
    input [1:0] mode_ctrl;
    input [10:0] output_size;
    input last_out_word;
    wire [31:0] din_a;
    wire [31:0] din_b;
    wire [1343:0] from_sipo;
    wire [1599:0] from_round;
    wire [1599:0] from_xor;
    wire [1599:0] to_round;
    wire [1343:0] to_piso;
    wire [4:0] rd_ctr;
    wire [63:0] rc;
    wire [63:0] swap_din;
    localparam zeros_128 = {((((256 - 0) < 0)) ? ((-(1) * (256 - 0))) : ((256 - 0))) {1'b0}} ;
    localparam zeros_256 = {((((512 - 0) < 0)) ? ((-(1) * (512 - 0 ))) : ((512 - 0))) {1'b0}} ;
    localparam zeros_512 = {((((1024 - 0) < 0)) ? ((-(1) * (1024 - 0))) : ((1024 - 0))) {1'b0}} ;
    localparam state_zero = {((((1599 - 0) < 0)) ? ((-( 1) * (1599 - 0))) : ((1599 - 0))) {1'b0}} ;
    wire [0:1343] se_result;
    wire [63:0] din_padded;
    wire [7:0] sel_pad_type_lookup;
    wire [7:0] sel_din_lookup;
    wire [7:0] sel_dout;
    wire [63:0] dout_wire;
    reg [31:0]c_wire;
    reg [31:0]d_len_wire;
    reg [1:0]shake_mode_wire;
    reg [31:0]block_size;
    reg [31:0]c_wire_in;
    localparam lookup_sel_lvl2_64bit_pad  = { 8'b10000000, 8'b01000000, 8'b00100000, 8'b00010000, 8'b00001000, 8'b00000100, 8'b00000010, 8'b00000001 }; 
    reg [7:0]sel_pad_location;
    localparam lookup_sel_lvl1_64bit_pad  = { 8'b00000000, 8'b10000000, 8'b11000000, 8'b11100000, 8'b11110000, 8'b11111000, 8'b11111100, 8'b11111110 };
    reg [7:0]sel_din;
    localparam lookup_sel_lvl1_64bit_out_zeropad  = { 8'b11111111, 8'b10000000, 8'b11000000, 8'b11100000, 8'b11110000, 8'b11111000, 8'b11111100, 8'b11111110 };
    function [31:0] switch_endian_byte_32_32_32;
        input [31:0] x;
        input [31:0] width;
        input [31:0] w;
        integer xseg;
        integer wseg;
        reg [31:0]retval;
        integer i;
    begin
        xseg = ( width / w );
        wseg = ( w / 8 );
        for ( i = 1 ; ( i >= 1 ) ; i = ( i - 1 ) )
        begin 
                integer j;
            for ( j = 0 ; ( j <= 3 ) ; j = ( j + 1 ) )
            begin 
                retval[( ( i * w ) - ( j * 8 ) ):( ( i * w ) - ( j * 8 ) )] = x[( ( i * w ) - ( ( wseg - j ) * 8 ) ):( ( i * w ) - ( ( wseg - j ) * 8 ) )];
            end
        end
        switch_endian_byte_32_32_32 = retval;
    end
    endfunction 
    reg [1599:0]from_concat;
    reg [1599:0]to_xor;
    reg [1599:0]to_register;
    genvar i;
    function  switch_endian_word_1_32_32;
        input x;
        input [31:0] width;
        input [31:0] w;
        integer xseg;
        reg [( width - 1 ):0]retval;
        integer i;
    begin
        xseg = ( width / w );
        for ( i = xseg ; ( i >= 1 ) ; i = ( i - 1 ) )
        begin 
            retval[( ( i * w ) - 1 ):( w * ( i - 1 ) )] = x;
        end
        switch_endian_word_1_32_32 = retval;
    end
    endfunction 
    generate
        if ( version == 2 ) 
        begin : rd2_fs_gen
            assign final_segment = din[0];
        end
    endgenerate
    generate
        if ( version == 3 ) 
        begin : rd3_fs_gen
            assign final_segment = din[63];
        end
    endgenerate
    always @ (  posedge clk)
    begin : segment_cntr_gen
        if ( clk == 1'b1 ) 
        begin
            if ( clr_len == 1'b1 ) 
            begin
                c_wire <= { 1'b0 };
            end
            else
            begin 
                if ( en_len == 1'b1 ) 
                begin
                    c_wire <= din[31:0];
                end
                else
                begin 
                    if ( en_ctr == 1'b1 ) 
                    begin
                        c_wire <= c_wire_in;
                    end
                end
            end
            if ( rst == 1'b1 ) 
            begin
                d_len_wire <= { 1'b0 };
                shake_mode_wire <= { 1'b0 };
            end
            else
            begin 
                if ( en_output_len == 1'b1 ) 
                begin
                    d_len_wire <= { 3'b000, din[60:32] };
                    shake_mode_wire <= din[62:61];
                end
            end
        end
    end
    always @ (  shake_mode_wire)
    begin
        if ( shake_mode_wire == 2'b00 ) 
        begin
            block_size <= 1088;
        end
        else
        begin 
            if ( shake_mode_wire == 2'b01 ) 
            begin
                block_size <= 576;
            end
            else
            begin 
                if ( shake_mode_wire == 2'b10 ) 
                begin
                    block_size <= 1344;
                end
                else
                begin 
                    if ( 1 ) // edautils Note : Review the 'if' condition. This is correct if it corresponds to the last 'else' section of the conditional concurrent signal assignment at src/keccak_datapath.vhd:123 
                    begin
                        block_size <= 1088;
                    end
                end
            end
        end
    end
    always @ (sel_dec_size or  c_wire or  block_size)
    begin
        if ( sel_dec_size == 1'b1 ) 
        begin
            c_wire_in <= (c_wire - block_size);
        end
        else
                c_wire_in <= (c_wire - 64);
    end
    assign c = c_wire;
    assign d = d_len_wire;
    assign mode = shake_mode_wire;
    assign sel_pad_type_lookup = lookup_sel_lvl2_64bit_pad[c_wire[5:3]];
    always @ (spos or sel_pad_type_lookup)
    begin
        if (spos[0] == 1'b0) 
        begin
            sel_pad_location <= {1'b0};
        end
        else
                sel_pad_location <= sel_pad_type_lookup;
    end
    assign sel_din_lookup = lookup_sel_lvl1_64bit_pad[c_wire[5:3]];
    always @ (  spos or  sel_din_lookup)
    begin
        if (spos[1] == 1'b1) 
        begin
            sel_din <= { 1'b1 };
        end
        else
            sel_din <= sel_din_lookup;
    end
    assign sel_dout = lookup_sel_lvl1_64bit_out_zeropad[output_size[5:3]];
    keccak_bytepad #(
            .w(64)
        ) pad_unit (
            .last_out_word(last_out_word),
            .last_word(last_word),
            .din_input(din),
            .din_output(din_padded),
            .dout_input(dout_wire),
            .dout_output(dout),
            .mode(shake_mode_wire),
            .sel_din(sel_din),
            .sel_dout(sel_dout),
            .sel_pad_location(sel_pad_location)
        );
    assign din_a = din_padded[31:0];
    assign din_b = din_padded[63:32];
    assign swap_din = { switch_endian_byte_32_32_32(din_a,32,32), switch_endian_byte_32_32_32(din_b,32,32) };
    sipo #(
            .n(1344),
            .m(64)
        ) in_buf (
            .clk(clk),
            .en(ein),
            .data_in(swap_din),
            .data_out(from_sipo)
        );
    always @ (  mode_ctrl)
    begin
        if (mode_ctrl == 2'b01) 
        begin
            from_concat <= {from_sipo[575:0], {1'b0}};
        end
        else
        begin 
            if ( mode_ctrl == 2'b10 ) 
                from_concat <= { from_sipo, { 1'b0 } };
            else
                    from_concat <= { from_sipo[1087:0], { 1'b0 } };
        end
    end
    always @ (sel_xor or  from_round)
    begin
        if ( sel_xor == 1'b1 ) 
        begin
            to_xor <= { 1'b0 };
        end
        else
            to_xor <= from_round;
    end
    assign from_xor = (from_concat ^ to_xor);
    always @ (sel_final or from_xor or from_round)
    begin
        if (sel_final == 1'b1) 
        begin
            to_register <= from_xor;
        end
        else
                to_register <= from_round;
    end
    regn #(
            .n(1600),
            .init({ 1'b0 })
        ) state (
            .clk(clk),
            .en(wr_state),
            .data_in(to_register),
            .rst(rst),
            .data_out(to_round));
            
    keccak_cons rd_cons (
            .addr(rd_ctr),
            .rc(rc)
        );
    keccak_round rd (
            .rc(rc),
            .rin(to_round),
            .rout(from_round)
        );
    countern #(
            .n(5),
            .step(1),
            .style(1)
        ) ctr (
            .clk(clk),
            .en(en_rdctr),
            .data_in(zeros_128),
            .load(ld_rdctr),
            .rst(rst),
            .data_out(rd_ctr)
        );
    generate
      for (i = 0 ; (i <= ((1344/64) - 1)); i = (i + 1))
        begin : out_gen
            assign se_result[i] = to_round[1599:(1600 - ((i + 1) * 64))];
            assign to_piso[1343:(1344 - ((i + 1) * 64))] = switch_endian_word_1_32_32();
        end
    endgenerate
    piso #(
            .n(1344),
            .m(64)
        ) out_buf (
            .clk(clk),
            .en(wr_piso),
            .data_in(to_piso),
            .sel(sel_piso),
            .data_out(dout_wire)
        );
endmodule
