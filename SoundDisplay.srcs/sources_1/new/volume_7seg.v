`timescale 1ns / 1ps

module volume_7seg(
    input CLK, 
    output reg [3:0] an, // anode signals of the 7-segment LED display
    output reg [6:0] seg,// cathode patterns of the 7-segment LED display
    input [15:0] volume_16, // counting number to be displayed
    input [4:0] waveform_sampling,
    input [4:0] spectrobinsize,
    input [1:0] selected
    );
    
    reg [3:0] LED_BCD;

    reg [19:0] refresh_counter; // 20-bit for creating 10.5ms refresh period or 380Hz refresh rate
             // the first 2 MSB bits for creating 4 LED-activating signals with 2.6ms digit period
    wire [1:0] LED_activating_counter; 
    reg [15:0] displayed_number;

    always @(posedge CLK)
    begin 
        refresh_counter <= refresh_counter + 1;
        if (selected == 2'd0) begin
            displayed_number <= waveform_sampling;
        end
        else if (selected == 2'd1) begin
            displayed_number <= volume_16;
        end
        else if (selected == 2'd2) begin
            displayed_number <= ((spectrobinsize * 1953) / 100) * 20;
        end
    end 
    assign LED_activating_counter = refresh_counter[19:18];
    // anode activating signals for 4 LEDs, digit period of 2.6ms
    // decoder to generate anode signals 
    always @(*)
    begin
        case(LED_activating_counter)
        2'b00: begin
            an = 4'b0111; 
            // activate LED1 and Deactivate LED2, LED3, LED4
            LED_BCD = displayed_number/1000;
            // the first digit of the 16-bit number
              end
        2'b01: begin
            an = 4'b1011; 
            // activate LED2 and Deactivate LED1, LED3, LED4
            LED_BCD = (displayed_number % 1000)/100;
            // the second digit of the 16-bit number
              end
        2'b10: begin
            an = 4'b1101; 
            // activate LED3 and Deactivate LED2, LED1, LED4
            LED_BCD = ((displayed_number % 1000)%100)/10;
            // the third digit of the 16-bit number
                end
        2'b11: begin
            an = 4'b1110; 
            // activate LED4 and Deactivate LED2, LED3, LED1
            LED_BCD = ((displayed_number % 1000)%100)%10;
            // the fourth digit of the 16-bit number    
               end
        endcase
    end
    // Cathode patterns of the 7-segment LED display 
    always @(*)
    begin
        case(LED_BCD)
        4'b0000: seg = 7'b1000000; // "0"     
        4'b0001: seg = 7'b1111001; // "1" 
        4'b0010: seg = 7'b0100100; // "2" 
        4'b0011: seg = 7'b0110000; // "3" 
        4'b0100: seg = 7'b0011001; // "4" 
        4'b0101: seg = 7'b0010010; // "5"
        4'b0110: seg = 7'b0000010; // "6" 
        4'b0111: seg = 7'b1111000; // "7" 
        4'b1000: seg = 7'b0000000; // "8"     
        4'b1001: seg = 7'b0010000; // "9" 
        default: seg = 7'b1000000; // "0"
        endcase
    end
 endmodule