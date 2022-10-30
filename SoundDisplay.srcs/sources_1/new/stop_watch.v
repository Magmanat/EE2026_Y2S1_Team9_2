`timescale 1ns / 1ps

module stop_watch(
    input CLK,
    input [1:0] selected,
    input sw2,
    input btnC,
    input btnL,
    input btnR,
    input [2:0] volume0_5,
    output reg [3:0] a = 4'd0,
    output reg [3:0] b = 4'd0,
    output reg [3:0] c = 4'd0,
    output reg [3:0] d = 4'd0, 
    output reg [3:0] e = 4'd0,
    output reg [3:0] f = 4'd0,
    output reg cursor = 1'd0,
    output reg start = 1'd0,
    output reg reset = 1'd0
);
    reg button;
    reg stopafteroverflow = 0;
    reg [2:0] volume;
    always @( posedge button) begin
        if(sw2 == 0) begin
            if (stopafteroverflow) begin
                start <= 0;
            end
            if(btnL == 1 && cursor == 1) begin //hover left
                cursor <= 0;
            end
            if(btnR == 1 && cursor == 0) begin //hover right
                cursor <= 1;
            end
            if(volume >= 3'd5 || (btnC == 1 && cursor == 0)) begin //start / stop
                start <= ~start;
                reset <= 0;
                cursor <= 0;
            end
            if(btnC == 1 && cursor == 1) begin //reset
                reset <= 1;
                start <= 0;
            end
        end
    end
    wire clock100;
    clock_divider slowclk(CLK, 100, clock100);
    always @ (posedge CLK) begin
        volume <= volume0_5;
        button <= (btnC || (volume >= 3'd5) || btnL || btnR || stopafteroverflow);
        if(selected == 3 && sw2 == 0) begin
            if(start == 1) begin
                if(clock100) begin
                    if(a == 9) begin
                        a <= 0;
                        if(b == 9) begin
                            b <= 0;
                            if(c == 9) begin
                                c <= 0;
                                if(d == 5) begin
                                    d <= 0;
                                    if(e == 9) begin
                                        e <= 0;
                                        f <= f + 1;
                                    end
                                    else begin
                                        e <= e + 1;
                                    end
                                end
                                else begin
                                    d <= d + 1;
                                end
                            end
                            else begin
                                c <= c + 1;
                            end
                        end
                        else begin
                            b <= b + 1;
                        end
                    end
                    else begin
                        a <= a + 1;
                    end
                end
                if(f == 5 && e == 9 && d == 5 && c == 9 && b == 9 && a == 9) begin
                    stopafteroverflow <= 1;
                end
            end
            if (stopafteroverflow == 1) begin
                stopafteroverflow <= 0;
            end
            if(reset) begin
                a <= 0;
                b <= 0;
                c <= 0;
                d <= 0;
                e <= 0;
                f <= 0;   
            end
        end
    end
endmodule