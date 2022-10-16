`timescale 1ns / 1ps
module buzzer_control(
    input CLK,
    input metronome,
    input btnD,btnC,btnL,btnR,btnU,repeated_btnL,repeated_btnR,
    output reg [1:0] met_y = 0,
    output reg [7:0] BPM = 60,
    output reg [3:0] BeatsPerMeasure = 4,
    output reg [1:0] NoteType = 0,
    output reg [2:0] met_pos = 0,
    output buzzerswitch
);

wire clk1Mhz;
clock_divider oneMhz(CLK, 32'd1000000, clk1Mhz);

reg [31:0] counter = 0;
wire [31:0] onebarcount;
assign onebarcount = ones * BeatsPerMeasure;
wire [31:0] ones;
reg [3:0] onescounter = 0;
assign ones = 60000000/BPM;

assign met_pos = (counter / (ones / 7)) % 7;
reg reversed = 0;

wire [31:0] twos;
assign twos = ones / 2;
wire [31:0] threes;
assign threes = ones / 3;
wire [31:0] fours;
assign fours = ones / 4;

reg start = 0;

reg buttonpressed = 0;

always @ (posedge CLK) begin
    if (metronome) begin
        if (btnD || btnC || btnL || btnR || btnU|| repeated_btnL || repeated_btnR) begin
            buttonpressed <= 1;
        end else begin
            buttonpressed <= 0;
        end
    end
end

wire playingnotenow;
reg [10:0] playhighnote;
reg [10:0] playmediumnote;
reg [10:0] playlownote;
assign playingnotenow = playhighnote || playmediumnote || playlownote;

wire clk1000hz;
clock_divider oneMhz(CLK, 32'd1000, clk1000hz);
wire clk500hz;
clock_divider oneMhz(CLK, 32'd500, clk500hz);
wire clk250hz;
clock_divider oneMhz(CLK, 32'd250, clk250hz);

assign buzzerswitch = playhighnote ? clk1000hz : (playmediumnote ? clk500hz : (playlownote ? clk250hz : 0));

always @ (posedge clk1Mhz) begin
    if (start && metronome) begin
        if (counter >= onebarcount) begin
            counter <= 0;
            onescounter <= 0;
        end else begin
            counter <= counter + 1;
        end
        if (NoteType == 0) begin
            if (counter % ones == 0) begin
                if (onescounter == 0) begin
                    playhighnote <= 1000;
                end else begin
                    playlownote <= 1000;
                end
                onescounter <= onescounter + 1;
                reversed <= ~reversed;
            end
        end else if (NoteType == 1) begin
            if (counter % ones == 0) begin
                if (onescounter == 0) begin
                    playhighnote <= 1000;
                end else begin
                    playmediumnote <= 1000;
                end
                onescounter <= onescounter + 1;
                reversed <= ~reversed;
            end else if (counter % twos == 0) begin
                playlownote <= 1000;
            end
        end else if (NoteType == 2) begin
            if (counter % ones == 0) begin
                if (onescounter == 0) begin
                    playhighnote <= 1000;
                end else begin
                    playmediumnote <= 1000;
                end
                onescounter <= onescounter + 1;
                reversed <= ~reversed;
            end else if (counter % threes == 0) begin
                playlownote <= 1000;
            end
        end else if (NoteType == 3) begin
            if (counter % ones == 0) begin
                if (onescounter == 0) begin
                    playhighnote <= 1000;
                end else begin
                    playmediumnote <= 1000;
                end
                onescounter <= onescounter + 1;
                reversed <= ~reversed;
            end else if (counter % fours == 0) begin
                playlownote <= 1000;
            end
        end
        playlownote <= playlownote > 0 ? playlownote - 1 : 0;
        playhighnote <= playhighnote > 0 ? playhighnote - 1 : 0;
        playmediumnote <= playmediumnote > 0 ? playmediumnote - 1 : 0;
    end else begin
        reversed <= 0;
        counter <= 0;
        onescounter <= 0;
    end
end

always @ (posedge buttonpressed) begin
    if (metronome) begin
        if (btnD) begin
            met_y <= met_y == 2 ? 0 : met_y + 1;
        end else if (btnU) begin
            met_y <= met_y == 0 ? 2 : met_y - 1;
        end else if (btnL || repeated_btnL) begin
            if (met_y == 0) begin
                BPM <= BPM == 30 ? 252 : BPM - 1;
            end else if (met_y == 1) begin
                BeatsPerMeasure <= BeatsPerMeasure == 1 ? 9 : BeatsPerMeasure - 1;
            end else if (met_y == 2) begin
                NoteType <= NoteType - 1;
            end
        end else if (btnR || repeated_btnR) begin
            if (met_y == 0) begin
                BPM <= BPM == 252 ? 30 : BPM + 1;
            end else if (met_y == 1) begin
                BeatsPerMeasure <= BeatsPerMeasure == 9 ? 1 : BeatsPerMeasure + 1;
            end else if (met_y == 2) begin
                NoteType <= NoteType + 1;
            end
        end else if (btnC) begin
            start <= ~start;
        end
    end
end

endmodule