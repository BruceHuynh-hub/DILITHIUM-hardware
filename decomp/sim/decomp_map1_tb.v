`timescale 1ns / 1ps
// decomp_map1_tb.v
// time-unit = 1 ns, precision = 1 ps

module decomp_map1_tb;

    reg  [2:0]  sec_lvl;
    reg  [22:0] din;
    wire [5:0]  dout;

    parameter SEC_LVL_0  = 3'b000; 
    parameter SEC_LVL_2  = 3'b010; 

    initial begin
        $dumpfile("DM1TB.vcd");
        $dumvars(0,decomp_map1_tb);

        sec_lvl=SEC_LVL_0;  din=23'd261889;  #10
        sec_lvl=SEC_LVL_0;  din=23'd785665;  #10
        sec_lvl=SEC_LVL_0;  din=23'd1309441;  #10
        sec_lvl=SEC_LVL_0;  din=23'd1833217;  #10
        sec_lvl=SEC_LVL_0;  din=23'd2356993;  #10
        sec_lvl=SEC_LVL_0;  din=23'd2880769;  #10
        sec_lvl=SEC_LVL_0;  din=23'd3404545;  #10
        sec_lvl=SEC_LVL_0;  din=23'd3928321;  #10
        sec_lvl=SEC_LVL_0;  din=23'd4452097;  #10
        sec_lvl=SEC_LVL_0;  din=23'd4975873;  #10
        sec_lvl=SEC_LVL_0;  din=23'd5499649;  #10
        sec_lvl=SEC_LVL_0;  din=23'd6023425;  #10
        sec_lvl=SEC_LVL_0;  din=23'd6547201;  #10
        sec_lvl=SEC_LVL_0;  din=23'd7070977;  #10
        sec_lvl=SEC_LVL_0;  din=23'd7594753;  #10
        sec_lvl=SEC_LVL_0;  din=23'd8118529;  #10

        sec_lvl=SEC_LVL_0;  din=23'd95233;  #10
        sec_lvl=SEC_LVL_0;  din=23'd285697;  #10
        sec_lvl=SEC_LVL_0;  din=23'd476161;  #10
        sec_lvl=SEC_LVL_0;  din=23'd666625;  #10
        sec_lvl=SEC_LVL_0;  din=23'd857089;  #10
        sec_lvl=SEC_LVL_0;  din=23'd1047553;  #10
        sec_lvl=SEC_LVL_0;  din=23'd1238017;  #10
        sec_lvl=SEC_LVL_0;  din=23'd1428481;  #10
        sec_lvl=SEC_LVL_0;  din=23'd1618945;  #10

        sec_lvl=SEC_LVL_0;  din=23'd1809409;  #10
        sec_lvl=SEC_LVL_0;  din=23'd1999873;  #10
        sec_lvl=SEC_LVL_0;  din=23'd2190337;  #10
        sec_lvl=SEC_LVL_0;  din=23'd2380801;  #10
        sec_lvl=SEC_LVL_0;  din=23'd2571265;  #10
        sec_lvl=SEC_LVL_0;  din=23'd2761729;  #10
        sec_lvl=SEC_LVL_0;  din=23'd2952193;  #10
        sec_lvl=SEC_LVL_0;  din=23'd3142657;  #10
        sec_lvl=SEC_LVL_0;  din=23'd3333121;  #10
        sec_lvl=SEC_LVL_0;  din=23'd3523585;  #10
        sec_lvl=SEC_LVL_0;  din=23'd3714049;  #10
        sec_lvl=SEC_LVL_0;  din=23'd3904513;  #10
        sec_lvl=SEC_LVL_0;  din=23'd4094977;  #10
        sec_lvl=SEC_LVL_0;  din=23'd4285441;  #10
        sec_lvl=SEC_LVL_0;  din=23'd4475905;  #10
        sec_lvl=SEC_LVL_0;  din=23'd4666369;  #10
        sec_lvl=SEC_LVL_0;  din=23'd4856833;  #10
        sec_lvl=SEC_LVL_0;  din=23'd5047297;  #10
        sec_lvl=SEC_LVL_0;  din=23'd5237761;  #10
        sec_lvl=SEC_LVL_0;  din=23'd5428225;  #10
        sec_lvl=SEC_LVL_0;  din=23'd5618689;  #10
        sec_lvl=SEC_LVL_0;  din=23'd5809153;  #10
        sec_lvl=SEC_LVL_0;  din=23'd5999617;  #10
        sec_lvl=SEC_LVL_0;  din=23'd6190081;  #10
        sec_lvl=SEC_LVL_0;  din=23'd6380545;  #10
        sec_lvl=SEC_LVL_0;  din=23'd6571009;  #10
        sec_lvl=SEC_LVL_0;  din=23'd6761473;  #10
        sec_lvl=SEC_LVL_0;  din=23'd6951937;  #10
        sec_lvl=SEC_LVL_0;  din=23'd7142401;  #10
        sec_lvl=SEC_LVL_0;  din=23'd7332865;  #10
        sec_lvl=SEC_LVL_0;  din=23'd7523329;  #10
        sec_lvl=SEC_LVL_0;  din=23'd7713793;  #10
        sec_lvl=SEC_LVL_0;  din=23'd7904257;  #10
        sec_lvl=SEC_LVL_0;  din=23'd8094721;  #10
        sec_lvl=SEC_LVL_0;  din=23'd8285185;  #10

        //sec lvl 2
        sec_lvl=SEC_LVL_2;  din=23'd261889;  #10
        sec_lvl=SEC_LVL_2;  din=23'd785665;  #10
        sec_lvl=SEC_LVL_2;  din=23'd1309441;  #10
        sec_lvl=SEC_LVL_2;  din=23'd1833217;  #10
        sec_lvl=SEC_LVL_2;  din=23'd2356993;  #10
        sec_lvl=SEC_LVL_2;  din=23'd2880769;  #10
        sec_lvl=SEC_LVL_2;  din=23'd3404545;  #10
        sec_lvl=SEC_LVL_2;  din=23'd3928321;  #10
        sec_lvl=SEC_LVL_2;  din=23'd4452097;  #10
        sec_lvl=SEC_LVL_2;  din=23'd4975873;  #10
        sec_lvl=SEC_LVL_2;  din=23'd5499649;  #10
        sec_lvl=SEC_LVL_2;  din=23'd6023425;  #10
        sec_lvl=SEC_LVL_2;  din=23'd6547201;  #10
        sec_lvl=SEC_LVL_2;  din=23'd7070977;  #10
        sec_lvl=SEC_LVL_2;  din=23'd7594753;  #10
        sec_lvl=SEC_LVL_2;  din=23'd8118529;  #10

        sec_lvl=SEC_LVL_2;  din=23'd95233;  #10
        sec_lvl=SEC_LVL_2;  din=23'd285697;  #10
        sec_lvl=SEC_LVL_2;  din=23'd476161;  #10
        sec_lvl=SEC_LVL_2;  din=23'd666625;  #10
        sec_lvl=SEC_LVL_2;  din=23'd857089;  #10
        sec_lvl=SEC_LVL_2;  din=23'd1047553;  #10
        sec_lvl=SEC_LVL_2;  din=23'd1238017;  #10
        sec_lvl=SEC_LVL_2;  din=23'd1428481;  #10
        sec_lvl=SEC_LVL_2;  din=23'd1618945;  #10

        sec_lvl=SEC_LVL_2;  din=23'd1809409;  #10
        sec_lvl=SEC_LVL_2;  din=23'd1999873;  #10
        sec_lvl=SEC_LVL_2;  din=23'd2190337;  #10
        sec_lvl=SEC_LVL_2;  din=23'd2380801;  #10
        sec_lvl=SEC_LVL_2;  din=23'd2571265;  #10
        sec_lvl=SEC_LVL_2;  din=23'd2761729;  #10
        sec_lvl=SEC_LVL_2;  din=23'd2952193;  #10
        sec_lvl=SEC_LVL_2;  din=23'd3142657;  #10
        sec_lvl=SEC_LVL_2;  din=23'd3333121;  #10
        sec_lvl=SEC_LVL_2;  din=23'd3523585;  #10
        sec_lvl=SEC_LVL_2;  din=23'd3714049;  #10
        sec_lvl=SEC_LVL_2;  din=23'd3904513;  #10
        sec_lvl=SEC_LVL_2;  din=23'd4094977;  #10
        sec_lvl=SEC_LVL_2;  din=23'd4285441;  #10
        sec_lvl=SEC_LVL_2;  din=23'd4475905;  #10
        sec_lvl=SEC_LVL_2;  din=23'd4666369;  #10
        sec_lvl=SEC_LVL_2;  din=23'd4856833;  #10
        sec_lvl=SEC_LVL_2;  din=23'd5047297;  #10
        sec_lvl=SEC_LVL_2;  din=23'd5237761;  #10
        sec_lvl=SEC_LVL_2;  din=23'd5428225;  #10
        sec_lvl=SEC_LVL_2;  din=23'd5618689;  #10
        sec_lvl=SEC_LVL_2;  din=23'd5809153;  #10
        sec_lvl=SEC_LVL_2;  din=23'd5999617;  #10
        sec_lvl=SEC_LVL_2;  din=23'd6190081;  #10
        sec_lvl=SEC_LVL_2;  din=23'd6380545;  #10
        sec_lvl=SEC_LVL_2;  din=23'd6571009;  #10
        sec_lvl=SEC_LVL_2;  din=23'd6761473;  #10
        sec_lvl=SEC_LVL_2;  din=23'd6951937;  #10
        sec_lvl=SEC_LVL_2;  din=23'd7142401;  #10
        sec_lvl=SEC_LVL_2;  din=23'd7332865;  #10
        sec_lvl=SEC_LVL_2;  din=23'd7523329;  #10
        sec_lvl=SEC_LVL_2;  din=23'd7713793;  #10
        sec_lvl=SEC_LVL_2;  din=23'd7904257;  #10
        sec_lvl=SEC_LVL_2;  din=23'd8094721;  #10
        sec_lvl=SEC_LVL_2;  din=23'd8285185;  
    end

    initial begin
        $monitor("time %2, sec_lvl=%d din=%d dout=%d", $time, sec_lvl, din, dout);
    end

    decomp_map1 DM1TB(
        .sec_lvl(sec_lvl), 
        .din(din), 
        .dout(dout)
    );

endmodule
