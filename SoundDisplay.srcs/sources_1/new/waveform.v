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
    input btnU,
    input btnD,
    input repeated_btnL,
    input repeated_btnR,
    output reg [(96 * 6) - 1:0] waveform,
    output [4:0] waveform_sampling,
    output reg [1:0] mode = 0
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

reg loudsounddetected = 0;

reg [5:0] loudestsound = 0;

always @ (posedge CLK) begin
    if (selected == 1 && !sw[2]) begin
        button <= btnL || btnR || repeated_btnL || repeated_btnR || btnU || btnD || loudsounddetected || btnC;
    end
end

always @ (posedge button) begin
    if (btnL || repeated_btnL) begin
        if (!pause) begin
            custom_clk_speed <= custom_clk_speed == 1000 ? 20000 : custom_clk_speed - 1000;
        end 
    end else if (btnR || repeated_btnR) begin
        if (!pause) begin
            custom_clk_speed <= custom_clk_speed == 20000 ? 1000 : custom_clk_speed + 1000;
        end 
    end else if (btnD) begin
        mode <= mode - 1;
    end else if (btnU) begin
        mode <= mode + 1;
    end else if (loudsounddetected) begin
        pause <= 1;
    end else if (btnC) begin
        pause <= ~pause;
    end
end

always @ (posedge custom_clk) begin
    if (selected == 1) begin
        num = mic_in[10:0] / 11'd64;
        
        if (counter == 95) begin
            counter <= 0;
        end else begin
            if (num > loudestsound && mic_in[11]) begin
                loudestsound <= num;
            end else if (32 - num > loudestsound && !mic_in[11]) begin
                loudestsound <= 32 - num;
            end
            counter <= counter + 1;
        end
        if (counter == 0) begin
            loudsounddetected = sw[0] && (loudestsound >= 25);
            if (!pause) begin
                waveform <= intermediate_waveform;
            end 
            loudestsound <= 0;
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
