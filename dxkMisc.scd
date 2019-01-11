//miscellanous SynthDefs

SynthDef(\dxkOutMM, {|in=10,out=0,amp=1|
	var input = In.ar(in,1);
	Out.ar(out, input*amp);
}).add;

SynthDef(\dxkOutMS, {|in=10, out=0, amp=1, pan = 0|
	var input = In.ar(in, 1);
	input = Pan2.ar(input,pan,amp);
	Out.ar(out, input);
}).add;

SynthDef(\dxkOutSS, {|in=10, out=0, amp=1|
	var input = In.ar(in, 2);
	Out.ar(out, input*amp);
}).add;

// with compander
SynthDef(\dxkOutCMM, {|in = 10, out = 0, gain = 1, amp = 1, thresh = 1, slope_below = 0, slope_above = 0.333,
	clamp_time = 0.01, relax_time = 0.01|
	var input = In.ar(in, 1) * gain;
	input = Compander.ar(input,input,thresh, slope_below, slope_above, clamp_time, relax_time, amp);
	Out.ar(out, input);
}).add;

SynthDef(\dxkOutCMS, {|in = 10, out = 0, gain = 1, amp = 1, pan = 0, thresh = 1, slope_below = 0, slope_above = 0.333,
	clamp_time = 0.01, relax_time = 0.01|
	var input = In.ar(in, 1) * gain;
	input = Compander.ar(input,input,thresh, slope_below, slope_above, clamp_time, relax_time);
	input = Pan2.ar(input, pan, amp);
	Out.ar(out, input);
}).add;

SynthDef(\dxkOutCSS, {|in = 10, out = 0, gain = 1, amp = 1, thresh = 1, slope_below = 0, slope_above = 0.333,
	clamp_time = 0.01, relax_time = 0.01|
	var input = In.ar(in, 2) * gain;
	input = Compander.ar(input,input,thresh, slope_below, slope_above, clamp_time, relax_time, amp);
	Out.ar(out, input);
}).add;

//

SynthDef(\dxkKrBusSet, {
	arg bus, val = 0, lag = 0.01;
	var opt = Lag.kr(val, lag);
	Out.kr(bus, opt);
}).add;

SynthDef(\dxkArBusSet, {
	arg bus, val = 0, lag = 0.01;
	var opt = Lag.ar(K2A.ar(val), lag);
	Out.ar(bus, opt);
}).add;


	