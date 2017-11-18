SynthDef(\dxkFlangerM, {|in = 0, out = 0, rate = 1, maxDelay = 0.01, minDelay = 0.001, decayTime = 1, amp = 1|
	var input = In.ar(in, 1);
	var flanged = CombC.ar(input, maxDelay, SinOsc.ar(rate, 0, (maxDelay * 0.5) - minDelay, (maxDelay * 0.5) + minDelay), decayTime, amp);
	Out.ar(out, flanged);
}).add;

SynthDef(\dxkPhaserM, {|in = 0, out = 0, rate = 1, maxDelay = 0.01, minDelay = 0.001, decayTime = 1, amp = 1|
	var input = In.ar(in, 1);
	var flanged = AllpassC.ar(input, maxDelay, SinOsc.ar(rate, 0, (maxDelay * 0.5) - minDelay, (maxDelay * 0.5) + minDelay), decayTime, amp);
	Out.ar(out, flanged);
}).add;

SynthDef(\dxkChorusM, {|in = 0, out = 0, rate = 1, maxDelay = 0.05, minDelay = 0.01, dry = 1, wet = 1, amp = 1|
	var output, num = 8;
	var input = In.ar(in, 1) * num.reciprocal;
	var lfos = Array.fill(num, {SinOsc.ar(rate * rrand(0.95, 1.05), rrand(0.0, 1.0), (maxDelay * 0.5) - minDelay,  (maxDelay * 0.5) + minDelay)});
	var voices = DelayC.ar(input, maxDelay, lfos);
	voices = Mix.ar(voices);
	output = (dry*input) + (wet*voices);
	Out.ar(out, output);

}).add;