
SynthDef(\dxkCombNMono, {|delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 10, out = 0, amp = 1|
	var input, sig;
	input = In.ar(in,1);
	sig = CombL.ar(input, maxdelay, delaytime, decaytime, 1);
	Out.ar(out, sig);
}, [0.5]).add;

SynthDef(\dxkCombLMono, {|delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 10, out = 0, amp = 1|
	var input, sig;
	input = In.ar(in,1);
	sig = CombN.ar(input, maxdelay, delaytime, decaytime, 1);
	Out.ar(out, sig);
}, [0.5]).add;

SynthDef(\dxkCombCMono, {|delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 10, out = 0, amp = 1|
	var input, sig;
	input = In.ar(in,1);
	sig = CombC.ar(input, maxdelay, delaytime, decaytime, 1);
	Out.ar(out, sig);
}, [0.5]).add;


SynthDef(\dxkCombNStereo, {|delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 10, out = 0, amp = 1|
	var input, sig;
	input = In.ar(in,2);
	sig = CombL.ar(input, maxdelay, delaytime, decaytime, 1);
	Out.ar(out, sig);
}, [0.5]).add;

SynthDef(\dxkCombLStereo, {|delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 10, out = 0, amp = 1|
	var input, sig;
	input = In.ar(in,2);
	sig = CombN.ar(input, maxdelay, delaytime, decaytime, 1);
	Out.ar(out, sig);
}, [0.5]).add;

SynthDef(\dxkCombCStereo, {|delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 10, out = 0, amp = 1|
	var input, sig;
	input = In.ar(in,2);
	sig = CombC.ar(input, maxdelay, delaytime, decaytime, 1);
	Out.ar(out, sig);
}, [0.5]).add;

SynthDef(\dxkAllpassNMono, {|delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 10, out = 0, amp = 1|
	var input, sig;
	input = In.ar(in,1);
	sig = AllpassL.ar(input, maxdelay, delaytime, decaytime, 1);
	Out.ar(out, sig);
}, [0.5]).add;

SynthDef(\dxkAllpassLMono, {|delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 10, out = 0, amp = 1|
	var input, sig;
	input = In.ar(in,1);
	sig = AllpassN.ar(input, maxdelay, delaytime, decaytime, 1);
	Out.ar(out, sig);
}, [0.5]).add;

SynthDef(\dxkAllpassCMono, {|delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 10, out = 0, amp = 1|
	var input, sig;
	input = In.ar(in,1);
	sig = AllpassC.ar(input, maxdelay, delaytime, decaytime, 1);
	Out.ar(out, sig);
}, [0.5]).add;


SynthDef(\dxkAllpassNStereo, {|delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 10, out = 0, amp = 1|
	var input, sig;
	input = In.ar(in,2);
	sig = AllpassL.ar(input, maxdelay, delaytime, decaytime, 1);
	Out.ar(out, sig);
}, [0.5]).add;

SynthDef(\dxkAllpassLStereo, {|delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 10, out = 0, amp = 1|
	var input, sig;
	input = In.ar(in,2);
	sig = AllpassN.ar(input, maxdelay, delaytime, decaytime, 1);
	Out.ar(out, sig);
}, [0.5]).add;

SynthDef(\dxkAllpassCStereo, {|delaytime = 0.2, maxdelay = 1, decaytime = 1, in = 10, out = 0, amp = 1|
	var input, sig;
	input = In.ar(in,2);
	sig = AllpassC.ar(input, maxdelay, delaytime, decaytime, 1);
	Out.ar(out, sig);
}, [0.5]).add;