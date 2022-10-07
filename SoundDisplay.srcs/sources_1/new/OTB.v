`timescale 1ns / 1ps
module OTB(
    input CLK,
    input [15:0] sw,
    input [1:0] selected,
    input btnD,
    input [12:0] pixel_index,
    output reg led,
    output reg[2:0] boxcount = 0
);

reg [31:0] counter = 32'd0;

always @ (posedge CLK, posedge btnD) begin
    // check if button pressed (its a pulse even if held because of debounce)
    if (btnD == 1'b1 && sw == 16'b10 && selected == 1 && led == 0) begin
        counter <= 32'd500000000;
    end

    else begin
    // set led and minus counter
        led <= 0;
        if (counter > 32'd0 && sw == 16'b10 && selected == 1) begin
            counter <= counter - 1'b1;
            led <= 1;
        end
    end
end


always @ (posedge btnD) begin
    if (selected == 1 && sw == 16'b10 && led == 0) begin
        if (boxcount == 3'd3) begin
            boxcount <= 3'd0;
        end
        else begin
            boxcount <= boxcount + 1'd1;
        end
    end
end


endmodule