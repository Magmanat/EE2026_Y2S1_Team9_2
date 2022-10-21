`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2022 14:47:52
// Design Name: 
// Module Name: lock_screen
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


module lock_screen(
    input CLK,
    input btnC,
    input [9:0] note,
    input stable_note_held,
    output reg lock = 1'b1,
    output reg [2:0] seq = 3'd0
    );
    reg [31:0] restart = 32'b0;
    reg [4:0] count = 5'd0;
    always @ (posedge CLK) begin
        //wrong/timeout restart
        restart <= (restart >= 32'd100000000) ? 32'd0 : restart + 1;
        if(restart == 0) begin
            count = count + 1;
        end
        if(count == 5'd60) begin
            seq <= 0;
            count <= 0;
        end
        //c,d,e,f,g
        //13,15,17,18,20
        case(seq)
        3'd0: if((note == 10'd53 || note == 10'd54) && stable_note_held) begin
            seq <= seq + 1;
            count <= 0;
        end
        3'd1: if(note == 10'd60 && stable_note_held) begin
            seq <= seq + 1;
            count <= 0;
        end
        3'd2: if((note == 10'd67 || note == 10'd68) && stable_note_held) begin
            seq <= seq + 1;
            count <= 0;
        end
        3'd3: if((note == 10'd71 || note == 10'd72) && stable_note_held) begin
            seq <= seq + 1;
            count <= 0;
        end
        3'd4: if(note == 10'd80 && stable_note_held) begin
            seq <= seq + 1;
            count <= 0;
        end
        3'd5: if(btnC == 1) begin
            lock <= 0;
        end
        endcase
    end
endmodule
