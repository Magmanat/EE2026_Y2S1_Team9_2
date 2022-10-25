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
    output [15:0] led, // mic_in
    output [3:0] an,
    output [6:0] seg,
    output JA0
    );

    //button capturing
    wire debounced_btnU;
    wire repeated_btnU;
    switch_debouncer db1(CLK, btnU, debounced_btnU, repeated_btnU);
    wire debounced_btnC;
    wire repeated_btnC;
    switch_debouncer db2(CLK, btnC, debounced_btnC, repeated_btnC);
    wire debounced_btnL;
    wire repeated_btnL;
    switch_debouncer db3(CLK, btnL, debounced_btnL, repeated_btnL);
    wire debounced_btnR;
    wire repeated_btnR;
    switch_debouncer db4(CLK, btnR, debounced_btnR, repeated_btnR);
    wire debounced_btnD;
    wire repeated_btnD;
    switch_debouncer db5(CLK, btnD, debounced_btnD, repeated_btnD);

    //audio capturing
    wire clk20k;//, clk10;
    wire [11:0] mic_in;
    clock_divider twentykhz (CLK, 32'd20000, clk20k);
    wire clk40k;
    clock_divider fourtykhz (CLK, 32'd40000, clk40k);
    reg clk20kFORAUDIO = 0;
    always @ (posedge clk40k) begin
        clk20kFORAUDIO <= ~clk20kFORAUDIO;
    end
    Audio_Capture A(CLK, clk20kFORAUDIO, JB2, JB0, JB3, mic_in);

    //declare all the variables for the OLED display
    wire clk6p25m, wire_frame_begin, wire_sending_pixels, wire_sample_pixel;
    wire [12:0] pixel_index;
    wire [15:0] oled_data;
    
    //First team task
    reg reset = 1'b0;
    clock_divider six25mhz (CLK, 32'd6250000, clk6p25m);
    Oled_Display B(.clk(clk6p25m), .reset(reset), .frame_begin(wire_frame_begin), .sending_pixels(wire_sending_pixels),
      .sample_pixel(wire_sample_pixel), .pixel_index(pixel_index), .pixel_data(oled_data),
       .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]),
      .pmoden(JC[7]), .teststate(0));

    //main menu selection screen for normal individual and normal task
    wire [1:0] cursor;
    wire [1:0] selected;
    wire [1:0] slide;
    wire mainmenuon;
    assign mainmenuon = sw[2] && !sw[15] && !sw[14] && !lock;
    main_menu mm(CLK, mainmenuon, sw[10], debounced_btnL, debounced_btnC, debounced_btnR, cursor, selected, slide);
//    assign led[13:12] = cursor;
//    assign led[11:10] = selected;  

    //OLED TASK A
    wire [2:0] bordercount;
    OTA oledtaskA(CLK,sw,selected,debounced_btnU,pixel_index,led[14],bordercount);

    //OLED TASK B
    wire [2:0] boxcount;
    OTB oledtaskB(CLK, sw, selected, debounced_btnD, pixel_index, led[12], boxcount);
    
    //team volume indicator
    wire [2:0]volume0_5;
    wire [3:0]volume16;
    volume_level vl(clk20k, mic_in, volume0_5, volume16, led[4:0], selected);
    //7seg volume indicator
    volume_7seg vl7seg(CLK, an, seg, volume0_5, BPM, waveform_sampling, spectrobinsize, selected, metronome);
    
    // volume_7seg vl7seg(CLK, an, seg, volume0_5, playhighnote, waveform_sampling, spectrobinsize, selected, metronome);
    //raw waveform
    wire [4:0] waveform_sampling;
    wire [(96 * 6) - 1:0] waveform; 
    waveform wvfm(CLK,selected,sw,mic_in,debounced_btnC,debounced_btnL,debounced_btnR,repeated_btnL,repeated_btnR,waveform,waveform_sampling);

    //lock_screen and password reset
    wire lock;
    wire resetpw;
    wire [2:0] sequence;
    wire [7:0] pw1;
    wire [7:0] pw2;
    wire [7:0] pw3;
    wire [7:0] pw4;
    wire [7:0] pw5;
    wire [3:0] pwcursor;
    wire [3:0] pwcounter;
    wire reset_stablenoteheld;
    lock_screen ls(CLK, debounced_btnC, previous_highest_note_index, stable_note_held, pw1, pw2, pw3, pw4, pw5, resetpw, lock, sequence, reset_stablenoteheld);
    password pw(CLK, sw[2], sw[10], lock, debounced_btnL, debounced_btnC, debounced_btnR, led[9:5], resetpw, pwcursor, pwcounter, pw1, pw2, pw3, pw4, pw5);
    /*
    ******************************************************************************************************************************************************************
    ******************************************************************************************************************************************************************
    ******************************************************************************************************************************************************************
    */

    //fft stuff
    wire signed [11:0] sample_imag = 12'b0; //imaginary part is 0
    wire signed [5:0] output_real, output_imag; //bits for output real and imaginary
    reg [13:0] abs; //to calculate the absolute magnitude of output real and imaginary
    // reg [(512 * 6) - 1:0] bins; //vector for all the 1024 bins(not necessary)
    reg [9:0] maxbins = 512;
    wire sync; //high when fft is ready
    reg [9:0] bin = 0; //current bin editting
    wire fft_ce; 
    assign fft_ce = 1; //always high when fft is transforming

    //spectrogram stuff after fft
    reg [(6 * 20) - 1:0] spectrogram = 0;
    reg [5:0] current_highest_spectrogram = 0;
    wire [4:0] spectrobinsize;
    integer j;

    //tuner stuff after fft
    reg [5:0] current_highest_note = 0;
    reg [9:0] previous_highest_note_index = 0;
    reg [9:0] current_highest_note_index = 0;
    reg [15:0] stable_note_count = 0;
    wire stable_note_held;
    wire [5:0] holdcount = (sw[15] || lock) ? (5000/1024 * 2) : (20000/1024 * 2);
    assign stable_note_held = stable_note_count >= holdcount;

    wire clk5k;
    reg custom_fft_clk;
    clock_divider fivekhz (CLK, 32'd5000, clk5k);
    always @ (posedge CLK) begin
        custom_fft_clk <= (sw[15] || lock) ? clk5k : clk20k;
    end

    always @(posedge CLK) begin
        if (reset_stablenoteheld) begin
            stable_note_count = 0;
        end
        if (custom_fft_clk) begin
            if(fft_ce) begin
                abs <= (output_real * output_real) + (output_imag * output_imag);
                if(sync) begin
                    bin <= 0;
                    j <= 0;
                    current_highest_spectrogram <= 0;

                    if (current_highest_note_index == previous_highest_note_index) begin
                        stable_note_count <= stable_note_count <= holdcount ? stable_note_count + 1 : stable_note_count;
                    end else begin
                        stable_note_count <= 0;
                        previous_highest_note_index <= current_highest_note_index;
                    end
                    current_highest_note_index <= 0;
                    current_highest_note <= 0;
                end else begin
                    bin <= bin + 1;
                end   
                if (bin < maxbins) begin
                    // This is for finding highest of each bin of spectrogram, 0Hz is not included as it always skews results
                    if (!sw[15] && !lock && !spectropause) begin
                        if (bin != 0) begin
                            if (bin % spectrobinsize == 0) begin
                                if (j < 20) begin
                                    spectrogram[j*6 +: 6] <= 63 - current_highest_spectrogram;
                                    current_highest_spectrogram = 0;
                                    j <= j + 1;
                                end
                            end     
                            if (current_highest_spectrogram < ((abs >> 4) < 63 ? (abs >> 4) : 63)) begin
                                current_highest_spectrogram <= ((abs >> 4) < 63 ? (abs >> 4) : 63);
                            end   
                        end
                    end
                    else begin
                        if (bin != 0) begin
                            // bins[bin * 6+: 6] <= (abs >> 4) < 63 ? (abs >> 4): 63; // scale & limit to 63 (not necessary to store whole thing)
                            // This is for finding current note being played and how to reset it
                            if (current_highest_note < ((abs >> 4) < 63 ? (abs >> 4) : 63) && ((abs >> 4) < 63 ? (abs >> 4) : 63) > 15) begin
                                current_highest_note_index <= bin;
                                current_highest_note <= ((abs >> 4) < 63 ? (abs >> 4) : 63);
                            end
                        end
                    end
                end
            end
        end
    end
    wire spectropause;

    fftmain fft_0(.i_clk(custom_fft_clk), .i_reset(reset), .i_ce(fft_ce), .i_sample({mic_in, sample_imag}), .o_result({output_real, output_imag}), .o_sync(sync));
    spectrumcontrol spc_1(CLK, selected, debounced_btnC, debounced_btnL, debounced_btnR, repeated_btnL, repeated_btnR, sw, spectropause, spectrobinsize);

    /*
    ******************************************************************************************************************************************************************
    ******************************************************************************************************************************************************************
    ******************************************************************************************************************************************************************
    */

    //Buzzer control module
    wire [1:0] met_y;
    wire [7:0] BPM;
    wire [3:0] BeatsPerMeasure;
    wire [1:0] NoteType;
    wire [2:0] met_pos;
    wire reversed;
    wire buzzerswitch;
    wire metronome;
    assign metronome = sw[14] && !sw[15] && !lock;

    assign JA0 = buzzerswitch;
    buzzer_control buzz01(CLK, metronome, debounced_btnD, debounced_btnC, debounced_btnL
    , debounced_btnR, debounced_btnU, repeated_btnL, repeated_btnR, met_y, BPM, BeatsPerMeasure, NoteType
    , met_pos, reversed, buzzerswitch);


    //drawer module
    wire [15:0] my_oled_data;
    draw_module dm1(CLK, sw, pixel_index, bordercount, boxcount, volume0_5, cursor, pwcursor, selected
    , metronome, slide, waveform, spectrogram, previous_highest_note_index, 
    met_y, BeatsPerMeasure, NoteType, met_pos, reversed, lock, sequence, my_oled_data);
    assign oled_data = my_oled_data; 

endmodule