
SynthDef(\dxkRLPFM, {|in = 10, out = 10, amp = 1, freq = 18000|
	var input = LPF.ar(In.ar(in, 1), freq, amp);
	ReplaceOut.ar(out, input);
}).add;

SynthDef(\dxkRLPFS, {|in = 10, out = 10, amp = 1, freq = 18000|
	var input = LPF.ar(In.ar(in, 2), freq, amp);
	ReplaceOut.ar(out, input);
}).add;


SynthDef(\dxkRRLPFM, {|in = 10, out = 10, amp = 1, freq = 18000, rq=1|
	var input = RLPF.ar(In.ar(in, 1), freq, rq, amp);
	ReplaceOut.ar(out, input);
}).add;

SynthDef(\dxkRRLPFS, {|in = 10, out = 10, amp = 1, freq = 18000, rq = 1|
	var input = RLPF.ar(In.ar(in, 2), freq, rq, amp);
	ReplaceOut.ar(out, input);
}).add;

SynthDef(\dxkRHPFM, {|in = 10, out = 10, amp = 1, freq = 30|
	var input = HPF.ar(In.ar(in, 1), freq, amp);
	ReplaceOut.ar(out, input);
}).add;

SynthDef(\dxkRHPFS, {|in = 10, out = 10, amp = 1, freq = 30|
	var input = HPF.ar(In.ar(in, 2), freq, amp);
	ReplaceOut.ar(out, input);
}).add;

SynthDef(\dxkRRHPFM, {|in = 10, out = 10, amp = 1, freq = 18000, rq=1|
	var input = RHPF.ar(In.ar(in, 1), freq, rq, amp);
	ReplaceOut.ar(out, input);
}).add;

SynthDef(\dxkRRHPFS, {|in = 10, out = 10, amp = 1, freq = 18000, rq = 1|
	var input = RHPF.ar(In.ar(in, 2), freq, rq, amp);
	ReplaceOut.ar(out, input);
}).add;

SynthDef(\dxkRBPFM, {|in = 10, out = 10, amp = 1, freq = 30, rq = 1|
	var input = BPF.ar(In.ar(in, 1), freq, rq, amp);
	ReplaceOut.ar(out, input);
}).add;

SynthDef(\dxkRBPFS, {|in = 10, out = 10, amp = 1, freq = 30, rq = 1|
	var input = BPF.ar(In.ar(in, 2), freq,  rq, amp);
	ReplaceOut.ar(out, input);
}).add;

SynthDef(\dxkRResonzM, {|in = 10, out = 10, amp = 1, freq = 18000, bwr=1|
	var input = Resonz.ar(In.ar(in, 1), freq, bwr, amp);
	ReplaceOut.ar(out, input);
}).add;

SynthDef(\dxkRResonzS, {|in = 10, out = 10, amp = 1, freq = 18000, bwr = 1|
	var input = Resonz.ar(In.ar(in, 2), freq, bwr, amp);
	ReplaceOut.ar(out, input);
}).add;

SynthDef(\dxkRRingzM, {|in = 10, out = 10, amp = 1, freq = 18000, decay_time=1|
	var input = Ringz.ar(In.ar(in, 1), freq, decay_time, amp);
	ReplaceOut.ar(out, input);
}).add;

SynthDef(\dxkRRingzS, {|in = 10, out = 10, amp = 1, freq = 18000, decay_time = 1|
	var input = Ringz.ar(In.ar(in, 2), freq, decay_time, amp);
	ReplaceOut.ar(out, input);
}).add;
