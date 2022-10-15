`timescale 1ns / 1ps
module buzzer_control(
    input CLK,
    input metronome,
    input btnD,btnC,btnL,btnR,btnU,
    output reg [2:0] met_y,
    output reg [1:0] met_x,
    output reg met_engaged,
    output reg [7:0] BPM,
    output reg [3:0] BeatsPerMeasure,
    output reg [2:0] NoteValue,
    output reg [1:0] note type,
);



endmodule