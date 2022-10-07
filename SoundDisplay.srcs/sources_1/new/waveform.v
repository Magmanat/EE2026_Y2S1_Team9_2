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
    input clk20k,
    input [1:0] selected,
    input [11:0] mic_in,
    output reg [(95 * 6) - 1:0] waveform
);

reg [4:0] num;

always @ (posedge clk20k) begin
    if (selected == 0) begin
        if (mic_in[11]) begin
            num = mic_in[10:0] / 64;
            waveform[5:0] = 31 + num;
        end     
        else begin
            waveform[5:0] = num;
        end
        waveform = waveform << 6;      
    end
end

endmodule
