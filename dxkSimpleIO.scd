SynthDef(\dxkM2M, {|in = 0, gain = 1, out = 10, amp = 1|
	var input = SoundIn.ar(in, gain);
	Out.ar(out, input*amp);
}).add;

SynthDef(\dxkM2S, {|in = 0, gain = 1, out = 10, amp = 1, pan = 0|
	var input = SoundIn.ar(in, gain);
	var output = Pan2.ar(input, pan);
	Out.ar(out, output*amp);
}).add;
