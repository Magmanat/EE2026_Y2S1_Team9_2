`timescale 1ns / 1ps
module buzzer_control(
    input CLK,
    input metronome,
    input startsw, //addition sw13
    input btnD,btnC,btnL,btnR,btnU,repeated_btnL,repeated_btnR,
    output reg [1:0] met_y = 0,
    output reg [7:0] BPM = 60,
    output reg [3:0] BeatsPerMeasure = 4,
    output reg [1:0] NoteType = 0,
    output [2:0] met_pos,
    output reg reversed = 0,
    output reg buzzerswitch = 0
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

wire [31:0] twos;
assign twos = ones / 2;
wire [31:0] threes;
assign threes = ones / 3;
wire [31:0] fours;
assign fours = ones / 4;

reg buttonpressed = 0;

reg [31:0] playhighnote = 0;
reg [31:0] playmediumnote = 0;
reg [31:0] playlownote = 0;

reg highnote = 0;
reg mednote = 0;
reg lownote = 0;


always @ (posedge CLK) begin
    if (clkHIGHhz) begin
        highnote <= ~highnote;
    end 
    if (clkMEDhz) begin
        mednote <= ~mednote;
    end
    if (clkLOWhz) begin
        lownote <= ~lownote;
    end
end


always @ (posedge CLK) begin
    buttonpressed <= btnD || btnC || btnL || btnR || btnU|| repeated_btnL || repeated_btnR || !metronome;
    BPM <= BPM7seg;
    if (playhighnote > 0) begin
            buzzerswitch <= highnote;
        end else if (playmediumnote > 0) begin
            buzzerswitch <= mednote;
        end else if (playlownote > 0) begin
            buzzerswitch <= lownote;
        end else begin
            buzzerswitch <= 0;
        end
end

wire clkHIGHhz;
clock_divider highHZ(CLK, 32'd8000, clkHIGHhz);
wire clkMEDhz;
clock_divider medHZ(CLK, 32'd6000, clkMEDhz);
wire clkLOWhz;
clock_divider lowHZ(CLK, 32'd4000, clkLOWhz);

wire [31:0] buzztime = 30000;
reg firstbeat = 1;

//tapping clock
reg [31:0] tapcounter = 0;
wire clk10000hz;
clock_divider tenthousandhz(CLK, 32'd10000, clk10000hz);
always @ (posedge clk10000hz) begin
    tapcounter <= (tapcounter >= 20000) ? 0 : tapcounter + 1; //20000 counts of 10000hz is 2s approx 30 bpm
end

always @ (posedge clk1Mhz) begin
    if (start && metronome) begin
        playlownote <= playlownote > 0 ? playlownote - 1 : playlownote;
        playhighnote <= playhighnote > 0 ? playhighnote - 1 : playhighnote;
        playmediumnote <= playmediumnote > 0 ? playmediumnote - 1 : playmediumnote;
        if (NoteType == 0) begin
            if (counter % ones == 0) begin
                if (onescounter == 0) begin
                    playhighnote <= buzztime;
                end else begin
                    playlownote <= buzztime;
                end
                onescounter <= onescounter + 1;
                if (!firstbeat) begin
                    reversed <= ~reversed;
                end      
            end
        end else if (NoteType == 1) begin
            if (counter % ones == 0) begin
                if (onescounter == 0) begin
                    playhighnote <= buzztime;
                end else begin
                    playmediumnote <= buzztime;
                end
                onescounter <= onescounter + 1;
                if (!firstbeat) begin
                    reversed <= ~reversed;
                end 
            end else if (counter % twos == 0) begin
                playlownote <= buzztime;
            end
        end else if (NoteType == 2) begin
            if (counter % ones == 0) begin
                if (onescounter == 0) begin
                    playhighnote <= buzztime;
                end else begin
                    playmediumnote <= buzztime;
                end
                onescounter <= onescounter + 1;
                if (!firstbeat) begin
                    reversed <= ~reversed;
                end 
            end else if (counter % threes == 0) begin
                playlownote <= buzztime;
            end
        end else if (NoteType == 3) begin
            if (counter % ones == 0) begin
                if (onescounter == 0) begin
                    playhighnote <= buzztime;
                end else begin
                    playmediumnote <= buzztime;
                end
                onescounter <= onescounter + 1;
                if (!firstbeat) begin
                    reversed <= ~reversed;
                end 
            end else if (counter % fours == 0) begin
                playlownote <= buzztime;
            end
        end
        if (counter >= onebarcount) begin
            counter <= 0;
            onescounter <= 0;
            firstbeat <= 1;
        end else begin
            counter <= counter + 1;
            firstbeat <= 0;
        end

    end else begin
        reversed <= 0;
        counter <= 0;
        onescounter <= 0;
        firstbeat <= 1;
        playhighnote <= 0;
        playmediumnote <= 0;
        playlownote <= 0;
    end
end

wire start;
assign start = startsw;
reg [7:0] BPM7seg = 60;
reg [31:0] firsttap;
reg [31:0] secondtap;
reg [31:0] differ;
reg [31:0] differ1;
reg [31:0] differ2;
reg [31:0] differ3;
reg [31:0] differ4;
reg [31:0] differavg;
always @ (posedge buttonpressed) begin
        if (metronome) begin
            if (btnD) begin
                met_y <= met_y == 3 ? 0 : met_y + 1;
            end 
            else if (btnU) begin
                met_y <= met_y == 0 ? 3 : met_y - 1;
            end
            if(met_y == 0) begin
                if (btnL || repeated_btnL) begin
                    BPM7seg <= BPM7seg == 30 ? 252 : BPM7seg - 1;
                end
                else if (btnR || repeated_btnR) begin
                    BPM7seg <= BPM7seg == 252 ? 30 : BPM7seg + 1;
                end
            end
            if(met_y == 1) begin
                if(btnC) begin
                    firsttap <= secondtap;
                    secondtap <= tapcounter;
                    if(secondtap > firsttap) begin
                        differ <= (60 * 10000) / (secondtap - firsttap);
                    end
                    else if(secondtap <= firsttap) begin     
                        differ <= (60 * 10000 / ((20000 - firsttap) + secondtap));                
                    end
                    differ4 <= differ3;
                    differ3 <= differ2;
                    differ2 <= differ1;
                    differ1 <= differ;
                    differavg <= (differ1 + differ2 + differ3 + differ4) / 4;
                    BPM7seg <= (differavg < 30) ? 30 : ((differavg > 252) ? 252 : differavg);
                end
            end
            if(met_y == 2) begin
                if (btnL || repeated_btnL) begin
                    BeatsPerMeasure <= BeatsPerMeasure == 1 ? 9 : BeatsPerMeasure - 1;
                end
                else if (btnR || repeated_btnR) begin
                    BeatsPerMeasure <= BeatsPerMeasure == 9 ? 1 : BeatsPerMeasure + 1;
                end
            end
            if(met_y == 3) begin
                if (btnL || repeated_btnL) begin
                    NoteType <= NoteType - 1;
                end
                else if (btnR || repeated_btnR) begin
                    NoteType <= NoteType + 1;
                end
            end
        end
    end
endmodule