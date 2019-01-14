//doesn't require sc3-plugins
SynthDef(\dxkBitcrushM, {|bits = 64, downsamp = 1, amp = 1, in = 10, out = 0|
	var input, output, trig, selector;
	trig = Impulse.ar(SampleRate.ir/downsamp);
	input = In.ar(in, 1);
	output = input.round(2.pow(bits).reciprocal);
	selector = BinaryOpUGen('>', downsamp, 1);
	output = Select.ar(selector, [output, Latch.ar(output, trig)]);
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


SynthDef(\dxkTanhM, {|pregain = 1, amp = 1, distort = 1, in = 10, out = 0|
	var input, output, selector;
	selector = BinaryOpUGen('>', distort, 0);
	input = In.ar(in, 1);
	output = Select.ar(selector, [input, (input*pregain).tanh]);
	output = output * amp;
	Out.ar(out, output);
}).add;


SynthDef(\dxkTanhS, {|pregain = 1, amp = 1, distort = 1, in = 10, out = 0|
	var input, output, selector;
	selector = BinaryOpUGen('>', distort, 0);
	input = In.ar(in, 2);
	output = Select.ar(selector, [input, (input*pregain).tanh]);
	output = output * amp;
	Out.ar(out, output);
}).add;

SynthDef(\dxkDistortM, {|pregain = 1, amp = 1, distort = 1, in = 10, out = 0|
	var input, output, selector;
	selector = BinaryOpUGen('>', distort, 0);
	input = In.ar(in, 1);
	output = Select.ar(selector, [input, (input*pregain).distort]);
	output = output * amp;
	Out.ar(out, output);
}).add;


SynthDef(\dxkDistortS, {|pregain = 1, amp = 1, distort = 1, in = 10, out = 0|
	var input, output, selector;
	selector = BinaryOpUGen('>', distort, 0);
	input = In.ar(in, 2);
	output = Select.ar(selector, [input, (input*pregain).distort]);
	output = output * amp;
	Out.ar(out, output);
}).add;

SynthDef(\dxkSoftclipM, {|pregain = 1, amp = 1, distort = 1, in = 10, out = 0|
	var input, output, selector;
	selector = BinaryOpUGen('>', distort, 0);
	input = In.ar(in, 1);
	output = Select.ar(selector, [input, (input*pregain).softclip]);
	output = output * amp;
	Out.ar(out, output);
}).add;


SynthDef(\dxkSoftclipS, {|pregain = 1, amp = 1, distort = 1, in = 10, out = 0|
	var input, output, selector;
	selector = BinaryOpUGen('>', distort, 0);
	input = In.ar(in, 2);
	output = Select.ar(selector, [input, (input*pregain).softclip]);
	output = output * amp;
	Out.ar(out, output);
}).add;

SynthDef(\dxkClipM, {|pregain = 1, amp = 1, distort = 1, in = 10, out = 0|
	var input, output, selector;
	selector = BinaryOpUGen('>', distort, 0);
	input = In.ar(in, 1);
	output = Select.ar(selector, [input, Clip.ar(input*pregain, -1, 1)]);
	output = output * amp;
	Out.ar(out, output);
}).add;


SynthDef(\dxkClipS, {|pregain = 1, amp = 1, distort = 1, in = 10, out = 0|
	var input, output, selector;
	selector = BinaryOpUGen('>', distort, 0);
	input = In.ar(in, 2);
	output = Select.ar(selector, [input, Clip.ar(input*pregain, -1, 1)]);
	output = output * amp;
	Out.ar(out, output);
}).add;


SynthDef(\dxkStutLM, {|stut = 0, maxdelay = 2, stutlen = 0.1, ramp = 0.001, in = 10, out = 0|
	//stutlen is length of stutter in seconds
	var input, output, wet, delptr, clock, trig, env;
	input = In.ar(in, 1);
	trig = HPZ1.kr(stut);
	clock = Phasor.ar(trig, stutlen.reciprocal/SampleRate.ir);
	clock = (clock - Delay1.ar(clock)) < 0;
	delptr = Clip.ar(Sweep.ar(trig), 0, maxdelay);
	delptr = Latch.ar(delptr, clock);
	env = EnvGen.ar(Env.asr(ramp, 1, ramp), clock);
	wet = DelayL.ar(input, maxdelay, delptr);
	output = XFade2.ar(input, wet, Lag.kr(stut*2-1, ramp));
	Out.ar(out, output);
}).add;

SynthDef(\dxkStutLS, {|stut = 0, maxdelay = 2, stutlen = 0.1, ramp = 0.001, in = 10, out = 0|
	//stutlen is length of stutter in seconds
	var input, output, wet, delptr, clock, trig, env;
	input = In.ar(in, 2);
	trig = HPZ1.kr(stut);
	clock = Phasor.ar(trig, stutlen.reciprocal/SampleRate.ir);
	clock = (clock - Delay1.ar(clock)) < 0;
	delptr = Clip.ar(Sweep.ar(trig), 0, maxdelay);
	delptr = Latch.ar(delptr, clock);
	env = EnvGen.ar(Env.asr(ramp, 1, ramp), clock);
	wet = DelayL.ar(input, maxdelay, delptr);
	output = XFade2.ar(input, wet, Lag.kr(stut*2-1, ramp));
	Out.ar(out, output);
}).add;

SynthDef(\dxkStutCM, {|stut = 0, maxdelay = 2, stutlen = 0.1, ramp = 0.001, in = 10, out = 0|
	//stutlen is length of stutter in seconds
	var input, output, wet, delptr, clock, trig, env;
	input = In.ar(in, 1);
	trig = HPZ1.kr(stut);
	clock = Phasor.ar(trig, stutlen.reciprocal/SampleRate.ir);
	clock = (clock - Delay1.ar(clock)) < 0;
	delptr = Clip.ar(Sweep.ar(trig), 0, maxdelay);
	delptr = Latch.ar(delptr, clock);
	env = EnvGen.ar(Env.asr(ramp, 1, ramp), clock);
	wet = DelayC.ar(input, maxdelay, delptr);
	output = XFade2.ar(input, wet, Lag.kr(stut*2-1, ramp));
	Out.ar(out, output);
}).add;

SynthDef(\dxkStutCS, {|stut = 0, maxdelay = 2, stutlen = 0.1, ramp = 0.001, in = 10, out = 0|
	//stutlen is length of stutter in seconds
	var input, output, wet, delptr, clock, trig, env;
	input = In.ar(in, 2);
	trig = HPZ1.kr(stut);
	clock = Phasor.ar(trig, stutlen.reciprocal/SampleRate.ir);
	clock = (clock - Delay1.ar(clock)) < 0;
	delptr = Clip.ar(Sweep.ar(trig), 0, maxdelay);
	delptr = Latch.ar(delptr, clock);
	env = EnvGen.ar(Env.asr(ramp, 1, ramp), clock);
	wet = DelayC.ar(input, maxdelay, delptr);
	output = XFade2.ar(input, wet, Lag.kr(stut*2-1, ramp));
	Out.ar(out, output);
}).add;



SynthDef(\dxkCompM, {|in = 10, ctrl = 10, thresh = 0.99, slopeBelow = 1, slopeAbove = 0.33, clampTime = 0.01, relaxTime = 0.01, out = 0, amp = 1|

	var input, control;
	input = In.ar(in, 1);
	control = In.ar(ctrl, 1);
	input = Compander.ar(input, control, thresh, slopeBelow, slopeAbove, clampTime, relaxTime, amp);
	Out.ar(out, input);
}).add;

SynthDef(\dxkCompS, {|in = 10, ctrl = 10, thresh = 0.99, slopeBelow = 1, slopeAbove = 0.33, clampTime = 0.01, relaxTime = 0.01, out = 0, amp = 1|

	var input, control;
	input = In.ar(in, 2);
	control = In.ar(ctrl, 2);
	input = Compander.ar(input, control, thresh, slopeBelow, slopeAbove, clampTime, relaxTime, amp);
	Out.ar(out, input);
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

SynthDef(\dxkMungerM, {|bits = 24, downsamp = 1, amp =1, pregain = 1, in = 10, out = 0|
	var input, output;
	input = In.ar(in, 1);
	input = (input * pregain).tanh;
	output = Decimator.ar(input, SampleRate.ir/downsamp, bits, amp);
	Out.ar(out, output);
}).add;

SynthDef(\dxkMungerS, {|bits = 24, downsamp = 1, amp =1, pregain = 1, in = 10, out = 0|
	var input, output;
	input = In.ar(in, 2);
	input = (input * pregain).tanh;
	output = Decimator.ar(input, SampleRate.ir/downsamp, bits, amp);
	Out.ar(out, output);
}).add;


SynthDef(\dxkMungerFM, {|bits = 24, downsamp = 1, amp =1, pregain = 1, in = 10, lop = 20000, hip = 0, out = 0|
	var input, output;
	input = In.ar(in, 1);
	input = (input * pregain).tanh;
	output = Decimator.ar(input, SampleRate.ir/downsamp, bits);
	output = HPF.ar(LPF.ar(output, lop), hip);
	Out.ar(out, output * amp);
}).add;

SynthDef(\dxkMungerFS, {|bits = 24, downsamp = 1, amp =1, pregain = 1, in = 10, lop = 20000, hip = 0, out = 0|
	var input, output;
	input = In.ar(in, 2);
	input = (input * pregain).tanh;
	output = Decimator.ar(input, SampleRate.ir/downsamp, bits);
	output = HPF.ar(LPF.ar(output, lop), hip);
	Out.ar(out, output * amp);
}).add;

SynthDef(\dxkMungerFLM, {|bits = 24, downsamp = 1, amp =1, pregain = 1, prelag = 0.01, amplag = 0.01, in = 10, lop = 20000, hip = 0, out = 0, curve = 0, warp = 5|
	var input, output;
	input = In.ar(in, 1);
	input = (input * VarLag.kr(pregain,prelag, curve, warp)).tanh;
	output = Decimator.ar(input, SampleRate.ir/downsamp, bits);
	output = HPF.ar(LPF.ar(output, lop), hip);
	Out.ar(out, output * VarLag.kr(amp, amplag, curve, warp));
}).add;

SynthDef(\dxkMungerFLS, {|bits = 24, downsamp = 1, amp =1, pregain = 1, prelag = 0.01, amplag = 0.01, in = 10, lop = 20000, hip = 0, out = 0, curve = 0, warp = 5|
	var input, output;
	input = In.ar(in, 2);
	input = (input * VarLag.kr(pregain,prelag, curve, warp)).tanh;
	output = Decimator.ar(input, SampleRate.ir/downsamp, bits);
	output = HPF.ar(LPF.ar(output, lop), hip);
	Out.ar(out, output * VarLag.kr(amp, amplag, curve, warp));
}).add;


