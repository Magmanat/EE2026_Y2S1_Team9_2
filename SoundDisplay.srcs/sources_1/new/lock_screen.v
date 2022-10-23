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
    input [7:0] pw1,
    input [7:0] pw2,
    input [7:0] pw3,
    input [7:0] pw4,
    input [7:0] pw5,
    input resetpw,
    output reg lock = 1'b1,
    output reg [2:0] seq = 3'd0
    );
    reg [31:0] restart = 32'b0;
    reg [4:0] count = 5'd0;
    always @ (posedge CLK) begin
        //after resetpw, lock and reset seq
        if(resetpw) begin
            lock <= 1;
        end
        if(lock == 1) begin
            if (seq >= 1) begin
                restart <= (restart >= 32'd100000000) ? 32'd0 : restart + 1;
                count <= (restart == 0) ? count + 1 : count;
                //wrong/timeout restart
                if(count == 5'd20) begin
                    seq <= 6;
                    count <= 0;
                end
            end
            //default c5,d5,e5,f5,a5
            case(seq)
            3'd0: if(note == pw1 && stable_note_held) begin
                seq <= seq + 1;
                count <= 0;
            end
            3'd1: if(note == pw2 && stable_note_held) begin
                seq <= seq + 1;
                count <= 0;
            end
            3'd2: if(note == pw3 && stable_note_held) begin
                seq <= seq + 1;
                count <= 0;
            end
            3'd3: if(note == pw4 && stable_note_held) begin
                seq <= seq + 1;
                count <= 0;
            end
            3'd4: if(note == pw5 && stable_note_held) begin
                seq <= seq + 1;
                count <= 0;
            end
            3'd5: if(btnC == 1) begin
                lock <= 0;
                seq <= 0;
                count <= 0;
            end
            3'd6:if(count >= 5'd5) begin
                seq <= 0;
                count <= 0;
            end
            endcase
        end
    end
endmodule
