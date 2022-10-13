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
    input [2:0] boxcount,
    input [2:0] volume,
    input [1:0] cursor,
    input [1:0] selected,
    input [(96 * 6) - 1:0] waveform,
    input [(6 * 20) - 1:0] spectrogram,
    input [9:0] previous_highest_note_index,
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
    wire [15:0] lightgreen = 16'b0011111111100111;
    wire [15:0] lightlightgreen = 16'b0111111111101111;
    wire [15:0] orange = 16'b1111111111100000;
    wire [15:0] purple = 16'b1111100000011111;
    wire [15:0] blue = 16'b0000000000011111;
    wire [15:0] teal = 16'b0000011111111111;  
    
    //required for forloops      
    integer i;
    
    wire A,B,C,D,E,F,G,FLAT,SHARP,flat,sharp,two,three,four,five,six,seven,intune;
   
   assign A = (((y == 34) && ((x >= 36 && x < 60)))|| 
((y == 35) && ((x >= 36 && x < 60)))|| 
((y == 36) && ((x >= 36 && x < 60)))|| 
((y == 37) && ((x >= 36 && x < 60)))|| 
((y == 38) && ((x >= 36 && x < 48)|| (x >= 52 && x < 60)))|| 
((y == 39) && ((x >= 36 && x < 48)|| (x >= 52 && x < 60)))|| 
((y == 40) && ((x >= 36 && x < 48)|| (x >= 52 && x < 60)))|| 
((y == 41) && ((x >= 36 && x < 48)|| (x >= 52 && x < 60)))|| 
((y == 42) && ((x >= 36 && x < 48)|| (x >= 52 && x < 60)))|| 
((y == 43) && ((x >= 36 && x < 48)|| (x >= 52 && x < 60)))|| 
((y == 44) && ((x >= 36 && x < 48)|| (x >= 52 && x < 60)))|| 
((y == 45) && ((x >= 36 && x < 48)|| (x >= 52 && x < 60)))|| 
((y == 46) && ((x >= 36 && x < 60)))|| 
((y == 47) && ((x >= 36 && x < 60)))|| 
((y == 48) && ((x >= 36 && x < 60)))|| 
((y == 49) && ((x >= 36 && x < 60)))|| 
((y == 50) && ((x >= 36 && x < 48)|| (x >= 52 && x < 60)))|| 
((y == 51) && ((x >= 36 && x < 48)|| (x >= 52 && x < 60)))|| 
((y == 52) && ((x >= 36 && x < 48)|| (x >= 52 && x < 60)))|| 
((y == 53) && ((x >= 36 && x < 48)|| (x >= 52 && x < 60)))|| 
((y == 54) && ((x >= 36 && x < 48)|| (x >= 52 && x < 60)))|| 
((y == 55) && ((x >= 36 && x < 48)|| (x >= 52 && x < 60)))|| 
((y == 56) && ((x >= 36 && x < 48)|| (x >= 52 && x < 60)))|| 
((y == 57) && ((x >= 36 && x < 48)|| (x >= 52 && x < 60)))|| 
((y == 58) && ((x >= 36 && x < 48)|| (x >= 52 && x < 60)))|| 
((y == 59) && ((x >= 36 && x < 48)|| (x >= 52 && x < 60)))|| 
((y == 60) && ((x >= 36 && x < 48)|| (x >= 52 && x < 60)))|| 
((y == 61) && ((x >= 36 && x < 48)|| (x >= 52 && x < 60))));

assign B = (((y == 35) && ((x >= 37 && x < 53)))|| 
((y == 36) && ((x >= 37 && x < 53)))|| 
((y == 37) && ((x >= 37 && x < 53)))|| 
((y == 38) && ((x >= 37 && x < 53)))|| 
((y == 39) && ((x >= 37 && x < 41)|| (x >= 45 && x < 53)))|| 
((y == 40) && ((x >= 37 && x < 41)|| (x >= 45 && x < 53)))|| 
((y == 41) && ((x >= 37 && x < 41)|| (x >= 45 && x < 53)))|| 
((y == 42) && ((x >= 37 && x < 41)|| (x >= 45 && x < 53)))|| 
((y == 43) && ((x >= 37 && x < 53)))|| 
((y == 44) && ((x >= 37 && x < 53)))|| 
((y == 45) && ((x >= 37 && x < 53)))|| 
((y == 46) && ((x >= 37 && x < 53)))|| 
((y == 47) && ((x >= 37 && x < 49)))|| 
((y == 48) && ((x >= 37 && x < 49)))|| 
((y == 49) && ((x >= 37 && x < 49)))|| 
((y == 50) && ((x >= 37 && x < 49)))|| 
((y == 51) && ((x >= 37 && x < 41)|| (x >= 45 && x < 53)))|| 
((y == 52) && ((x >= 37 && x < 41)|| (x >= 45 && x < 53)))|| 
((y == 53) && ((x >= 37 && x < 41)|| (x >= 45 && x < 53)))|| 
((y == 54) && ((x >= 37 && x < 41)|| (x >= 45 && x < 53)))|| 
((y == 55) && ((x >= 37 && x < 41)|| (x >= 45 && x < 53)))|| 
((y == 56) && ((x >= 37 && x < 41)|| (x >= 45 && x < 53)))|| 
((y == 57) && ((x >= 37 && x < 41)|| (x >= 45 && x < 53)))|| 
((y == 58) && ((x >= 37 && x < 41)|| (x >= 45 && x < 53)))|| 
((y == 59) && ((x >= 37 && x < 53)))|| 
((y == 60) && ((x >= 37 && x < 53)))|| 
((y == 61) && ((x >= 37 && x < 53)))|| 
((y == 62) && ((x >= 37 && x < 53))));

