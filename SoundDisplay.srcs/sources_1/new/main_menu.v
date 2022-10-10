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
    input btnL,
    input btnC,
    input btnR,
    output reg [1:0] cursor = 2'd1,
    output reg [1:0] selected = 2'd1
);

reg button;

always @ (posedge CLK) begin
    button <= btnL || btnC || btnR ? 1 : 0;
end

always @ (posedge button) begin
    if (enable == 1'b1) begin
        if (btnL == 1'b1) begin
            if (cursor == 2'd0) begin
                cursor <= 2'd2;
            end
            else begin
                cursor <= cursor - 1'b1;
            end
        end
        else if (btnR == 1'b1) begin
            if (cursor == 2'd2) begin
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
