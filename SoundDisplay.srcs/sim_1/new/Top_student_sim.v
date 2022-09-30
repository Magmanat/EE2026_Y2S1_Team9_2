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
    reg pin3;
    wire pin1;
    wire pin4;
    wire [11:0] mic_in;
    
    Top_Student dut(CLK, pin3, pin1, pin4, mic_in);
    initial begin
        CLK = 0;
    end
    always begin
        #5 CLK = ~CLK;
    end
endmodule
