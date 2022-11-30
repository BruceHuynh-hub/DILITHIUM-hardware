module decomposer_sim();

    reg       clk; 
    reg       rst; 
    reg [2:0] sec_lvl;
    
    reg valid_i; 
    reg ready_o; 
    
    wire ready_i; 
    wire valid_o; 
    
    parameter SEC_LVL_0  = 3'b000; 
    parameter SEC_LVL_2  = 3'b010; 
    
    parameter OUTPUT_W = 4;
    parameter COEFF_W  = 24; 
    
    reg [OUTPUT_W*COEFF_W - 1: 0] di; 
    
    reg [COEFF_W - 1: 0] di_0; 
    reg [COEFF_W - 1: 0] di_1; 
    reg [COEFF_W - 1: 0] di_2; 
    reg [COEFF_W - 1: 0] di_3; 
    
    wire [OUTPUT_W*COEFF_W - 1: 0] doa;
    wire [OUTPUT_W*COEFF_W - 1: 0] dob;
    
    initial begin 
    
        clk     = 1'b0; 
        rst     = 1'b1; 
        sec_lvl = SEC_LVL_0; 
        
        valid_i = 1'b0; 
        ready_o = 1'b0;  
        
        di_0 = 24'b0;
        di_1 = 24'b0;
        di_2 = 24'b0;
        di_3 = 24'b0; 
        
        di = {di_3, di_2, di_1, di_0};   
        
        #10 ready_o = 1'b1;
                                
    end 
    
    initial begin 
        $monitor("simtime = %g, doa = %h", $time, doa); 
        $monitor("simtime = %g, dob = %h", $time, dob); 
        
        $monitor("simtime = %g, ready_i = %b", $time, ready_i); 
        $monitor("simtime = %g, valid_o = %b", $time, valid_o); 
    end 
    
    always begin 
        #5 clk = ~clk;  
    end 
    
    decomposer_unit decomposer_unit_DUT(
        .rst(rst), 
        .clk(clk), 
        .sec_lvl(sec_lvl), 
        .valid_i(valid_i), 
        .ready_i(ready_i), 
        .di(di), 
        .doa(doa), 
        .dob(dob), 
        .valid_o(valid_o), 
        .ready_o(ready_o));
    
endmodule
