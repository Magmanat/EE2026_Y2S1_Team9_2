`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.10.2022 14:19:40
// Design Name: 
// Module Name: main_menu
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


module main_menu(
    input CLK,
    input enable,
    input sw10,
    input btnL,
    input btnC,
    input btnR,
    output reg [1:0] cursor = 2'd0,
    output reg [1:0] selected = 2'd0,
    output reg [1:0] slide = 2'd0
);

reg button;
reg [31:0] menucount = 32'd0;
always @ (posedge CLK) begin
    button <= (btnL || btnC || btnR);
    menucount <= (menucount >= 32'd99999999) ? 32'd0 : menucount + 1;
    slide <= (menucount == 0) ? slide + 1 : slide;
end

always @ (posedge button) begin
    if (enable == 1'b1 && !sw10) begin
        if (btnL == 1'b1) begin
            if (cursor == 2'd0) begin
                cursor <= 2'd3;
            end
            else begin
                cursor <= cursor - 1'b1;
            end
        end
        else if (btnR == 1'b1) begin
            if (cursor == 2'd3) begin
                cursor <= 2'd0;
            end
            else begin
                cursor <= cursor + 1'b1;
            end
        end
        else if (btnC == 1'b1) begin
            selected <= cursor;
        end
    end
end

endmodule
