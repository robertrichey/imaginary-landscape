setRecordStrings() @=> string recordings[];
0 => int recordingIndex;


main();


// create piece
fun void main() {
    // track arrays are arranged in the form of ["dynamic", "duration", "dynamic", "duration", ...]
    // "s" indicates a segment of silence for the indicated duration
    // "x" indicates a change in recording before playing that segment
    [["6","23"], ["s13"], ["6","14"], ["s7.5"], ["6","2.5"], ["s2.5"], ["x6","23.5"], ["s11"], ["6","7.5"], ["s13.5"], ["7","28","4"], ["x7","28","4"], ["s22"], ["3","8","8","15","5"], ["s10"], ["3","7","8","8","5"], ["x3","5","8","6","5"], ["s26"], ["x3","4","8","5","5"], ["s30"], ["3","21","8","7",""], ["s11"], ["4","36"], ["x4","6"], ["s15"], ["7","15","3","9","6","10","2"], ["s13"], ["7","10","3","7","6","13","2"], ["s19"], ["7","7","3","3","6","14","2"], ["x8","5"], ["s6"], ["8","5"], ["s18"], ["8","27"], ["s22"], ["8","38"], ["x8","8"], ["s15"], ["5","4","7"], ["s13"], ["5","9","7"], ["s5"], ["x6","2"], ["s15"], ["6","17"], ["s28"], ["3","5","5","24","2"], ["s21"], ["3","16","5","23","2"], ["x6","33","3"], ["x6","5","3"]] @=> string track1[][];
    
    [["8","1.5","6"], ["s3.5"], ["8","9","6"], ["x8","13","6"], ["s6"], ["8","11","6"], ["s11"], ["7","10"], ["s2.5"], ["7","6.5"], ["s19"], ["5","5"], ["s8"], ["5","2"], ["s109"], ["5","10"], ["s19"], ["5","24"], ["s9"], ["4","4","7"], ["s11"], ["4","3","7"], ["s73"], ["x4","34","7"], ["s6"], ["4","7","7"], ["s10"], ["5","6"], ["x5","12","6"], ["s41"], ["5","11","6"], ["s65"], ["5","4","6"], ["x3","8"], ["s9"], ["3","15"], ["s14"], ["3","16"], ["x8","5"], ["s10"], ["8","29"], ["s14"], ["8","13"], ["s17"], ["7","5","2","9","7","7","1"], ["s23"], ["7","2","2","2","7","3","1"], ["s12"], ["x7","6","2","9","7","4","1"], ["s32"], ["6","8"], ["s16"], ["3","11","5"], ["x3","11","5"], ["x3","8","5"], ["s16"]] @=> string track2[][];
    
    [["s3"], ["6","1"], ["s13"], ["6","35"], ["x6","5"], ["s24"], ["5","8.5","4"], ["s131.5"], ["5","3.5","4"], ["s27.5"], ["x5","10","4"], ["s13"], ["7","5","8","16","1"], ["s85"], ["7","16","8","10","1"], ["x2","2"], ["s16"], ["2","6"], ["s7"], ["2","8"], ["s203"], ["2","10"], ["s9"], ["2","6","8","27","4"], ["s21"], ["2","8","8","11","4"], ["x2","14","8","9","4"], ["s8"], ["7","3"], ["s8"], ["7","3"], ["s13"], ["x7","5"], ["s13"], ["6","6","2","9","8","11","1"], ["s16"], ["6","10","2"], ["x8","11","1"], ["s20"]] @=> string track3[][];
    
    [["s2"], ["2","1"], ["s21"], ["2","7"], ["s42"], ["6","4"], ["x6","3"], ["s9"], ["x6","11.5"], ["s136.5"], ["6","6"], ["s16"], ["8","28","5"], ["s5"], ["x8","6","5"], ["s70"], ["8","7","5"], ["s22"], ["6","2","3","3","8"], ["x6","11","8"], ["x6","4","3","5","8"], ["s14"], ["6","3","3","4","8"], ["s307"], ["6","8","3","18","8"], ["x7","35","4"], ["s39"], ["7","20","4"], ["s8"], ["3","4"], ["x8","2"], ["s16"]] @=> string track4[][];
    
    [["s1"], ["7","2.5"], ["s18.5"], ["7","7.5"], ["s192.5"], ["7","12"], ["s16"], ["x7","6","5","15","8","14","2"], ["s510"], ["8","4","3","8","8"], ["s93"]] @=> string track5[][];
    
    [["s0.5"], ["5","1"], ["s18.5"], ["5","7"], ["s204"], ["5","7"], ["s28"], ["4","4","2","4","6"], ["s12"], ["4","4","2","5","6"], ["x4","3","2","4","6"], ["s598"]] @=> string track6[][];
    
    [["s2.5"], ["8","1"], ["s24.5"], ["7","4","3"], ["s187"], ["7","4","3"], ["s10"], ["x7","6","3"], ["s661"]] @=> string track7[][];
    
    [["s18"], ["6","7","8"], ["s875"]] @=> string track8[][];
    
    Impulse impulse => dac;
    createBuffers() @=> SndBuf2 buffers[];
    
    playIntroClicks(impulse);
    
    spork ~ playTrack(buffers[0], track1);
    spork ~ playTrack(buffers[1], track2);
    spork ~ playTrack(buffers[2], track3);
    spork ~ playTrack(buffers[3], track4);
    spork ~ playTrack(buffers[4], track5);
    spork ~ playTrack(buffers[5], track6);
    spork ~ playTrack(buffers[6], track7);
    spork ~ playTrack(buffers[7], track8);
    
    3::minute => now;
    
    1 => impulse.next;
    
    1::second => now;
}


