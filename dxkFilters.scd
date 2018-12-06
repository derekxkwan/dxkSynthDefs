
SynthDef(\dxkLPFM, {|in = 10, out = 10, amp = 1, freq = 18000|
	var input = LPF.ar(In.ar(in, 1), freq, amp);
	Out.ar(out, input);
}).add;

SynthDef(\dxkLPFS, {|in = 10, out = 10, amp = 1, freq = 18000|
	var input = LPF.ar(In.ar(in, 2), freq, amp);
	Out.ar(out, input);
}).add;


SynthDef(\dxkRLPFM, {|in = 10, out = 10, amp = 1, freq = 18000, rq=1|
	var input = RLPF.ar(In.ar(in, 1), freq, rq, amp);
	Out.ar(out, input);
}).add;

SynthDef(\dxkRLPFS, {|in = 10, out = 10, amp = 1, freq = 18000, rq = 1|
	var input = RLPF.ar(In.ar(in, 2), freq, rq, amp);
	Out.ar(out, input);
}).add;

SynthDef(\dxkHPFM, {|in = 10, out = 10, amp = 1, freq = 30|
	var input = HPF.ar(In.ar(in, 1), freq, amp);
	Out.ar(out, input);
}).add;

SynthDef(\dxkHPFS, {|in = 10, out = 10, amp = 1, freq = 30|
	var input = HPF.ar(In.ar(in, 2), freq, amp);
	Out.ar(out, input);
}).add;

SynthDef(\dxkRHPFM, {|in = 10, out = 10, amp = 1, freq = 18000, rq=1|
	var input = RHPF.ar(In.ar(in, 1), freq, rq, amp);
	Out.ar(out, input);
}).add;

SynthDef(\dxkRHPFS, {|in = 10, out = 10, amp = 1, freq = 18000, rq = 1|
	var input = RHPF.ar(In.ar(in, 2), freq, rq, amp);
	Out.ar(out, input);
}).add;

SynthDef(\dxkBPFM, {|in = 10, out = 10, amp = 1, freq = 30, rq = 1|
	var input = BPF.ar(In.ar(in, 1), freq, rq, amp);
	Out.ar(out, input);
}).add;

SynthDef(\dxkBPFS, {|in = 10, out = 10, amp = 1, freq = 30, rq = 1|
	var input = BPF.ar(In.ar(in, 2), freq,  rq, amp);
	Out.ar(out, input);
}).add;

SynthDef(\dxkResonzM, {|in = 10, out = 10, amp = 1, freq = 18000, bwr=1|
	var input = Resonz.ar(In.ar(in, 1), freq, bwr, amp);
	Out.ar(out, input);
}).add;

SynthDef(\dxkResonzS, {|in = 10, out = 10, amp = 1, freq = 18000, bwr = 1|
	var input = Resonz.ar(In.ar(in, 2), freq, bwr, amp);
	Out.ar(out, input);
}).add;

SynthDef(\dxkRingzM, {|in = 10, out = 10, amp = 1, freq = 18000, decay_time=1|
	var input = Ringz.ar(In.ar(in, 1), freq, decay_time, amp);
	Out.ar(out, input);
}).add;

SynthDef(\dxkRingzS, {|in = 10, out = 10, amp = 1, freq = 18000, decay_time = 1|
	var input = Ringz.ar(In.ar(in, 2), freq, decay_time, amp);
	Out.ar(out, input);
}).add;


SynthDef(\dxkHLPFM, {|in = 10, out = 10, amp = 1, freq_hi = 18000, freq_lo = 30|
	var input = HPF.ar(In.ar(in, 1), freq_lo);
	input = LPF.ar(input, freq_hi, amp);
	Out.ar(out, input);
}).add;

SynthDef(\dxkHLPFS, {|in = 10, out = 10, amp = 1, freq_hi = 18000, freq_lo = 30|
	var input = HPF.ar(In.ar(in, 2), freq_lo);
	input = LPF.ar(input, freq_hi, amp);
	Out.ar(out, input);
}).add;
