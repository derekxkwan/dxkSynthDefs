//dxkFx with XOut
//doesn't require sc3-plugins
SynthDef(\dxkXBitcrushM, {|bits = 64, downsamp = 1, amp = 1, pan = 0,  out = 0, gate = 1|
	var input, output, trig, selector, env;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	trig = Impulse.ar(SampleRate.ir/downsamp);
	input = In.ar(out, 1);
	output = input.round(2.pow(bits).reciprocal);
	selector = BinaryOpUGen('>', downsamp, 1);
	output = Select.ar(selector, [output, Latch.ar(output, trig)]);
	output = Pan2.ar(output, pan);
	XOut.ar(out, env, output);
}).add;

SynthDef(\dxkXBitcrushS, {|bits = 64, downsamp = 1, amp = 1,  out = 0, gate = 1|
	var input, output, trig, selector, env;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	trig = Impulse.ar(SampleRate.ir/downsamp);
	input = In.ar(out, 2);
	output = input.round(2.pow(bits).reciprocal);
	selector = BinaryOpUGen('>', downsamp, 1);
	output = Select.ar(selector, [output, Latch.ar(output, trig)]);
	XOut.ar(out, env, output);
}).add;


SynthDef(\dxkXTanhM, {|pregain = 2, amp = 1, distort = 1, in = 10, out = 0, gate = 1|
	var input, output, selector, env;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	selector = BinaryOpUGen('>', distort, 1);
	input = In.ar(in, 1);
	output = Select.ar(selector, [input, (input*pregain).tanh]);
	output = output * amp;
	XOut.ar(out, env, output);
}).add;


SynthDef(\dxkXTanhS, {|pregain = 2, amp = 1, distort = 1, in = 10, out = 0, gate = 1|
	var input, output, selector, env;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	selector = BinaryOpUGen('>', distort, 1);
	input = In.ar(in, 2);
	output = Select.ar(selector, [input, (input*pregain).tanh]);
	output = output * amp;
	XOut.ar(out, env, output);
}).add;

SynthDef(\dxkXDistortM, {|pregain = 2, amp = 1, distort = 1, in = 10, out = 0, gate = 1|
	var input, output, selector, env;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	selector = BinaryOpUGen('>', distort, 1);
	input = In.ar(in, 1);
	output = Select.ar(selector, [input, (input*pregain).distort]);
	output = output * amp;
	XOut.ar(out, env, output);
}).add;


SynthDef(\dxkXDistortS, {|pregain = 2, amp = 1, distort = 1, in = 10, out = 0, gate = 1|
	var input, output, selector, env;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	selector = BinaryOpUGen('>', distort, 1);
	input = In.ar(in, 2);
	output = Select.ar(selector, [input, (input*pregain).distort]);
	output = output * amp;
	XOut.ar(out, env, output);
}).add;

SynthDef(\dxkXSoftclipM, {|pregain = 2, amp = 1, distort = 1, in = 10, out = 0, gate = 1|
	var input, output, selector, env;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	selector = BinaryOpUGen('>', distort, 1);
	input = In.ar(in, 1);
	output = Select.ar(selector, [input, (input*pregain).softclip]);
	output = output * amp;
	XOut.ar(out, env, output);
}).add;


SynthDef(\dxkXSoftclipS, {|pregain = 2, amp = 1, distort = 1, in = 10, out = 0, gate = 1|
	var input, output, selector, env;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	selector = BinaryOpUGen('>', distort, 1);
	input = In.ar(in, 2);
	output = Select.ar(selector, [input, (input*pregain).softclip]);
	output = output * amp;
	XOut.ar(out, env, output);
}).add;


//requires sc3-plugins
SynthDef(\dxkXDecimM, {|bits = 24, downsamp = 1, amp =1, pan = 0,  out = 0, gate = 1|
	var input, output, env;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	input = In.ar(out, 1);
	output = Decimator.ar(input, SampleRate.ir/downsamp, bits, amp);
	output = Pan2.ar(output, pan);
	XOut.ar(out, env, output);
}).add;

SynthDef(\dxkXDecimS, {|bits = 24, downsamp = 1, amp =1,  out = 0, gate = 1|
	var input, output, env;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	input = In.ar(out, 2);
	output = Decimator.ar(input, SampleRate.ir/downsamp, bits, amp);
	XOut.ar(out, env, output);
}).add;