assign C = (((y == 35) && ((x >= 37 && x < 53)))|| 
((y == 36) && ((x >= 37 && x < 53)))|| 
((y == 37) && ((x >= 37 && x < 53)))|| 
((y == 38) && ((x >= 37 && x < 53)))|| 
((y == 39) && ((x >= 37 && x < 53)))|| 
((y == 40) && ((x >= 37 && x < 53)))|| 
((y == 41) && ((x >= 37 && x < 53)))|| 
((y == 42) && ((x >= 37 && x < 53)))|| 
((y == 43) && ((x >= 37 && x < 45)))|| 
((y == 44) && ((x >= 37 && x < 45)))|| 
((y == 45) && ((x >= 37 && x < 45)))|| 
((y == 46) && ((x >= 37 && x < 45)))|| 
((y == 47) && ((x >= 37 && x < 45)))|| 
((y == 48) && ((x >= 37 && x < 45)))|| 
((y == 49) && ((x >= 37 && x < 45)))|| 
((y == 50) && ((x >= 37 && x < 45)))|| 
((y == 51) && ((x >= 37 && x < 45)))|| 
((y == 52) && ((x >= 37 && x < 45)))|| 
((y == 53) && ((x >= 37 && x < 45)))|| 
((y == 54) && ((x >= 37 && x < 45)))|| 
((y == 55) && ((x >= 37 && x < 53)))|| 
((y == 56) && ((x >= 37 && x < 53)))|| 
((y == 57) && ((x >= 37 && x < 53)))|| 
((y == 58) && ((x >= 37 && x < 53)))|| 
((y == 59) && ((x >= 37 && x < 53)))|| 
((y == 60) && ((x >= 37 && x < 53)))|| 
((y == 61) && ((x >= 37 && x < 53)))|| 
((y == 62) && ((x >= 37 && x < 53))));

assign D = (((y == 35) && ((x >= 37 && x < 53)))|| 
((y == 36) && ((x >= 37 && x < 53)))|| 
((y == 37) && ((x >= 37 && x < 53)))|| 
((y == 38) && ((x >= 37 && x < 53)))|| 
((y == 39) && ((x >= 37 && x < 57)))|| 
((y == 40) && ((x >= 37 && x < 57)))|| 
((y == 41) && ((x >= 37 && x < 57)))|| 
((y == 42) && ((x >= 37 && x < 57)))|| 
((y == 43) && ((x >= 37 && x < 45)|| (x >= 49 && x < 57)))|| 
((y == 44) && ((x >= 37 && x < 45)|| (x >= 49 && x < 57)))|| 
((y == 45) && ((x >= 37 && x < 45)|| (x >= 49 && x < 57)))|| 
((y == 46) && ((x >= 37 && x < 45)|| (x >= 49 && x < 57)))|| 
((y == 47) && ((x >= 37 && x < 45)|| (x >= 49 && x < 57)))|| 
((y == 48) && ((x >= 37 && x < 45)|| (x >= 49 && x < 57)))|| 
((y == 49) && ((x >= 37 && x < 45)|| (x >= 49 && x < 57)))|| 
((y == 50) && ((x >= 37 && x < 45)|| (x >= 49 && x < 57)))|| 
((y == 51) && ((x >= 37 && x < 45)|| (x >= 49 && x < 57)))|| 
((y == 52) && ((x >= 37 && x < 45)|| (x >= 49 && x < 57)))|| 
((y == 53) && ((x >= 37 && x < 45)|| (x >= 49 && x < 57)))|| 
((y == 54) && ((x >= 37 && x < 45)|| (x >= 49 && x < 57)))|| 
((y == 55) && ((x >= 37 && x < 57)))|| 
((y == 56) && ((x >= 37 && x < 57)))|| 
((y == 57) && ((x >= 37 && x < 57)))|| 
((y == 58) && ((x >= 37 && x < 57)))|| 
((y == 59) && ((x >= 37 && x < 53)))|| 
((y == 60) && ((x >= 37 && x < 53)))|| 
((y == 61) && ((x >= 37 && x < 53)))|| 
((y == 62) && ((x >= 37 && x < 53))));

assign E = (((y == 35) && ((x >= 37 && x < 53)))|| 
((y == 36) && ((x >= 37 && x < 53)))|| 
((y == 37) && ((x >= 37 && x < 53)))|| 
((y == 38) && ((x >= 37 && x < 53)))|| 
((y == 39) && ((x >= 37 && x < 53)))|| 
((y == 40) && ((x >= 37 && x < 53)))|| 
((y == 41) && ((x >= 37 && x < 53)))|| 
((y == 42) && ((x >= 37 && x < 53)))|| 
((y == 43) && ((x >= 37 && x < 45)))|| 
((y == 44) && ((x >= 37 && x < 45)))|| 
((y == 45) && ((x >= 37 && x < 45)))|| 
((y == 46) && ((x >= 37 && x < 45)))|| 
((y == 47) && ((x >= 37 && x < 53)))|| 
((y == 48) && ((x >= 37 && x < 53)))|| 
((y == 49) && ((x >= 37 && x < 53)))|| 
((y == 50) && ((x >= 37 && x < 53)))|| 
((y == 51) && ((x >= 37 && x < 45)))|| 
((y == 52) && ((x >= 37 && x < 45)))|| 
((y == 53) && ((x >= 37 && x < 45)))|| 
((y == 54) && ((x >= 37 && x < 45)))|| 
((y == 55) && ((x >= 37 && x < 53)))|| 
((y == 56) && ((x >= 37 && x < 53)))|| 
((y == 57) && ((x >= 37 && x < 53)))|| 
((y == 58) && ((x >= 37 && x < 53)))|| 
((y == 59) && ((x >= 37 && x < 53)))|| 
((y == 60) && ((x >= 37 && x < 53)))|| 
((y == 61) && ((x >= 37 && x < 53)))|| 
((y == 62) && ((x >= 37 && x < 53))));

