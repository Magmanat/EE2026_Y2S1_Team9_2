`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.10.2022 14:19:40
// Design Name: 
// Module Name: OTA
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


module OTA(
    input CLK,
    input [15:0] sw,
    input [1:0] selected,
    input btnU,
    input [12:0] pixel_index,
    output reg led,
    output reg[2:0] bordercount = 0
);

reg [31:0] counter = 32'd0;

always @ (posedge CLK, posedge btnU) begin
    // check if button pressed (its a pulse even if held because of debounce)
    // IF SWITCH 0, make counter 0
    if (sw != 16'b1) begin
        counter <= 0;
    end
    if (btnU == 1'b1 && sw == 16'b1 && selected == 0 && led == 0) begin
        counter <= 32'd300000000;
    end

    else begin
    // set led and minus counter
        led <= 0;
        if (counter > 32'd0 && sw == 16'b0000000000000001 && selected == 0) begin
            counter <= counter - 1'b1;
            led <= 1;
        end
    end
end


always @ (posedge btnU) begin
    if (selected == 0 && sw == 16'b0000000000000001 && led == 0) begin
        if (bordercount == 3'd4) begin
            bordercount <= 3'd0;
            // set all to 0
        end
        else begin
            bordercount <= bordercount + 1'b1;
        end
    end
end


endmodule
