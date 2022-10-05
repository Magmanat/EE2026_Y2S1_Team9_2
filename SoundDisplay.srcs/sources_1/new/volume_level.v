`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.10.2022 22:41:19
// Design Name: 
// Module Name: volume_level
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


module volume_level(
input clk20k,
input [11:0] mic_in,
output reg [2:0] volume = 0,
output reg [4:0] led
    );
    reg [3:0] maxout;
    reg [31:0] count2000 = 0;
    reg [11:0] max = 0;
    //integer count = 0;
    always @ (posedge clk20k) begin
        count2000 <= (count2000 == 1999) ? 0 : count2000 + 1;
        max <= count2000 == 0 ? mic_in : (mic_in > max ? mic_in : max);
        if (count2000 == 0) begin
            maxout = max[10:7];
            if (maxout == 4'd0) begin
                volume <= 3'd0;
                led <= 5'b00000;
            end
            else if (maxout >= 4'd1 && maxout <= 4'd2) begin
                volume <= 3'd1;
                led <= 5'b00001;
            end
            else if (maxout >= 4'd3 && maxout <= 4'd5) begin
                volume <= 3'd2;
                led <= 5'b00011;
            end
            else if (maxout >= 4'd6 && maxout <= 4'd8) begin
                volume <= 3'd3;
                led <= 5'b00111;
            end
            else if (maxout >= 4'd9 && maxout <= 4'd11) begin
                volume <= 3'd4;
                led <= 5'b01111;
            end
            else if (maxout >= 4'd12 && maxout <= 4'd15) begin
                volume <= 3'd5;
                led <= 5'b11111;
            end
        end//end for if count2000 == 0
    end//end for always @ posedge clk 20KHZ   
endmodule
