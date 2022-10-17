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
    input [15:0] sw,
    input [11:0] mic_in,
    input btnC,
    input btnL,
    input btnR,
    output reg [(96 * 6) - 1:0] waveform,
    output [4:0] waveform_sampling
);

assign waveform_sampling = custom_clk_speed / 1000;

reg [5:0] num;
reg [7:0] counter;
reg [31:0] custom_clk_speed = 31'd1000;
wire custom_clk;
clock_divider  custom_clock(CLK, custom_clk_speed, custom_clk);

reg [(96 * 6) - 1:0] intermediate_waveform;
reg [6:0] counter = 0;
reg pause = 0;

reg button = 0;
always @ (posedge CLK) begin
    if (selected == 0 && !sw[2]) begin
        button <= btnL || btnR;
    end
end

always @ (posedge button) begin
    if (btnL) begin
        custom_clk_speed <= custom_clk_speed == 1000 ? 20000 : custom_clk_speed - 1000;
    end else if (btnR) begin
        custom_clk_speed <= custom_clk_speed == 20000 ? 1000 : custom_clk_speed + 1000;
    end
end

always @ (posedge btnC) begin
    if (selected == 0 && !sw[2]) begin
        pause <= ~pause;
    end
end

always @ (posedge custom_clk) begin
    if (selected == 0) begin
        num = mic_in[10:0] / 11'd64;
        if (counter == 95) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
        if (counter == 0) begin
            if (!pause) begin
                waveform <= intermediate_waveform;
            end
        end
        if (mic_in[11]) begin
            intermediate_waveform[6:0] = 6'd32 - num;
        end     
        else begin
            intermediate_waveform[6:0] = 6'd63 - num;
        end
        intermediate_waveform = intermediate_waveform << 6;      
    end
end



endmodule
