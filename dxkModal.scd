//based on John Bower's list of modal frequencies: http://www.csounds.com/manual/html/MiscModalFreq.html

//sounds good around freq = 1000 too!
SynthDef(\dxkUWoodBank, {|t_trig = 1, freq = 100, pitchy = 0.75,  amp = 1, pan = 0, out = 0|
	var freqs = freq * [1, 2.572, 4.644, 6.984, 9.823, 12];
	var amps = [1, 1, 0.75, 0.75, 0.5, 0.1, 0.1] * freqs.size.reciprocal;
	var rings = [0.1, 0.01, 0.01, 0.05, 0.01, 0.01]*pitchy;
	var exciter = Trig.ar(t_trig, 64/SampleRate.ir);
	var output = Klank.ar(`[freqs, amps, rings], exciter);
	output = Pan2.ar(output, pan);
	DetectSilence.ar(output, doneAction: 2);
	Out.ar(out, output);
}).add;