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


module password(
    input CLK,
    input menusw,
    input resetsw,
    input lock,
    input btnL,
    input btnC,
    input btnR,
    output [9:5] led,
    output reg resetpw = 1'b0,
    output reg [3:0] cursor = 4'd0,
    output reg [3:0] counter = 4'd0,
    //default
    output reg[7:0] pw1 = 8'd107, //c5
    output reg[7:0] pw2 = 8'd120, //d5
    output reg[7:0] pw3 = 8'd135, //e5
    output reg[7:0] pw4 = 8'd143, //f5
    output reg[7:0] pw5 = 8'd180  //a5
    );

    //base notes
    reg[7:0] C = 8'd107; 
    reg[7:0] D = 8'd120;
    reg[7:0] E = 8'd135;
    reg[7:0] F = 8'd143;
    reg[7:0] A = 8'd180;

    //options 0 to 4
    reg[7:0] temp1 = 8'd0;
    reg[7:0] temp2 = 8'd0;
    reg[7:0] temp3 = 8'd0;
    reg[7:0] temp4 = 8'd0;
    reg[7:0] temp5 = 8'd0;

    reg button;
    reg[4:0] myled = 5'b00000;
    assign led [9:5] = myled [4:0];

    always @ (posedge CLK) begin
        button <= (btnL || btnC || btnR || !resetsw) ? 1 : 0;
        // if(resetpw) begin
        //     resetpw <= 0;
        // end
    end
    always @ (posedge button) begin
        if (!lock) begin
            if (menusw) begin
                if(resetsw) begin
                    if (btnL == 1'b1) begin
                        if (cursor == 4'd0) begin
                            cursor <= 4'd4;
                        end
                        else begin
                            cursor <= cursor - 1'b1;
                        end
                    end
                    else if (btnR == 1'b1) begin
                        if (cursor == 4'd4) begin
                            cursor <= 4'd0;
                        end
                        else begin
                            cursor <= cursor + 1'b1;
                        end
                    end
                    else if(btnC == 1'b1) begin
                        if(counter == 4'd0) begin
                            temp1 <= (cursor == 0) ? C : ((cursor == 1) ? D : ((cursor == 2) ? E : ((cursor == 3) ? F : A)));
                            counter <= counter + 4'd1;
                            myled <= 5'b00001;
                            resetpw <= 0;
                        end
                        else if(counter == 4'd1) begin
                            temp2 <= (cursor == 0) ? C : ((cursor == 1) ? D : ((cursor == 2) ? E : ((cursor == 3) ? F : A)));
                            counter <= counter + 4'd1;
                            myled <= 5'b00011;
                        end
                        else if(counter == 4'd2) begin
                            temp3 <= (cursor == 0) ? C : ((cursor == 1) ? D : ((cursor == 2) ? E : ((cursor == 3) ? F : A)));
                            counter <= counter + 4'd1;
                            myled <= 5'b00111;
                        end
                        else if(counter == 4'd3) begin
                            temp4 <= (cursor == 0) ? C : ((cursor == 1) ? D : ((cursor == 2) ? E : ((cursor == 3) ? F : A)));
                            counter <= counter + 4'd1;
                            myled <= 5'b01111;
                        end
                        else if(counter == 4'd4) begin
                            temp5 <= (cursor == 0) ? C : ((cursor == 1) ? D : ((cursor == 2) ? E : ((cursor == 3) ? F : A)));
                            counter <= counter + 4'd1;
                            myled <= 5'b11111;
                        end
                        else if(counter == 4'd5) begin
                            pw1 <= temp1;
                            pw2 <= temp2;
                            pw3 <= temp3;
                            pw4 <= temp4;
                            pw5 <= temp5;
                            myled <= 5'b00000;
                            counter <= 4'd0;
                            resetpw <= 1;
                        end
                        // else if(counter == 4'd6) begin
                        //     counter <= 4'd0;
                        //     myled <= 5'b00000;
                        //     resetpw <= 1;
                        // end
                    end
                end
                else if(!resetsw) begin
                    resetpw <= 0;
                    counter <= 4'd0;
                    myled <= 5'b00000;
                end
            end if (!resetsw) begin
                resetpw <= 0;
                counter <= 0;
                myled <= 5'b00000;
            end
        end 
        if (resetpw) begin
            resetpw <= 0;
        end
        
    end
endmodule