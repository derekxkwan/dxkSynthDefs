
SynthDef(\dxkPulseASR, {|out = 0, freq = 440, amp = 1, pan = 0, width = 0.5,att = 0.01,rel = 0.001, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.asr(att,1,rel),gate, doneAction: 2);
	sig = Pulse.ar(freq, width, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;


SynthDef(\dxkPulseADSR, {|out = 0, freq = 440, amp = 1, pan = 0, width = 0.5,att = 0.01, decay = 0.3, suslvl = 0.5, rel = 1, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.adsr(att,decay,suslvl,rel),gate, doneAction: 2);
	sig = Pulse.ar(freq, width, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;


SynthDef(\dxkPulsePerc, {|out = 0, freq = 440, amp = 1, pan = 0, width = 0.5,att = 0.01,rel = 1, curve = -4, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.perc(att,rel, 1, curve),gate, doneAction: 2);
	sig = Pulse.ar(freq, width, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;

SynthDef(\dxkSinASR, {|out = 0, freq = 440, amp = 1, pan = 0, att = 0.01,rel = 1, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.asr(att,1,rel),gate, doneAction: 2);
	sig = SinOsc.ar(freq, 0, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;


SynthDef(\dxkSinADSR, {|out = 0, freq = 440, amp = 1, pan = 0, att = 0.01, decay = 0.3, suslvl = 0.5, rel = 1, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.adsr(att,decay,suslvl,rel),gate, doneAction: 2);
	sig = SinOsc.ar(freq, 0, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;



SynthDef(\dxkSinPerc, {|out = 0, freq = 440, amp = 1, pan = 0, att = 0.001,rel = 1, curve = -4, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.perc(att,rel, 1, curve),gate, doneAction: 2);
	sig = SinOsc.ar(freq, 0, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;



SynthDef(\dxkVarSawASR, {|out = 0, freq = 440, amp = 1, pan = 0, width = 0.5,att = 0.01,rel = 0.001, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.asr(att,1,rel),gate, doneAction: 2);
	sig = VarSaw.ar(freq, 0, width, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;


SynthDef(\dxkVarSawADSR, {|out = 0, freq = 440, amp = 1, pan = 0, width = 0.5, att = 0.01, decay = 0.3, suslvl = 0.5, rel = 1, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.adsr(att,decay,suslvl,rel),gate, doneAction: 2);
	sig = VarSaw.ar(freq, 0, width, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;


SynthDef(\dxkVarSawPerc, {|out = 0, freq = 440, amp = 1, pan = 0, width = 0.5,att = 0.01,rel = 1, curve = -4, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.perc(att,rel, 1, curve),gate, doneAction: 2);
	sig = VarSaw.ar(freq, 0,width, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;


SynthDef(\dxkSawASR, {|out = 0, freq = 440, amp = 1, pan = 0, att = 0.01,rel = 1, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.asr(att,1,rel),gate, doneAction: 2);
	sig = Saw.ar(freq, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;


SynthDef(\dxkSawADSR, {|out = 0, freq = 440, amp = 1, pan = 0, att = 0.01, decay = 0.3, suslvl = 0.5, rel = 1, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.adsr(att,decay,suslvl,rel),gate, doneAction: 2);
	sig = Saw.ar(freq, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;



SynthDef(\dxkSawPerc, {|out = 0, freq = 440, amp = 1, pan = 0, att = 0.01,rel = 1, curve = -4, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.perc(att,rel, 1, curve),gate, doneAction: 2);
	sig = Saw.ar(freq, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;


SynthDef(\dxkSin2ASR, {|out = 0, freq = 440, detune = 0.01, amp = 1, pan = 0, att = 0.01,rel = 1, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.asr(att,1,rel),gate, doneAction: 2);
	sig = SinOsc.ar([freq,freq*(1+detune)], 0, amp);
	sig = Mix.new(sig);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;


SynthDef(\dxkSin2ADSR, {|out = 0, freq = 440, detune = 0.01, amp = 1, pan = 0, att = 0.01, decay = 0.3, suslvl = 0.5, rel = 1, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.adsr(att,decay,suslvl,rel),gate, doneAction: 2);
	sig = SinOsc.ar([freq,freq*(1+detune)], 0, amp);
	sig = Mix.new(sig);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;



SynthDef(\dxkSin2Perc, {|out = 0, freq = 440, detune = 0.01, amp = 1, pan = 0, att = 0.01,rel = 1, curve = -4, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.perc(att,rel, 1, curve),gate, doneAction: 2);
	sig = SinOsc.ar([freq,freq*(1+detune)], 0, amp);
	sig = Mix.new(sig);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;