assign F = (((y == 35) && ((x >= 37 && x < 53)))|| 
((y == 36) && ((x >= 37 && x < 53)))|| 
((y == 37) && ((x >= 37 && x < 53)))|| 
((y == 38) && ((x >= 37 && x < 53)))|| 
((y == 39) && ((x >= 37 && x < 53)))|| 
((y == 40) && ((x >= 37 && x < 53)))|| 
((y == 41) && ((x >= 37 && x < 53)))|| 
((y == 42) && ((x >= 37 && x < 53)))|| 
((y == 43) && ((x >= 37 && x < 45)))|| 
((y == 44) && ((x >= 37 && x < 45)))|| 
((y == 45) && ((x >= 37 && x < 45)))|| 
((y == 46) && ((x >= 37 && x < 45)))|| 
((y == 47) && ((x >= 37 && x < 53)))|| 
((y == 48) && ((x >= 37 && x < 53)))|| 
((y == 49) && ((x >= 37 && x < 53)))|| 
((y == 50) && ((x >= 37 && x < 53)))|| 
((y == 51) && ((x >= 37 && x < 45)))|| 
((y == 52) && ((x >= 37 && x < 45)))|| 
((y == 53) && ((x >= 37 && x < 45)))|| 
((y == 54) && ((x >= 37 && x < 45)))|| 
((y == 55) && ((x >= 37 && x < 45)))|| 
((y == 56) && ((x >= 37 && x < 45)))|| 
((y == 57) && ((x >= 37 && x < 45)))|| 
((y == 58) && ((x >= 37 && x < 45)))|| 
((y == 59) && ((x >= 37 && x < 45)))|| 
((y == 60) && ((x >= 37 && x < 45)))|| 
((y == 61) && ((x >= 37 && x < 45)))|| 
((y == 62) && ((x >= 37 && x < 45))));

assign five = (((y == 54) && ((x >= 60 && x < 68)))|| 
((y == 55) && ((x >= 60 && x < 68)))|| 
((y == 56) && ((x >= 60 && x < 62)))|| 
((y == 57) && ((x >= 60 && x < 62)))|| 
((y == 58) && ((x >= 60 && x < 66)))|| 
((y == 59) && ((x >= 60 && x < 66)))|| 
((y == 60) && ((x >= 66 && x < 68)))|| 
((y == 61) && ((x >= 66 && x < 68)))|| 
((y == 62) && ((x >= 60 && x < 66)))|| 
((y == 63) && ((x >= 60 && x < 66))));

assign FLAT = (((y == 30) && ((x >= 60 && x < 62)))|| 
((y == 31) && ((x >= 60 && x < 62)))|| 
((y == 32) && ((x >= 60 && x < 62)))|| 
((y == 33) && ((x >= 60 && x < 62)))|| 
((y == 34) && ((x >= 60 && x < 62)))|| 
((y == 35) && ((x >= 60 && x < 62)))|| 
((y == 36) && ((x >= 60 && x < 62)|| (x >= 63 && x < 66)))|| 
((y == 37) && ((x >= 60 && x < 67)))|| 
((y == 38) && ((x >= 60 && x < 67)))|| 
((y == 39) && ((x >= 60 && x < 64)|| (x >= 65 && x < 67)))|| 
((y == 40) && ((x >= 60 && x < 63)|| (x >= 64 && x < 67)))|| 
((y == 41) && ((x >= 60 && x < 62)|| (x >= 63 && x < 67)))|| 
((y == 42) && ((x >= 60 && x < 66)))|| 
((y == 43) && ((x >= 60 && x < 65))));

assign flat = (((y == 6) && ((x >= 22 && x < 26)))|| 
((y == 7) && ((x >= 22 && x < 26)))|| 
((y == 8) && ((x >= 22 && x < 27)))|| 
((y == 9) && ((x >= 22 && x < 27)))|| 
((y == 10) && ((x >= 22 && x < 28)))|| 
((y == 11) && ((x >= 22 && x < 29)))|| 
((y == 12) && ((x >= 23 && x < 29)))|| 
((y == 13) && ((x >= 24 && x < 30)))|| 
((y == 14) && ((x >= 24 && x < 30)))|| 
((y == 15) && ((x >= 25 && x < 31)))|| 
((y == 16) && ((x >= 25 && x < 31)))|| 
((y == 17) && ((x >= 26 && x < 32)))|| 
((y == 18) && ((x >= 26 && x < 32)))|| 
((y == 19) && ((x >= 27 && x < 33)))|| 
((y == 20) && ((x >= 27 && x < 34)))|| 
((y == 21) && ((x >= 28 && x < 34)))|| 
((y == 22) && ((x >= 28 && x < 34)))|| 
((y == 23) && ((x >= 29 && x < 34)))|| 
((y == 24) && ((x >= 30 && x < 34))));

assign four = (((y == 54) && ((x >= 64 && x < 66)))|| 
((y == 55) && ((x >= 64 && x < 66)))|| 
((y == 56) && ((x >= 62 && x < 66)))|| 
((y == 57) && ((x >= 62 && x < 66)))|| 
((y == 58) && ((x >= 60 && x < 62)|| (x >= 64 && x < 66)))|| 
((y == 59) && ((x >= 60 && x < 62)|| (x >= 64 && x < 66)))|| 
((y == 60) && ((x >= 60 && x < 68)))|| 
((y == 61) && ((x >= 60 && x < 68)))|| 
((y == 62) && ((x >= 64 && x < 66)))|| 
((y == 63) && ((x >= 64 && x < 66))));

