`timescale 1ns / 1ps

module volume_7seg(
    input clk20k,
    input [2:0] volume0_5,
    output [3:0] an,
    output [6:0] seg
    );
    assign an = 4'b1110;
    reg [6:0] seg7;
    assign seg = seg7;
    always @ (posedge clk20k) begin
        case(volume0_5)
        3'd0: seg7 = 7'b1000000;
        3'd1: seg7 = 7'b1111001;
        3'd2: seg7 = 7'b0100100;
        3'd3: seg7 = 7'b0110000;
        3'd4: seg7 = 7'b0011001;
        3'd5: seg7 = 7'b0010010;
        endcase
    end
endmodule