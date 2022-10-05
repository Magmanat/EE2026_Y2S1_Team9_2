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
    input enable,
    input BTNU,
    input [12:0] pixel_index,
    output reg led,
    output reg[2:0] bordercount = 0
);

reg [31:0] counter = 32'd0;
wire debounced_BTNU;
switch_debouncer OTA_debounce(CLK, BTNU, debounced_BTNU);


always @ (posedge CLK, posedge debounced_BTNU) begin
    // check if button pressed (its a pulse even if held because of debounce)
    if (debounced_BTNU == 1 && enable) begin
        counter <= 32'd300000000;
    end

    else begin
    // set led and minus counter
        if (counter == 32'd0 || !enable) begin
            counter <= 32'd0;
            led <= 0;
        end
        else if (counter > 32'd0 && enable) begin
            counter <= counter - 1'b1;
            led <= 1;
        end
    end
end


always @ (posedge debounced_BTNU) begin
    if (enable) begin
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
