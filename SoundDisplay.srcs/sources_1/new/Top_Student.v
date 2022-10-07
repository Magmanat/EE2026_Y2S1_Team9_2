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
    input [0:0] sw,
    input btnC,
    input JB2,   // Connect from this signal to Audio_Capture.v JB MIC PIN 3
    output JB0,   // Connect to this signal from Audio_Capture.v JB MIC PIN 1
    output JB3,   // Connect to this signal from Audio_Capture.v JB MIC PIN 4
    output [7:0] JC,
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
   
    wire clk6p25m, wire_frame_begin, wire_sending_pixels, wire_sample_pixel;
    wire [12:0] pixel_index;
    //16 bit = 5b red, 6b green, 5b blue
    //[11:6] mic_in for green and [11:7] mic_in for blue
    wire [5:0] g;
    assign g = mic_in [11:6];
    wire [4:0] b;
    assign b = mic_in [11:7];
    reg [15:0] oled_data;
    always @ (posedge CLK) begin
//        oled_data = b | (g << 5);
        oled_data = {{g},{b}};
    end
    clock_divider six25mhz (CLK, 32'd7, clk6p25m);
    Oled_Display B(.clk(clk6p25m), .reset(btnC), .frame_begin(wire_frame_begin), .sending_pixels(wire_sending_pixels),
      .sample_pixel(wire_sample_pixel), .pixel_index(pixel_index), .pixel_data(oled_data),
       .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]),
      .pmoden(JC[7]), .teststate(0));
endmodule