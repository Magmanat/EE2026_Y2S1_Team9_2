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
    input btnC, btnU, btnL, btnR, btnD,
    input JB2,   // Connect from this signal to Audio_Capture.v JB MIC PIN 3
    output JB0,   // Connect to this signal from Audio_Capture.v JB MIC PIN 1
    output JB3,   // Connect to this signal from Audio_Capture.v JB MIC PIN 4
    output [7:0] JC,
    output [15:0] led // mic_in
    );

    //button capturing
    wire debounced_btnU;
    switch_debouncer db1(CLK, btnU, debounced_btnU);
    wire debounced_btnC;
    switch_debouncer db2(CLK, btnC, debounced_btnC);
    wire debounced_btnL;
    switch_debouncer db3(CLK, btnL, debounced_btnL);
    wire debounced_btnR;
    switch_debouncer db4(CLK, btnR, debounced_btnR);
    wire debounced_btnD;
    switch_debouncer db5(CLK, btnD, debounced_btnD);

    //audio capturing
    wire clk20k;//, clk10;
    wire [11:0] mic_in;
    clock_divider twentykhz (CLK, 32'd2499, clk20k);
    Audio_Capture A(CLK, clk20k, JB2, JB0, JB3, mic_in);

    //declare all the variables for the OLED display
    wire clk6p25m, wire_frame_begin, wire_sending_pixels, wire_sample_pixel;
    wire [12:0] pixel_index;
    wire [15:0] oled_data;
    
    //First team task
    reg resetoled = 1'b0;
    clock_divider six25mhz (CLK, 32'd7, clk6p25m);
    Oled_Display B(.clk(clk6p25m), .reset(resetoled), .frame_begin(wire_frame_begin), .sending_pixels(wire_sending_pixels),
      .sample_pixel(wire_sample_pixel), .pixel_index(pixel_index), .pixel_data(oled_data),
       .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]),
      .pmoden(JC[7]), .teststate(0));

    //main menu selection screen for normal individual and normal task
    wire [1:0] cursor;
    wire [1:0] selected;
    main_menu mm(CLK,sw[2], debounced_btnL, debounced_btnC, debounced_btnR, cursor, selected);
//    assign led[13:12] = cursor;
//    assign led[11:10] = selected;  

    //OLED TASK A
    wire [2:0] bordercount;
    OTA oledtaskA(CLK,sw,selected,debounced_btnU,pixel_index,led[14],bordercount);
    
    //team volume indicator
    wire [2:0]volume0_5;
    volume_level vl(clk20k, mic_in, volume0_5, led[4:0]);

    //raw waveform
    wire [(95 * 6) - 1:0] waveform; 
    // wire [5:0] waveform_y;
    // wire [6:0] waveform_x;
    waveform wvfm(clk20k,selected,mic_in,waveform);
    
    //drawer module
    wire [15:0] my_oled_data;
    draw_module dm1(CLK, sw, pixel_index, bordercount, volume0_5, cursor, selected, waveform, my_oled_data);
    assign oled_data = my_oled_data; 

endmodule