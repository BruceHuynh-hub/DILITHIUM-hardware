module keccak_bytepad(
        din_input,
        din_output,
        sel_pad_location,
        sel_din,
        last_word,
        mode,
        dout_input,
        dout_output,
        sel_dout,
        last_out_word
    );
    parameter [31:0]w  = 64;
    input [(w - 1):0]din_input;
    output [(w - 1):0]din_output;
    input [((w / 8) - 1):0]sel_pad_location;
    input [((w / 8) - 1):0]sel_din;
    input last_word;
    input [1:0]mode;
    input [(w - 1):0]dout_input;
    output [(w - 1):0]dout_output;
    input [((w / 8) - 1):0]sel_dout;
    input last_out_word;
    wire [1:0]sel_last_mux;
    genvar i;
    reg [((w / 8) - 1):0]byte_pad_wire;
    reg [(w - 1):0]din_output;
    reg [7:0]first_byte;
    reg [7:0]first_last_byte;
    reg [(w - 1):0]dout_output_padded;
    reg [(w - 1):0]dout_output;
    generate
        for (i = (( w / 8 ) - 1) ; (i >= 1) ; i = (i - 1))
        begin : byte_pad_gen
            always @ (sel_pad_location or  first_byte)
            begin
                if (sel_pad_location[i] == 1'b1) 
                begin
                    byte_pad_wire[i] <= first_byte;
                end
                else
                  byte_pad_wire[i] <= 8'b0;
            end
            always @ (sel_din or  din_input or  byte_pad_wire)
            begin
                if (sel_din[i] == 1'b1) 
                begin
                    din_output[(( 8 * (i + 1)) - 1):(8 * i)] <= din_input[((8 * ( i + 1 )) - 1):(8 * i)];
                end
                else
                	din_output[((8 * (i + 1)) - 1 ):(8 * i)] <= byte_pad_wire[i];
            end
        end
    endgenerate
    assign sel_last_mux = {last_word, sel_pad_location[0]};
    always @ (mode)
    begin
        if ((mode == 2'b11 ) | (mode == 2'b10 )) 
        begin
            first_byte <= 8'b00011111;
            first_last_byte <= 8'b10011111;
        end
        else begin
        	first_byte <= 8'b00000110;
        	first_last_byte <= 8'b10000110;
        end
    end
    always @ (sel_last_mux)
    begin
        if (sel_last_mux == 2'b00) 
        begin
            byte_pad_wire[0] <= 2'b00;
        end
        else
        begin 
            if (sel_last_mux == 2'b01) 
            begin
                byte_pad_wire[0] <= first_byte;
            end
            else
            begin 
                if (sel_last_mux == 2'b10) 
                begin
                    byte_pad_wire[0] <= 8'b10000000;
                end
                else
                begin 
                    byte_pad_wire[0] <= first_last_byte;
                end
            end
        end
    end
    always @ (sel_din or  din_input or  byte_pad_wire)
    begin
        if (sel_din[0] == 1'b1) 
        begin
            din_output[7:0] <= din_input[7:0];
        end
        else
                din_output[7:0] <= byte_pad_wire[0];
    end
    generate
      for (i = (( w / 8) - 1) ; (i >= 0) ; i = (i - 1))
        begin : byte_out_zeropad_gen
            always @ (  sel_dout or  dout_input)
            begin
                if ( sel_dout[i] == 1'b1 ) 
                begin
                    dout_output_padded[((8 * (i + 1)) - 1):(8 * i)] <= dout_input[( (8 * (i + 1)) - 1):(8 * i)];
                end
                else
                        dout_output_padded[(( 8 * (i + 1 )) - 1):(8 * i)] <= 2'b00;
            end
        end
    endgenerate
    always @ (last_out_word or  dout_output_padded or  dout_input)
    begin
        if (last_out_word == 1'b1) 
        begin
            dout_output <= dout_output_padded;
        end
        else
                dout_output <= dout_input;
    end
endmodule 
