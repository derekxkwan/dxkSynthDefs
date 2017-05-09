//requires DxkFm class from dxkSup

SynthDef(\dxkFmASR, {|gate = 1, freq = 440, modharm = #[2,3,4,6], modidx = #[0.35, 0.3, 0.6, 0.1], att = 0.01, rel = 0.01, amp = 1, pan = 0, out = 0|
	var output, env;
	output = DxkFm.ar(freq, 1, modharm, modidx, amp);
	env = EnvGen.ar(Env.asr(att, 1, rel), gate, doneAction: 2);
	output = output * env;
	output = Pan2.ar(output, pan);
	Out.ar(out, output);
}).add;

SynthDef(\dxkFmPerc, {|t_trig = 1, freq = 440, modharm = #[2,3,4,6], modidx = #[0.35, 0.3, 0.6, 0.1], att = 0.01, rel = 1, amp = 1, pan = 0, out = 0|
	var output, env;
	output = DxkFm.ar(freq, 1, modharm, modidx, amp);
	env = EnvGen.ar(Env.perc(att, rel), t_trig, doneAction: 2);
	output = output * env;
	output = Pan2.ar(output, pan);
	Out.ar(out, output);
}).add;

SynthDef(\dxkFmADSR, {|gate = 1, freq = 440, modharm = #[2,3,4,6], modidx = #[0.35, 0.3, 0.6, 0.1], att = 0.01, decay = 0.3, sus = 0.5, rel = 1, amp = 1, pan = 0, out = 0|
	var output, env;
	output = DxkFm.ar(freq, 1, modharm, modidx, amp);
	env = EnvGen.ar(Env.adsr(att, decay, sus, rel), gate, doneAction: 2);
	output = output * env;
	output = Pan2.ar(output, pan);
	Out.ar(out, output);
}).add;


