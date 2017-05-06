SynthDef(\dxkXFreeVerb2, {| out = 0, mix = 0.33, room = 0.5, damp = 0.5, amp = 1, gate = 1|
	var input, output, env;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	input = In.ar(out, 2);
	output = FreeVerb2.ar(input[0], input[1], mix, room, damp, amp);
	XOut.ar(out, env, output)
}).add;