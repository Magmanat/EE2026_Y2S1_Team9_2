`timescale 1ns / 1ps
module spectrumcontrol(
    input CLK,
    input [1:0] selected,
    input btnC,
    input btnL,
    input btnR,
    input repeated_btnL,
    input repeated_btnR,
    input [15:0] sw,
    output reg spectropause = 0,
    output reg [4:0] spectrobinsize = 25
);

reg [31:0] counter = 32'd0;
reg button = 0;

always @ (posedge CLK) begin
    if (selected == 2'd2 && !sw[2]) begin
        button <= btnL || btnR || repeated_btnL || repeated_btnR || btnC;
    end
end

always @ (posedge button) begin
    if (btnL || repeated_btnL) begin
        spectrobinsize <= spectrobinsize == 1 ? 25 : spectrobinsize - 1;
    end
    else if (btnR || repeated_btnR) begin
        spectrobinsize <= spectrobinsize == 25 ? 1 : spectrobinsize + 1;
    end else if (btnC) begin
        spectropause <= ~spectropause;
    end  
end


endmodule