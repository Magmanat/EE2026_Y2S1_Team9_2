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
    output reg [(95 * 6) - 1:0] waveform
);

reg [5:0] num;
reg [7:0] counter;
reg [31:0] custom_clk_speed = 31'd1000000;
wire custom_clk;
clock_divider  custom_clock(CLK, custom_clk_speed, custom_clk);

always @ (posedge custom_clk) begin
    if (selected == 0) begin
<<<<<<< HEAD
        num = mic_in[10:0] / 11'd64;
        if (mic_in[11]) begin
            waveform[5:0] = 6'd32 - num;
        end     
        else begin
            waveform[5:0] = 6'd63 - num;
        end
        waveform = waveform << 6;      
=======
//    //take reading 96 times a second
//        if (counter == 207) begin
//            counter <= 0;
//            //if counter increment, update x and y            
//            waveform_y <= mic_in / 64;
//            if (waveform_x == 95) begin
//                waveform_x <= 0;
//            end
//            else begin
//                waveform_x <= waveform_x + 1;
//            end
//        end        
//        else begin
//            counter <= counter + 1;
//        end
    //take reading 96 times a second   
    /////////////////////////////////////
//        num = mic_data[11:6];
//        transnum = num > `HEIGHT/2 ? num : `HEIGHT - num; // get value above x-axis
//        if (yreflect < transnum && yreflect > `HEIGHT - transnum) begin
//            ygre = (transnum <= `HEIGHT/2 + greRange && transnum >= `HEIGHT/2 - greRange);
    /////////////////////////////////////
        waveform[5:0] = mic_in / 65;
        waveform = waveform << 6;
        // y <= mic_in / 64;      
        // if (x == 95) begin
        //     x <= 0;
        // end
        // else begin
        //     x <= x + 1;
        // end            
>>>>>>> main
    end
end



endmodule
