`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.09.2022 14:27:08
// Design Name: 
// Module Name: clock_divider
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


module clock_divider(
    input CLK,
    input [31:0] div,
    output reg slow_clk = 0
);

reg [31:0] COUNT = 32'd0;

always @ (posedge CLK) begin
    COUNT <= ((COUNT >= div) ? 32'd0 : COUNT + 1);
    slow_clk <= ((COUNT >= div) ? ~slow_clk : slow_clk);
    end
endmodule
