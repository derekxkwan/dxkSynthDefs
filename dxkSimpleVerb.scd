SynthDef(\dxkFreeVerb2, {|in = 10, in2 = 11, out = 0, mix = 0.33, room = 0.5, damp = 0.5, amp = 1|
	var input, input2, output;
	input = In.ar(in, 1);
	input2 = In.ar(in2, 1);
	output = FreeVerb2.ar(input, input2, mix, room, damp, amp);
	ReplaceOut.ar(out, output)
}).add;