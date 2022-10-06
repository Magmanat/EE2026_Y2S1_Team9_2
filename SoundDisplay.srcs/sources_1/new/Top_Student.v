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
    input [15:0] sw,
    input btnC, btnU,
    input JB2,   // Connect from this signal to Audio_Capture.v JB MIC PIN 3
    output JB0,   // Connect to this signal from Audio_Capture.v JB MIC PIN 1
    output JB3,   // Connect to this signal from Audio_Capture.v JB MIC PIN 4
    output [7:0] JC,
    output [15:0] led // mic_in
    // Delete this comment and include other inputs and outputs here
    );

    // Delete this comment and write your codes and instantiations here
    wire clk20k;//, clk10;
    // reg myclk;
    wire [11:0] mic_in;
     clock_divider twentykhz (CLK, 32'd2499, clk20k);
    // clock_divider tenhz (CLK,  32'd4999999, clk10);
    Audio_Capture A(CLK, clk20k, JB2, JB0, JB3, mic_in);

    //choose myclock, not needed
    // always @ (posedge CLK) begin
    //     myclk <= (sw[0] == 1) ? clk10 : clk20k;
    // end
    //use myclock to update LEDs
    // always @ (posedge myclk) begin
    //     led <= mic_in;
    // end
    


    //declare all the variables for the OLED display
    wire clk6p25m, wire_frame_begin, wire_sending_pixels, wire_sample_pixel;
    wire [12:0] pixel_index;
    wire [15:0] oled_data;
    
    //drawer
    wire [15:0] my_oled_data;
    wire [2:0] bordercount;
    draw_module dm1(CLK, sw, pixel_index, bordercount, volume0_5, my_oled_data);
    assign oled_data = my_oled_data;    
    
    //First team task
    clock_divider six25mhz (CLK, 32'd7, clk6p25m);
    Oled_Display B(.clk(clk6p25m), .reset(btnC), .frame_begin(wire_frame_begin), .sending_pixels(wire_sending_pixels),
      .sample_pixel(wire_sample_pixel), .pixel_index(pixel_index), .pixel_data(oled_data),
       .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]),
      .pmoden(JC[7]), .teststate(0));

    //OLED TASK A
    OTA oledtaskA(CLK,sw[0],btnU,pixel_index,led[14],bordercount);
    
    //team volume indicator
    wire [2:0]volume0_5;
    volume_level vl(clk20k, mic_in, volume0_5, led[4:0]);

endmodule