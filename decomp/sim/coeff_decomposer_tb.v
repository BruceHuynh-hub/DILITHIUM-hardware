// coeff_decomposer_tb.v

`timescale 1 ns/1 ps  // time-unit = 1 ns, precision = 1 ps

module coeff_decomposer_tb;

    reg  rst;
    reg  clk;
    reg  valid_i;
    reg  ready_o;
    
    reg [2:0]  sec_lvl;
    reg [23:0] di;
    wire [23:0] doa;
    wire [23:0] dob;
    wire valid_o;
    wire ready_i;

    parameter SEC_LVL_0  = 3'b000; 
    parameter SEC_LVL_2  = 3'b010; 
    
    parameter OUTPUT_W = 4;
    parameter COEFF_W  = 24; 

    
    localparam
        N1        = 18'd190464,
        N2        = 19'd523776,
        Q_N1_DIFF = 23'd8189953,
        Q_N2_DIFF = 23'd7856641,
        K         = 6'd41,
        M1        = 24'd11545611,
        M2        = 23'd4198404,
        Q         = 23'd8380417;

    coeff_decomposer CDTB(
        .rst(rst), 
        .clk(clk), 
        .sec_lvl(sec_lvl), 
        .valid_i(valid_i), 
        .ready_o(ready_o), 
        .di(di), 
        .doa(doa), 
        .dob(dob), 
        .valid_o(valid_o), 
        .ready_i(ready_i)
    );

    initial begin
        $dumpfile("cdtb.vcd");
        $dumpvars(0,coeff_decomposer_tb);
        di = 24'b0;
        rst     = 1'b1;
        clk     = 1'b0; 
        sec_lvl = SEC_LVL_0;
        
        #50
        rst     = 1'b0;

        valid_i = 1'b0; //testing with off
        ready_o = 1'b0;  

        #100 //all set to 0s
        valid_i = 1'b1;  //both on
        ready_o = 1'b1; 
        #20
        di = 24'd2312250; // 4
        #20
        di = 24'd2500010; // 5
        #20
        di = 24'd5000020; // 10
        #20
        di = 24'd8022100; // 15
        #20

        sec_lvl = SEC_LVL_2; // Changing security levels

        di = 24'd2312250; // 12
        #20
        di = 24'd2500010; // 13
        #20
        di = 24'd5000020; // 26
        #20
        di = 24'd8022100; // 42
        #20
        di = 24'b0; 

    end

    always  #5 clk = !clk;

/*
    initial begin
        $monitor("time %2, rst=%d clk=%d sec_lvl=%d valid_i=%d ready_o=%d di=%d", 
                  $time,   rst,   clk,   sec_lvl,    valid_i,   ready_o,   di);
        $monitor("time %2, doa=%d dob=%d valid_o=%d ready_i=%d",
                  $time,   doa,   dob,   valid_o,   ready_i);
    end
    */
endmodule