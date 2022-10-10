`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.10.2022 14:19:40
// Design Name: 
// Module Name: waveform
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


module waveform(
    input CLK,
    input [1:0] selected,
    input [11:0] mic_in,
    output reg [(96 * 6) - 1:0] waveform
);

reg [5:0] num;
reg [7:0] counter;
reg [31:0] custom_clk_speed = 31'd96;
wire custom_clk;
clock_divider  custom_clock(CLK, custom_clk_speed, custom_clk);

always @ (posedge custom_clk) begin
    if (selected == 0) begin
        num = mic_in[10:0] / 11'd64;
        if (mic_in[11]) begin
            waveform[6:0] = 6'd32 - num;
        end     
        else begin
            waveform[6:0] = 6'd63 - num;
        end
        waveform = waveform << 6;      
    end
end



endmodule
