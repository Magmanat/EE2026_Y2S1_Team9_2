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

//reg [5:0] num, transnum;

always @ (posedge clk20k) begin
    if (selected == 0) begin
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
    end
end

endmodule
