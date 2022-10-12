`timescale 1ns / 1ps
module spectrumcontrol(
    input CLK,
    input [1:0] selected,
    input btnL,
    input btnR,
    input [15:0] sw,
    output reg [4:0] spectrobinsize = 25
);

reg [31:0] counter = 32'd0;
reg button;

always @ (posedge CLK) begin
    button <= btnL || btnR ? 1 : 0;
end


always @ (posedge button) begin
    if (selected == 2'd2 && !sw[2]) begin
        if (btnL == 1'b1) begin
            if (spectrobinsize == 5'd1) begin
                spectrobinsize <= 5'd25;
            end
            else begin
                spectrobinsize <= spectrobinsize - 5'd1;
            end
        end
        else if (btnR == 1'b1) begin
            if (spectrobinsize == 5'd25) begin
                spectrobinsize <= 5'd1;
            end
            else begin
                spectrobinsize <= spectrobinsize + 5'd1;
            end
        end
    end
end


endmodule