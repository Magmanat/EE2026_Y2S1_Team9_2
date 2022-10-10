`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.09.2022 14:37:46
// Design Name: 
// Module Name: Top_student_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Top_student_sim(
    );
    reg CLK;
    reg btnL;
    reg btnC;
    reg btnR;
    wire btnLdebounce;
    wire btnCdebounce;
    wire btnRdebounce;
    
    
    switch_debouncer db2(CLK, btnC, btnCdebounce);
    switch_debouncer db3(CLK, btnL, btnLdebounce);
    switch_debouncer db4(CLK, btnR, btnRdebounce);
    wire [1:0] cursor;
    wire [1:0] selected;
    reg enable;
    main_menu mm(enable, btnLdebounce, btnCdebounce, btnRdebounce, cursor, selected);    
    initial begin
        CLK = 0; #30;
        btnL = 0;
        enable = 1;
        #350000000
        btnL = 1;
        #1
        btnL = 0;
        #1
        btnL = 1;
        #1
        btnL = 0;
        #1
        btnL = 1;
        #1000000;
        btnC = 1;
        
    end
    always begin
        #5 CLK = ~CLK;
    end
endmodule