// create a shuffled array of filenames
fun string[] setRecordStrings() {
    string recordings[42];
    
    for (1 => int i; i <= recordings.size(); i++) {
        i + ".wav" => recordings[i-1];
    }
    for (recordings.size() - 1 => int i; i > 0; i--) {
        Math.random2(0, i) => int index;
        
        recordings[index] => string temp;
        recordings[i] => recordings[index];
        temp => recordings[i];
    }
    for (0 => int i; i < recordings.size(); i++) {
        <<< recordings[i] >>>;
    }
    return recordings;
}


// create an array of sound buffers to play each track
fun SndBuf2[] createBuffers() {
    SndBuf2 buffers[8];
    
    for (0 => int i; i < buffers.size(); i++) {
        buffers[i] => dac;
        getNextRecording(buffers[i]);
        0.0 => buffers[i].gain;
    }
    return buffers;
}


// play clicks in a quarter-eighth-eighth rhythm
fun void playIntroClicks(Impulse impulse) {   
    1 => impulse.next;
    1::second => now;
    
    1 => impulse.next;
    500::ms => now;
    
    1 => impulse.next;
    500::ms => now;
    
    1 => impulse.next;
}


// perform a track as indicated in the score
fun void playTrack(SndBuf2 buffer, string track[][]) {
    "x".charAt(0) => int changeFlag;
    "s".charAt(0) => int silenceFlag;
    200 => int tapeUnit; // represents 0.2 seconds as indicated in the score
    
    for (0 => int i; i < track.size(); i++) {
        track[i] @=> string segment[];
        segment[0].charAt(0) => int flag;
        float duration;
        
        // remove flag for easy string -> float conversion
        if (flag == changeFlag || flag == silenceFlag) {
            segment[0].substring(1) => segment[0];
        }
        
        if (flag == changeFlag) {
            getNextRecording(buffer);
        }
        
        // silence buffer, play with static dynamic, or crescendo/decrescendo as indicated
        if (flag == silenceFlag) {
            0.0 => buffer.gain;
            Std.atof(segment[0]) => duration;
            duration * tapeUnit::ms => now;
        }
        else if (segment.size() == 2) {
            getsScaledDynamic(Std.atof(segment[0])) => buffer.gain;
            Std.atof(segment[1]) => duration;
            duration * tapeUnit::ms => now;
        }
        else {
            for (0 => int i; i < segment.size() - 2; 2 +=> i) {
                Std.atof(segment[i]) => float start;
                Std.atof(segment[i+2]) => float finish;
                Std.atof(segment[i+1]) => duration;
                
                playSegment(buffer, start, finish, duration * tapeUnit);
            }
        }
    }
    
    0.0 => buffer.gain;
    <<< "DONE" >>>;
}


// load next recording; randomly set playback position between beginning and 1:15' before end
fun void getNextRecording(SndBuf2 buffer) {
    me.dir() + "_recordings/" + recordings[recordingIndex] => string file => buffer.read;
    recordingIndex++;
    Math.random2(0, buffer.samples() - 44100 * 75) => int start;
    start < 0 ? 0 : start => buffer.pos;
    <<< file >>>;
}


// map scored dynamic to a wider range
fun float getsScaledDynamic(float dynamic) {
    return Std.scalef(dynamic, 1, 8, 0.05, 1.5);
}


// play a scored segment for the indicated time while moving smoothly between dynamic indications
fun void playSegment(SndBuf2 buffer, float start, float finish, float duration) {
    getsScaledDynamic(start) => start;
    getsScaledDynamic(finish) => finish;
    
    start => buffer.gain;
    finish - start => float difference;
    difference / duration => float increment;
    
    
    for (0 => int i; i < duration; i++) {
        buffer.gain() + increment => buffer.gain;
        1::ms => now;
    }
}
