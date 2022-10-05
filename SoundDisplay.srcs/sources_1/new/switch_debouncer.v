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
wire clock8hz;

wire Q1, Q2, Q2bar;

clock_divider eighthz(CLK,32'd6249999 ,clock8hz);
D_FF d1(clock8hz, BTN, Q1);
D_FF d2(clock8hz, Q1, Q2);

assign Q2bar = ~Q2;
assign debounced_btn = Q1 & Q2bar;

endmodule
