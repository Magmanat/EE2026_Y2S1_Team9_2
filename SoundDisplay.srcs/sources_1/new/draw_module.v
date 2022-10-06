`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.10.2022 20:23:31
// Design Name: 
// Module Name: draw_module
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


module draw_module(
    input CLK,
    input [15:0] sw,
    input [12:0] pixel_index,
    input [2:0] bordercount,
    input [2:0] volume,
    output reg [15:0] oled_data
        );
        
    //find pixel coordinates
    wire [6:0] x;
    wire [5:0] y;
    assign x = (pixel_index % 96); //from 0 to 95
    assign y = (pixel_index / 96); //from 0 to 63
    
    //create colours
    wire [15:0] white = 16'b1111111111111111;
    wire [15:0] black = 16'd0;
    wire [15:0] red = 16'b1111100000000000;
    wire [15:0] green = 16'b0000011111100000;
    wire [15:0] orange = 16'b1111111111100000;
    wire [15:0] purple = 16'b1111100000011111;
    wire [15:0] blue = 16'b0000000000011111;
    wire [15:0] teal = 16'b0000011111111111;        
    
    always @ (posedge CLK) begin 
        //drawing anything you want
        //it is black unless changed
        oled_data <= black;
        
        //FOR OLED TASK A
        if (sw[0]) begin
            if ((((x >= 2 && x <= 93) && (y == 2 || y == 61)) || 
                ((y >= 2 && y <= 61) && ( x == 2 || x == 93))) &&
                (sw[0] || volume >= 3'd1))begin
                oled_data <= red;
                end
            if ((((x >= 4 && x <= 91) && ((y >= 4 && y <= 6) || (y >= 57 && y <= 59))) || 
                ((y >= 4 && y <= 59) && ((x >= 4 && x <= 6) || (x >= 89 && x <= 91))))
                && (sw[0] || volume >= 3'd2))begin
                oled_data <= orange;
                end
            if ((((x >= 8 && x <= 87) && (y == 8 || y == 55)) || 
                ((y >= 8 && y <= 55) && ( x == 8 || x == 87))) &&
                ((bordercount >= 3'd1 && sw[0]) || volume >= 3'd3))begin
                oled_data <= green;
                end
            if ((((x >= 10 && x <= 85) && (y == 10 || y == 53)) || 
                ((y >= 10 && y <= 53) && ( x == 10 || x == 85))) &&
                ((bordercount >= 3'd2 && sw[0]) || volume >= 3'd4))begin
                oled_data <= green;
                end
            if ((((x >= 12 && x <= 83) && (y == 12 || y == 51)) || 
                ((y >= 12 && y <= 51) && ( x == 12 || x == 83))) &&
                ((bordercount >= 3'd3 && sw[0]) || volume >= 3'd5))begin
                oled_data <= green;
                end
            if ((((x >= 14 && x <= 81) && (y == 14 || y == 49)) || 
                ((y >= 14 && y <= 49) && ( x == 14 || x == 81))) &&
                (bordercount >= 3'd4 && sw[0]))begin
                oled_data <= green;
                end  
        end
        // FOR OLED TASK B    
        
    end  
endmodule
