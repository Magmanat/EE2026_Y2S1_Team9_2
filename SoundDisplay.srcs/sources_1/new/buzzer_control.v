`timescale 1ns / 1ps
module buzzer_control(
    input CLK,
    input metronome,
    input btnD,btnC,btnL,btnR,btnU,repeated_btnD,repeated_btnC,repeated_btnL,repeated_btnR,repeated_btnU,
    output reg [1:0] met_y,
    output reg [7:0] BPM,
    output reg [3:0] BeatsPerMeasure,
    output reg [1:0] NoteType,
    output reg [2:0] met_pos
);



endmodule