assign G = (((y == 35) && ((x >= 37 && x < 57)))|| 
((y == 36) && ((x >= 37 && x < 57)))|| 
((y == 37) && ((x >= 37 && x < 57)))|| 
((y == 38) && ((x >= 37 && x < 57)))|| 
((y == 39) && ((x >= 37 && x < 57)))|| 
((y == 40) && ((x >= 37 && x < 57)))|| 
((y == 41) && ((x >= 37 && x < 57)))|| 
((y == 42) && ((x >= 37 && x < 57)))|| 
((y == 43) && ((x >= 37 && x < 45)))|| 
((y == 44) && ((x >= 37 && x < 45)))|| 
((y == 45) && ((x >= 37 && x < 45)))|| 
((y == 46) && ((x >= 37 && x < 45)))|| 
((y == 47) && ((x >= 37 && x < 45)|| (x >= 49 && x < 57)))|| 
((y == 48) && ((x >= 37 && x < 45)|| (x >= 49 && x < 57)))|| 
((y == 49) && ((x >= 37 && x < 45)|| (x >= 49 && x < 57)))|| 
((y == 50) && ((x >= 37 && x < 45)|| (x >= 49 && x < 57)))|| 
((y == 51) && ((x >= 37 && x < 45)|| (x >= 53 && x < 57)))|| 
((y == 52) && ((x >= 37 && x < 45)|| (x >= 53 && x < 57)))|| 
((y == 53) && ((x >= 37 && x < 45)|| (x >= 53 && x < 57)))|| 
((y == 54) && ((x >= 37 && x < 45)|| (x >= 53 && x < 57)))|| 
((y == 55) && ((x >= 37 && x < 57)))|| 
((y == 56) && ((x >= 37 && x < 57)))|| 
((y == 57) && ((x >= 37 && x < 57)))|| 
((y == 58) && ((x >= 37 && x < 57)))|| 
((y == 59) && ((x >= 37 && x < 57)))|| 
((y == 60) && ((x >= 37 && x < 57)))|| 
((y == 61) && ((x >= 37 && x < 57)))|| 
((y == 62) && ((x >= 37 && x < 57))));

assign intune = (((y == 0) && ((x >= 44 && x < 50)))|| 
((y == 1) && ((x >= 44 && x < 50)))|| 
((y == 2) && ((x >= 44 && x < 50)))|| 
((y == 3) && ((x >= 44 && x < 50)))|| 
((y == 4) && ((x >= 44 && x < 50)))|| 
((y == 5) && ((x >= 44 && x < 50)))|| 
((y == 6) && ((x >= 44 && x < 50)))|| 
((y == 7) && ((x >= 44 && x < 50)))|| 
((y == 8) && ((x >= 44 && x < 50)))|| 
((y == 9) && ((x >= 44 && x < 50)))|| 
((y == 10) && ((x >= 44 && x < 50)))|| 
((y == 11) && ((x >= 44 && x < 50)))|| 
((y == 12) && ((x >= 44 && x < 50)))|| 
((y == 13) && ((x >= 44 && x < 50)))|| 
((y == 14) && ((x >= 44 && x < 50)))|| 
((y == 15) && ((x >= 44 && x < 50)))|| 
((y == 16) && ((x >= 44 && x < 50)))|| 
((y == 17) && ((x >= 44 && x < 50)))|| 
((y == 18) && ((x >= 44 && x < 50)))|| 
((y == 19) && ((x >= 44 && x < 50)))|| 
((y == 20) && ((x >= 44 && x < 50)))|| 
((y == 21) && ((x >= 44 && x < 50))));

assign seven = (((y == 54) && ((x >= 60 && x < 66)))|| 
((y == 55) && ((x >= 60 && x < 66)))|| 
((y == 56) && ((x >= 66 && x < 68)))|| 
((y == 57) && ((x >= 66 && x < 68)))|| 
((y == 58) && ((x >= 66 && x < 68)))|| 
((y == 59) && ((x >= 66 && x < 68)))|| 
((y == 60) && ((x >= 64 && x < 66)))|| 
((y == 61) && ((x >= 64 && x < 66)))|| 
((y == 62) && ((x >= 64 && x < 66)))|| 
((y == 63) && ((x >= 64 && x < 66))));

assign SHARP = (((y == 32) && ((x >= 61 && x < 63)|| (x >= 65 && x < 67)))|| 
((y == 33) && ((x >= 61 && x < 63)|| (x >= 65 && x < 67)))|| 
((y == 34) && ((x >= 61 && x < 63)|| (x >= 65 && x < 67)))|| 
((y == 35) && ((x >= 61 && x < 63)|| (x >= 65 && x < 70)))|| 
((y == 36) && ((x >= 61 && x < 67)))|| 
((y == 37) && ((x >= 58 && x < 63)|| (x >= 65 && x < 67)))|| 
((y == 38) && ((x >= 61 && x < 63)|| (x >= 65 && x < 67)))|| 
((y == 39) && ((x >= 61 && x < 63)|| (x >= 65 && x < 70)))|| 
((y == 40) && ((x >= 61 && x < 67)))|| 
((y == 41) && ((x >= 58 && x < 63)|| (x >= 65 && x < 67)))|| 
((y == 42) && ((x >= 61 && x < 63)|| (x >= 65 && x < 67)))|| 
((y == 43) && ((x >= 61 && x < 63)|| (x >= 65 && x < 67))));

