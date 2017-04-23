
SynthDef(\dxkCombNMono, {|delaytime = 0.2, maxdelay = 1, decaytime = 1, inbus = 10, outbus = 0, amp = 1|
	var in, out;
	in = In.ar(inbus,1);
	out = CombL.ar(in, maxdelay, delaytime, decaytime, 1);
	Out.ar(outbus, out);
}, [0.5]).add;

SynthDef(\dxkCombLMono, {|delaytime = 0.2, maxdelay = 1, decaytime = 1, inbus = 10, outbus = 0, amp = 1|
	var in, out;
	in = In.ar(inbus,1);
	out = CombN.ar(in, maxdelay, delaytime, decaytime, 1);
	Out.ar(outbus, out);
}, [0.5]).add;

SynthDef(\dxkCombCMono, {|delaytime = 0.2, maxdelay = 1, decaytime = 1, inbus = 10, outbus = 0, amp = 1|
	var in, out;
	in = In.ar(inbus,1);
	out = CombC.ar(in, maxdelay, delaytime, decaytime, 1);
	Out.ar(outbus, out);
}, [0.5]).add;


SynthDef(\dxkCombNStereo, {|delaytime = 0.2, maxdelay = 1, decaytime = 1, inbus = 10, outbus = 0, amp = 1|
	var in, out;
	in = In.ar(inbus,2);
	out = CombL.ar(in, maxdelay, delaytime, decaytime, 1);
	Out.ar(outbus, out);
}, [0.5]).add;

SynthDef(\dxkCombLStereo, {|delaytime = 0.2, maxdelay = 1, decaytime = 1, inbus = 10, outbus = 0, amp = 1|
	var in, out;
	in = In.ar(inbus,2);
	out = CombN.ar(in, maxdelay, delaytime, decaytime, 1);
	Out.ar(outbus, out);
}, [0.5]).add;

SynthDef(\dxkCombCStereo, {|delaytime = 0.2, maxdelay = 1, decaytime = 1, inbus = 10, outbus = 0, amp = 1|
	var in, out;
	in = In.ar(inbus,2);
	out = CombC.ar(in, maxdelay, delaytime, decaytime, 1);
	Out.ar(outbus, out);
}, [0.5]).add;

SynthDef(\dxkAllpassNMono, {|delaytime = 0.2, maxdelay = 1, decaytime = 1, inbus = 10, outbus = 0, amp = 1|
	var in, out;
	in = In.ar(inbus,1);
	out = AllpassL.ar(in, maxdelay, delaytime, decaytime, 1);
	Out.ar(outbus, out);
}, [0.5]).add;

SynthDef(\dxkAllpassLMono, {|delaytime = 0.2, maxdelay = 1, decaytime = 1, inbus = 10, outbus = 0, amp = 1|
	var in, out;
	in = In.ar(inbus,1);
	out = AllpassN.ar(in, maxdelay, delaytime, decaytime, 1);
	Out.ar(outbus, out);
}, [0.5]).add;

SynthDef(\dxkAllpassCMono, {|delaytime = 0.2, maxdelay = 1, decaytime = 1, inbus = 10, outbus = 0, amp = 1|
	var in, out;
	in = In.ar(inbus,1);
	out = AllpassC.ar(in, maxdelay, delaytime, decaytime, 1);
	Out.ar(outbus, out);
}, [0.5]).add;


SynthDef(\dxkAllpassNStereo, {|delaytime = 0.2, maxdelay = 1, decaytime = 1, inbus = 10, outbus = 0, amp = 1|
	var in, out;
	in = In.ar(inbus,2);
	out = AllpassL.ar(in, maxdelay, delaytime, decaytime, 1);
	Out.ar(outbus, out);
}, [0.5]).add;

SynthDef(\dxkAllpassLStereo, {|delaytime = 0.2, maxdelay = 1, decaytime = 1, inbus = 10, outbus = 0, amp = 1|
	var in, out;
	in = In.ar(inbus,2);
	out = AllpassN.ar(in, maxdelay, delaytime, decaytime, 1);
	Out.ar(outbus, out);
}, [0.5]).add;

SynthDef(\dxkAllpassCStereo, {|delaytime = 0.2, maxdelay = 1, decaytime = 1, inbus = 10, outbus = 0, amp = 1|
	var in, out;
	in = In.ar(inbus,2);
	out = AllpassC.ar(in, maxdelay, delaytime, decaytime, 1);
	Out.ar(outbus, out);
}, [0.5]).add;