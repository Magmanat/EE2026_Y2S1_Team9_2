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
    output debounced_btn,
    output reg repeated_btn = 0
);
wire clock8hz;

wire Q1, Q2, Q2bar;

reg [3:0] counter;
always @ (posedge clock8hz) begin
    if (Q1) begin
        counter <= counter < 6 ? counter + 1 : counter;
    end else begin
        counter <= 0;
    end
    if (counter >= 6 && !debounced_btn) begin
        repeated_btn <= ~repeated_btn;
    end else begin
        repeated_btn <= 0;
    end
end


clock_divider fourthz(CLK,32'd8 ,clock8hz);
D_FF d1(clock8hz, BTN, Q1);
D_FF d2(clock8hz, Q1, Q2);

assign Q2bar = ~Q2;
assign debounced_btn = Q1 & Q2bar;

endmodule
