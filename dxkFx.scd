//doesn't require sc3-plugins
SynthDef(\dxkBitcrushM, {|bits = 64, downsamp = 1, amp = 1, pan = 0, in = 10, out = 0|
	var input, output, trig, selector;
	trig = Impulse.ar(SampleRate.ir/downsamp);
	input = In.ar(in, 1);
	output = input.round(2.pow(bits).reciprocal);
	selector = BinaryOpUGen('>', downsamp, 1);
	output = Select.ar(selector, [output, Latch.ar(output, trig)]);
	output = Pan2.ar(output, pan);
	Out.ar(out, output);
}).add;

SynthDef(\dxkBitcrushS, {|bits = 64, downsamp = 1, amp = 1, in = 10, out = 0|
	var input, output, trig, selector;
	trig = Impulse.ar(SampleRate.ir/downsamp);
	input = In.ar(in, 2);
	output = input.round(2.pow(bits).reciprocal);
	selector = BinaryOpUGen('>', downsamp, 1);
	output = Select.ar(selector, [output, Latch.ar(output, trig)]);
	Out.ar(out, output);
}).add;


//requires sc3-plugins
SynthDef(\dxkDecimM, {|bits = 24, downsamp = 1, amp =1, pan = 0, in = 10, out = 0|
	var input, output;
	input = In.ar(in, 1);
	output = Decimator.ar(input, SampleRate.ir/downsamp, bits, amp);
	output = Pan2.ar(output, pan);
	Out.ar(out, output);
}).add;

SynthDef(\dxkDecimS, {|bits = 24, downsamp = 1, amp =1, in = 10, out = 0|
	var input, output;
	input = In.ar(in, 2);
	output = Decimator.ar(input, SampleRate.ir/downsamp, bits, amp);
	Out.ar(out, output);
}).add;