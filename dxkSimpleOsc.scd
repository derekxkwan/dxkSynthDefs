
SynthDef(\dxkPulseASR, {|outbus = 0, freq = 440, amp = 1, pan = 0, width = 0.5,att = 0.001,rel = 0.001, gate = 1|
	var out,env;
	env = EnvGen.ar(Env.asr(att,1,rel),gate, doneAction: 2);
	out = Pulse.ar(freq, width, amp);
	out = Pan2.ar(out, pan);
	Out.ar(outbus,out)
	}).add;


SynthDef(\dxkPulseADSR, {|outbus = 0, freq = 440, amp = 1, pan = 0, width = 0.5,att = 0.001, decay = 0.3, suslvl = 0.5, rel = 1, gate = 1|
	var out,env;
	env = EnvGen.ar(Env.adsr(att,decay,suslvl,rel),gate, doneAction: 2);
	out = Pulse.ar(freq, width, amp);
	out = Pan2.ar(out, pan);
	Out.ar(outbus,out)
	}).add;


SynthDef(\dxkPulsePerc, {|outbus = 0, freq = 440, amp = 1, pan = 0, width = 0.5,att = 0.001,rel = 1, curve = -4, gate = 1|
	var out,env;
	env = EnvGen.ar(Env.perc(att,rel, 1, curve),gate, doneAction: 2);
	out = Pulse.ar(freq, width, amp);
	out = Pan2.ar(out, pan);
	Out.ar(outbus,out)
	}).add;

SynthDef(\dxkSinASR, {|outbus = 0, freq = 440, amp = 1, pan = 0, att = 0.001,rel = 1, gate = 1|
	var out,env;
	env = EnvGen.ar(Env.asr(att,1,rel),gate, doneAction: 2);
	out = SinOsc.ar(freq, 0, amp);
	out = Pan2.ar(out, pan);
	Out.ar(outbus,out)
	}).add;


SynthDef(\dxkSinADSR, {|outbus = 0, freq = 440, amp = 1, pan = 0, att = 0.001, decay = 0.3, suslvl = 0.5, rel = 1, gate = 1|
	var out,env;
	env = EnvGen.ar(Env.adsr(att,decay,suslvl,rel),gate, doneAction: 2);
	out = SinOsc.ar(freq, 0, amp);
	out = Pan2.ar(out, pan);
	Out.ar(outbus,out)
	}).add;



SynthDef(\dxkSinPerc, {|outbus = 0, freq = 440, amp = 1, pan = 0, att = 0.001,rel = 1, curve = -4, gate = 1|
	var out,env;
	env = EnvGen.ar(Env.perc(att,rel, 1, curve),gate, doneAction: 2);
	out = SinOsc.ar(freq, 0, amp);
	out = Pan2.ar(out, pan);
	Out.ar(outbus,out)
	}).add;



SynthDef(\dxkVarSawASR, {|outbus = 0, freq = 440, amp = 1, pan = 0, width = 0.5,att = 0.001,rel = 0.001, gate = 1|
	var out,env;
	env = EnvGen.ar(Env.asr(att,1,rel),gate, doneAction: 2);
	out = VarSaw.ar(freq, 0, width, amp);
	out = Pan2.ar(out, pan);
	Out.ar(outbus,out)
	}).add;


SynthDef(\dxkVarSawADSR, {|outbus = 0, freq = 440, amp = 1, pan = 0, width = 0.5, att = 0.001, decay = 0.3, suslvl = 0.5, rel = 1, gate = 1|
	var out,env;
	env = EnvGen.ar(Env.adsr(att,decay,suslvl,rel),gate, doneAction: 2);
	out = VarSaw.ar(freq, 0, width, amp);
	out = Pan2.ar(out, pan);
	Out.ar(outbus,out)
	}).add;


SynthDef(\dxkVarSawPerc, {|outbus = 0, freq = 440, amp = 1, pan = 0, width = 0.5,att = 0.001,rel = 1, curve = -4, gate = 1|
	var out,env;
	env = EnvGen.ar(Env.perc(att,rel, 1, curve),gate, doneAction: 2);
	out = VarSaw.ar(freq, 0,width, amp);
	out = Pan2.ar(out, pan);
	Out.ar(outbus,out)
	}).add;


SynthDef(\dxkSawASR, {|outbus = 0, freq = 440, amp = 1, pan = 0, att = 0.001,rel = 1, gate = 1|
	var out,env;
	env = EnvGen.ar(Env.asr(att,1,rel),gate, doneAction: 2);
	out = Saw.ar(freq, amp);
	out = Pan2.ar(out, pan);
	Out.ar(outbus,out)
	}).add;


SynthDef(\dxkSawADSR, {|outbus = 0, freq = 440, amp = 1, pan = 0, att = 0.001, decay = 0.3, suslvl = 0.5, rel = 1, gate = 1|
	var out,env;
	env = EnvGen.ar(Env.adsr(att,decay,suslvl,rel),gate, doneAction: 2);
	out = Saw.ar(freq, amp);
	out = Pan2.ar(out, pan);
	Out.ar(outbus,out)
	}).add;



SynthDef(\dxkSawPerc, {|outbus = 0, freq = 440, amp = 1, pan = 0, att = 0.001,rel = 1, curve = -4, gate = 1|
	var out,env;
	env = EnvGen.ar(Env.perc(att,rel, 1, curve),gate, doneAction: 2);
	out = Saw.ar(freq, amp);
	out = Pan2.ar(out, pan);
	Out.ar(outbus,out)
	}).add;


SynthDef(\dxkSin2ASR, {|outbus = 0, freq = 440, detune = 0.01, amp = 1, pan = 0, att = 0.001,rel = 1, gate = 1|
	var out,env;
	env = EnvGen.ar(Env.asr(att,1,rel),gate, doneAction: 2);
	out = SinOsc.ar([freq,freq*(1+detune)], 0, amp);
	out = Mix.new(out);
	out = Pan2.ar(out, pan);
	Out.ar(outbus,out)
	}).add;


SynthDef(\dxkSin2ADSR, {|outbus = 0, freq = 440, detune = 0.01, amp = 1, pan = 0, att = 0.001, decay = 0.3, suslvl = 0.5, rel = 1, gate = 1|
	var out,env;
	env = EnvGen.ar(Env.adsr(att,decay,suslvl,rel),gate, doneAction: 2);
	out = SinOsc.ar([freq,freq*(1+detune)], 0, amp);
	out = Mix.new(out);
	out = Pan2.ar(out, pan);
	Out.ar(outbus,out)
	}).add;



SynthDef(\dxkSin2Perc, {|outbus = 0, freq = 440, detune = 0.01, amp = 1, pan = 0, att = 0.001,rel = 1, curve = -4, gate = 1|
	var out,env;
	env = EnvGen.ar(Env.perc(att,rel, 1, curve),gate, doneAction: 2);
	out = SinOsc.ar([freq,freq*(1+detune)], 0, amp);
	out = Mix.new(out);
	out = Pan2.ar(out, pan);
	Out.ar(outbus,out)
	}).add;