assign sharp = (((y == 7) && ((x >= 70 && x < 74)))|| 
((y == 8) && ((x >= 69 && x < 74)))|| 
((y == 9) && ((x >= 68 && x < 74)))|| 
((y == 10) && ((x >= 68 && x < 74)))|| 
((y == 11) && ((x >= 67 && x < 73)))|| 
((y == 12) && ((x >= 67 && x < 73)))|| 
((y == 13) && ((x >= 66 && x < 72)))|| 
((y == 14) && ((x >= 65 && x < 71)))|| 
((y == 15) && ((x >= 65 && x < 71)))|| 
((y == 16) && ((x >= 64 && x < 70)))|| 
((y == 17) && ((x >= 64 && x < 69)))|| 
((y == 18) && ((x >= 63 && x < 69)))|| 
((y == 19) && ((x >= 63 && x < 69)))|| 
((y == 20) && ((x >= 62 && x < 68)))|| 
((y == 21) && ((x >= 61 && x < 67)))|| 
((y == 22) && ((x >= 61 && x < 67)))|| 
((y == 23) && ((x >= 61 && x < 66)))|| 
((y == 24) && ((x >= 61 && x < 66)))|| 
((y == 25) && ((x >= 61 && x < 65))));

assign six = (((y == 54) && ((x >= 62 && x < 66)))|| 
((y == 55) && ((x >= 62 && x < 66)))|| 
((y == 56) && ((x >= 60 && x < 62)))|| 
((y == 57) && ((x >= 60 && x < 62)))|| 
((y == 58) && ((x >= 60 && x < 66)))|| 
((y == 59) && ((x >= 60 && x < 66)))|| 
((y == 60) && ((x >= 60 && x < 62)|| (x >= 66 && x < 68)))|| 
((y == 61) && ((x >= 60 && x < 62)|| (x >= 66 && x < 68)))|| 
((y == 62) && ((x >= 62 && x < 66)))|| 
((y == 63) && ((x >= 62 && x < 66))));

assign three = (((y == 54) && ((x >= 62 && x < 66)))|| 
((y == 55) && ((x >= 62 && x < 66)))|| 
((y == 56) && ((x >= 60 && x < 62)|| (x >= 66 && x < 68)))|| 
((y == 57) && ((x >= 60 && x < 62)|| (x >= 66 && x < 68)))|| 
((y == 58) && ((x >= 64 && x < 66)))|| 
((y == 59) && ((x >= 64 && x < 66)))|| 
((y == 60) && ((x >= 60 && x < 62)|| (x >= 66 && x < 68)))|| 
((y == 61) && ((x >= 60 && x < 62)|| (x >= 66 && x < 68)))|| 
((y == 62) && ((x >= 62 && x < 66)))|| 
((y == 63) && ((x >= 62 && x < 66))));

