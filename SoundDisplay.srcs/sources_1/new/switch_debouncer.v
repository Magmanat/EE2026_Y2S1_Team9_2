`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.10.2022 14:19:40
// Design Name: 
// Module Name: switch_debouncer
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


module switch_debouncer(
    input CLK,
    input BTN,
    output debounced_btn
);
wire clock4hz;

wire Q1, Q2, Q2bar;

clock_divider fourthz(CLK,32'd12499999 ,clock4hz);
D_FF d1(clock4hz, BTN, Q1);
D_FF d2(clock4hz, Q1, Q2);

assign Q2bar = ~Q2;
assign debounced_btn = Q1 & Q2bar;

endmodule
