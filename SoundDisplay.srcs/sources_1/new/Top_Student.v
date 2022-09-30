`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//
//  LAB SESSION DAY (Delete where applicable): MONDAY P.M, TUESDAY P.M, WEDNESDAY P.M, THURSDAY A.M., THURSDAY P.M
//
//  STUDENT A NAME: 
//  STUDENT A MATRICULATION NUMBER: 
//
//  STUDENT B NAME: 
//  STUDENT B MATRICULATION NUMBER: 
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input CLK,
    input JB2,   // Connect from this signal to Audio_Capture.v JB MIC PIN 3
    output JB0,   // Connect to this signal from Audio_Capture.v JB MIC PIN 1
    output JB3,   // Connect to this signal from Audio_Capture.v JB MIC PIN 4
    input [0:0] sw,
    output reg [11:0] led // mic_in
    // Delete this comment and include other inputs and outputs here
    );

    // Delete this comment and write your codes and instantiations here
    wire clk20k, clk10;
    reg myclk;
    wire [11:0] mic_in;
    clock_divider twentykhz (CLK, 32'd2499, clk20k);
    clock_divider tenhz (CLK,  32'd4999999, clk10);
    Audio_Capture A(CLK, clk20k, JB2, JB0, JB3, mic_in);
    always @ (posedge CLK) begin
        myclk <= (sw[0] == 1) ? clk10 : clk20k;
    end
    always @ (posedge myclk) begin
        led <= mic_in;
    end
    
endmodule