assign two = (((y == 54) && ((x >= 62 && x < 66)))|| 
((y == 55) && ((x >= 62 && x < 66)))|| 
((y == 56) && ((x >= 60 && x < 62)|| (x >= 66 && x < 68)))|| 
((y == 57) && ((x >= 60 && x < 62)|| (x >= 66 && x < 68)))|| 
((y == 58) && ((x >= 64 && x < 66)))|| 
((y == 59) && ((x >= 64 && x < 66)))|| 
((y == 60) && ((x >= 62 && x < 64)))|| 
((y == 61) && ((x >= 62 && x < 64)))|| 
((y == 62) && ((x >= 60 && x < 68)))|| 
((y == 63) && ((x >= 60 && x < 68))));



    always @ (posedge CLK) begin 
        //drawing anything you want
        //it is black unless changed
        oled_data <= black;


        //FOR THE TUNER (to move it)
        if (sw[15]) begin
            // draw lowest priority first
            if (previous_highest_note_index == 13) begin
                if (C || two) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 14) begin
                if (D || FLAT || two) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 15) begin
                if (D || two) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 16) begin
                if (E || FLAT || two) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 17) begin
                if (E || two) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 18) begin
                if (F || two) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 19) begin
                if (F || SHARP || two) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 20) begin
                if (G || two) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 21) begin
                if (A || FLAT || two) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 22 || previous_highest_note_index == 23) begin
                if (A || two) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 24) begin
                if (B || FLAT || two) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 25) begin
                if (B || two) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 26 || previous_highest_note_index == 27) begin
                if (C || three) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 28) begin
                if (D || FLAT || three) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 29 || previous_highest_note_index == 30 || previous_highest_note_index == 31) begin
                if (previous_highest_note_index == 29) begin
                    if (flat) begin
                        oled_data <= red;
                    end
                end
                if (previous_highest_note_index == 31) begin
                    if (sharp) begin
                        oled_data <= red;
                    end
                end
                if (D || three) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune && previous_highest_note_index == 30) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 32) begin
                if (E || FLAT || three) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 33 || previous_highest_note_index == 34) begin
                if (previous_highest_note_index == 33) begin
                    if (flat) begin
                        oled_data <= red;
                    end
                end
                if (E || three) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune && previous_highest_note_index == 34) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 35 || previous_highest_note_index == 36 || previous_highest_note_index == 37) begin
                if (previous_highest_note_index == 35) begin
                    if (flat) begin
                        oled_data <= red;
                    end
                end
                if (previous_highest_note_index == 37) begin
                    if (sharp) begin
                        oled_data <= red;
                    end
                end
                if (F || three) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune && previous_highest_note_index == 36) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 38) begin
                if (F || SHARP || three) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 39 || previous_highest_note_index == 40 || previous_highest_note_index == 41) begin
                if (previous_highest_note_index == 39) begin
                    if (flat) begin
                        oled_data <= red;
                    end
                end
                if (previous_highest_note_index == 41) begin
                    if (sharp) begin
                        oled_data <= red;
                    end
                end
                if (G || three) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune && previous_highest_note_index == 40) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 42 || previous_highest_note_index == 43) begin
                if (A || FLAT || three) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 44 || previous_highest_note_index == 45 || previous_highest_note_index == 46) begin
                if (previous_highest_note_index == 44) begin
                    if (flat) begin
                        oled_data <= red;
                    end
                end
                if (previous_highest_note_index == 46) begin
                    if (sharp) begin
                        oled_data <= red;
                    end
                end
                if (A || three) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune && previous_highest_note_index == 45) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 47 || previous_highest_note_index == 48) begin
                if (previous_highest_note_index == 47) begin
                    if (flat) begin
                        oled_data <= red;
                    end
                end
                if (A || three) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune && previous_highest_note_index == 48) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 49) begin
                if (B || three) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 50 || previous_highest_note_index == 51) begin
                if (B || three) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 52) begin
                if (C || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 53 || previous_highest_note_index == 54) begin
                if (C || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 55) begin
                if (C || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 56) begin
                if (D || FLAT || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 57) begin
                if (D || FLAT || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 58) begin
                if (D || FLAT || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 59) begin
                if (D || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 60) begin
                if (D || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 61 || previous_highest_note_index == 62) begin
                if (D || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 63) begin
                if (E || FLAT || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 64) begin
                if (E || FLAT || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 65) begin
                if (E || FLAT || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 66) begin
                if (E || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 67 || previous_highest_note_index == 68) begin
                if (E || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 69) begin
                if (E || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 70) begin
                if (F || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 71 || previous_highest_note_index == 72) begin
                if (F || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 73) begin
                if (F || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 74) begin
                if (F || SHARP|| four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 75 || previous_highest_note_index == 76) begin
                if (F || SHARP || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index == 77) begin
                if (F || SHARP|| four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 78 && previous_highest_note_index <= 79) begin
                if (G || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 80) begin
                if (G || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 81 && previous_highest_note_index <= 82) begin
                if (G || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 83 && previous_highest_note_index <= 84) begin
                if (A || FLAT || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 85) begin
                if (A || FLAT || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 86 && previous_highest_note_index <= 87) begin
                if (A || FLAT || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 88 && previous_highest_note_index <= 89) begin
                if (A || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 90) begin
                if (A || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 91 && previous_highest_note_index <= 92) begin
                if (A || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 93 && previous_highest_note_index <= 94) begin
                if (B || FLAT || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 95 || previous_highest_note_index == 96) begin
                if (B || FLAT || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 97 && previous_highest_note_index <= 98) begin
                if (B || FLAT || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 99 && previous_highest_note_index <= 100) begin
                if (B || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 101) begin
                if (B || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 102 && previous_highest_note_index <= 104) begin
                if (B || four) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 105 && previous_highest_note_index <= 106) begin
                if (C || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 107) begin
                if (C || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 108 && previous_highest_note_index <= 110) begin
                if (C || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 111 && previous_highest_note_index <= 112) begin
                if (D || FLAT || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 113 || previous_highest_note_index == 114) begin
                if (D || FLAT || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 115 && previous_highest_note_index <= 117) begin
                if (D || FLAT || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 118 && previous_highest_note_index <= 119) begin
                if (D || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 120) begin
                if (D || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 121 && previous_highest_note_index <= 123) begin
                if (D || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 124 && previous_highest_note_index <= 126) begin
                if (E || FLAT || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 127 || previous_highest_note_index == 128) begin
                if (E || FLAT || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 129 && previous_highest_note_index <= 131) begin
                if (E || FLAT || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 132 && previous_highest_note_index <= 134) begin
                if (E || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 135) begin
                if (E || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 136 && previous_highest_note_index <= 139) begin
                if (E || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 140 && previous_highest_note_index <= 142) begin
                if (F || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 143) begin
                if (F || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 144 && previous_highest_note_index <= 147) begin
                if (F || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 148 && previous_highest_note_index <= 150) begin
                if (F || SHARP || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 151 || previous_highest_note_index == 152) begin
                if (F || SHARP || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 153 && previous_highest_note_index <= 156) begin
                if (F || SHARP || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 157 && previous_highest_note_index <= 159) begin
                if (G || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 160 || previous_highest_note_index == 161) begin
                if (G || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 162 && previous_highest_note_index <= 165) begin
                if (G || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 166 && previous_highest_note_index <= 169) begin
                if (A || FLAT || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 170) begin
                if (A || FLAT || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 171 && previous_highest_note_index <= 175) begin
                if (A || FLAT || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 176 && previous_highest_note_index <= 179) begin
                if (A || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 180) begin
                if (A || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 181 && previous_highest_note_index <= 186) begin
                if (A || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 187 && previous_highest_note_index <= 190) begin
                if (B || FLAT || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 191) begin
                if (B || FLAT || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 192 && previous_highest_note_index <= 196) begin
                if (B || FLAT || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 197 && previous_highest_note_index <= 201) begin
                if (B || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 202) begin
                if (B || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 203 && previous_highest_note_index <= 208) begin
                if (B || five) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 209 && previous_highest_note_index <= 213) begin
                if (C || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 214) begin
                if (C || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 215 && previous_highest_note_index <= 221) begin
                if (C || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 222 && previous_highest_note_index <= 226) begin
                if (D || FLAT || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 227) begin
                if (D || FLAT || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 228 && previous_highest_note_index <= 233) begin
                if (D || FLAT || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 234 && previous_highest_note_index <= 239) begin
                if (D || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 240 || previous_highest_note_index == 241) begin
                if (D || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 242 && previous_highest_note_index <= 248) begin
                if (D || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 249 && previous_highest_note_index <= 254) begin
                if (E || FLAT || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 255) begin
                if (E || FLAT || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 256 && previous_highest_note_index <= 263) begin
                if (E || FLAT || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 264 && previous_highest_note_index <= 269) begin
                if (E || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 270) begin
                if (E || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 271 && previous_highest_note_index <= 278) begin
                if (E || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 279 && previous_highest_note_index <= 285) begin
                if (F || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 286) begin
                if (F || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 287 && previous_highest_note_index <= 295) begin
                if (F || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 296 && previous_highest_note_index <= 302) begin
                if (F || SHARP || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 303) begin
                if (F || SHARP || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 304 && previous_highest_note_index <= 312) begin
                if (F || SHARP || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 313 && previous_highest_note_index <= 320) begin
                if (G || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 321) begin
                if (G || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 322 && previous_highest_note_index <= 330) begin
                if (G || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 331 && previous_highest_note_index <= 339) begin
                if (A || FLAT || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 340) begin
                if (A || FLAT || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 341 && previous_highest_note_index <= 350) begin
                if (A || FLAT || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 351 && previous_highest_note_index <= 359) begin
                if (A || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 360 || previous_highest_note_index == 361) begin
                if (A || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 362 && previous_highest_note_index <= 371) begin
                if (A || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 372 && previous_highest_note_index <= 381) begin
                if (B || FLAT || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 382) begin
                if (B || FLAT || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 383 && previous_highest_note_index <= 393) begin
                if (B || FLAT || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 394 && previous_highest_note_index <= 403) begin
                if (B || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 404 || previous_highest_note_index == 405) begin
                if (B || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 406 && previous_highest_note_index <= 416) begin
                if (B || six) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 417 && previous_highest_note_index <= 427) begin
                if (C || seven) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 428 || previous_highest_note_index == 429) begin
                if (C || seven) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 430 && previous_highest_note_index <= 442) begin
                if (C || seven) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 443 && previous_highest_note_index <= 453) begin
                if (D || FLAT || seven) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 454) begin
                if (D || FLAT || seven) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 455 && previous_highest_note_index <= 467) begin
                if (D || FLAT || seven) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 468 && previous_highest_note_index <= 480) begin
                if (D || seven) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 481) begin
                if (D || seven) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 482 && previous_highest_note_index <= 497) begin
                if (D || seven) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index >= 498 && previous_highest_note_index <= 509) begin
                if (E || FLAT || seven) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (flat) begin
                    oled_data <= red;
                end
            end
            else if (previous_highest_note_index == 510) begin
                if (E || FLAT || seven) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (intune) begin
                    oled_data <= green;
                end
            end
            else if (previous_highest_note_index >= 511) begin
                if (E || FLAT || seven) begin
                    begin
                        oled_data <= white;
                    end
                end
                if (sharp) begin
                    oled_data <= red;
                end
            end
        end

        //FOR CONTROLLING MENU
        else if (sw[2]) begin
            // draw lowest priority first
            if ((x >= 10 && x <= 20) && (y >= 27 && y <= 37) || 
                (x >= 42 && x <= 52) && (y >= 27 && y <= 37) ||
                (x >= 74 && x <= 84) && (y >= 27 && y <= 37)) begin
                oled_data <= white;
                end
            if (((x >= 13 && x <= 17) && (y >= 30 && y <= 34) && cursor == 2'd0) || 
                ((x >= 45 && x <= 49) && (y >= 30 && y <= 34) && cursor == 2'd1) ||
                ((x >= 77 && x <= 81) && (y >= 30 && y <= 34) && cursor == 2'd2)) begin
                oled_data <= green;
                end
            if (((x >= 14 && x <= 16) && (y >= 31 && y <= 33) && selected == 2'd0) || 
                ((x >= 46 && x <= 48) && (y >= 31 && y <= 33) && selected == 2'd1) ||
                ((x >= 78 && x <= 80) && (y >= 31 && y <= 33) && selected == 2'd2)) begin
                oled_data <= red;
                end
        end

        // FOR WAVEFORM
        else if (selected == 0) begin
            for (i = 1; i < 96; i = i + 1) begin
                if (y == 32) begin
                    oled_data <= white;
                end
                if (y < 32 && y >= waveform[(i*6) +: 6] && x == i) begin
                    oled_data <= green;
                end
                if (y < 25 && y >= waveform[(i*6) +: 6] && x == i) begin
                    oled_data <= orange;
                end
                if (y < 18 && y >= waveform[(i*6) +: 6] && x == i) begin
                    oled_data <= red;
                end
                if (y > 32 && y <= waveform[(i*6) +: 6] && x == i) begin
                    oled_data <= lightgreen;
                end
                if (y > 39 && y <= waveform[(i*6) +: 6] && x == i) begin
                    oled_data <= orange;
                end
                if (y > 46 && y <= waveform[(i*6) +: 6] && x == i) begin
                    oled_data <= red;
                end
            end
        end

        
        else if (selected == 1) begin
            //FOR OLED TASK A
            if (sw[0] || (volume >= 3'd1 && sw == 0)) begin
                if ((((x >= 2 && x <= 93) && (y == 2 || y == 61)) || 
                    ((y >= 2 && y <= 61) && ( x == 2 || x == 93))) &&
                    (sw[0] || (volume >= 3'd1 && sw == 0)))begin
                    oled_data <= red;
                    end
                else if ((((x >= 4 && x <= 91) && ((y >= 4 && y <= 6) || (y >= 57 && y <= 59))) || 
                    ((y >= 4 && y <= 59) && ((x >= 4 && x <= 6) || (x >= 89 && x <= 91))))
                    && (sw[0] || (volume >= 3'd2 && sw == 0)))begin
                    oled_data <= orange;
                    end
                else if ((((x >= 8 && x <= 87) && (y == 8 || y == 55)) || 
                    ((y >= 8 && y <= 55) && ( x == 8 || x == 87))) &&
                    ((bordercount >= 3'd1 && sw[0]) || (volume >= 3'd3 && sw == 0)))begin
                    oled_data <= green;
                    end
                else if ((((x >= 10 && x <= 85) && (y == 10 || y == 53)) || 
                    ((y >= 10 && y <= 53) && ( x == 10 || x == 85))) &&
                    ((bordercount >= 3'd2 && sw[0]) || (volume >= 3'd4 && sw == 0)))begin
                    oled_data <= green;
                    end
                else if ((((x >= 12 && x <= 83) && (y == 12 || y == 51)) || 
                    ((y >= 12 && y <= 51) && ( x == 12 || x == 83))) &&
                    ((bordercount >= 3'd3 && sw[0]) || (volume >= 3'd5 && sw == 0)))begin
                    oled_data <= green;
                    end
                else if ((((x >= 14 && x <= 81) && (y == 14 || y == 49)) || 
                    ((y >= 14 && y <= 49) && ( x == 14 || x == 81))) &&
                    (bordercount >= 3'd4 && sw[0]))begin
                    oled_data <= green;
                    end  
            end
           
            // FOR OLED TASK B
            else if (sw[1]) begin
                if((x >= 43 && x <= 53) && (y >= 55 && y <= 60) && sw[1]) begin
                    oled_data <= red;
                end
                else if((x >= 43 && x <= 53) && (y >= 47 && y <= 52) && sw[1]) begin
                    oled_data <= orange;
                end
                else if((x >= 43 && x <= 53) && (y >= 39 && y <= 44) && boxcount >= 3'd1 && sw[1]) begin
                    oled_data <= green;
                end
                else if((x >= 43 && x <= 53) && (y >= 31 && y <= 36) && boxcount >= 3'd2 && sw[1]) begin
                    oled_data <= lightgreen;
                end
                else if((x >= 43 && x <= 53) && (y >= 23 && y <= 28) && boxcount >= 3'd3 && sw[1]) begin
                    oled_data <= lightlightgreen;
                end
            end
        end
        
        //FOR SPECTROGRAM  
        else if (selected == 2) begin
            if (x >= 8 && x <= 10 && y >= spectrogram[0*6 +:6]) begin
                oled_data <= white;
            end
            else if (x >= 12 && x <= 14 && y >= spectrogram[1*6 +:6]) begin
                oled_data <= white;
            end
            else if (x >= 16 && x <= 18 && y >= spectrogram[2*6 +:6]) begin
                oled_data <= white;
            end
            else if (x >= 20 && x <= 22 && y >= spectrogram[3*6 +:6]) begin
                oled_data <= white;
            end
            else if (x >= 24 && x <= 26 && y >= spectrogram[4*6 +:6]) begin
                oled_data <= white;
            end
            else if (x >= 28 && x <= 30 && y >= spectrogram[5*6 +:6]) begin
                oled_data <= white;
            end
            else if (x >= 32 && x <= 34 && y >= spectrogram[6*6 +:6]) begin
                oled_data <= white;
            end
            else if (x >= 36 && x <= 38 && y >= spectrogram[7*6 +:6]) begin
                oled_data <= white;
            end
            else if (x >= 40 && x <= 42 && y >= spectrogram[8*6 +:6]) begin
                oled_data <= white;
            end
            else if (x >= 44 && x <= 46 && y >= spectrogram[9*6 +:6]) begin
                oled_data <= white;
            end
            else if (x >= 48 && x <= 50 && y >= spectrogram[10*6 +:6]) begin
                oled_data <= white;
            end
            else if (x >= 52 && x <= 54 && y >= spectrogram[11*6 +:6]) begin
                oled_data <= white;
            end
            else if (x >= 56 && x <= 58 && y >= spectrogram[12*6 +:6]) begin
                oled_data <= white;
            end
            else if (x >= 60 && x <= 62 && y >= spectrogram[13*6 +:6]) begin
                oled_data <= white;
            end
            else if (x >= 64 && x <= 66 && y >= spectrogram[14*6 +:6]) begin
                oled_data <= white;
            end
            else if (x >= 68 && x <= 70 && y >= spectrogram[15*6 +:6]) begin
                oled_data <= white;
            end
            else if (x >= 72 && x <= 74 && y >= spectrogram[16*6 +:6]) begin
                oled_data <= white;
            end
            else if (x >= 76 && x <= 78 && y >= spectrogram[17*6 +:6]) begin
                oled_data <= white;
            end
            else if (x >= 80 && x <= 82 && y >= spectrogram[18*6 +:6]) begin
                oled_data <= white;
            end
            else if (x >= 84 && x <= 86 && y >= spectrogram[19*6 +:6]) begin
                oled_data <= white;
            end
        end    
    end  
endmodule
