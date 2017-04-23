(
SynthDef(\dxkPulseASR, {|outbus = 0, freq = 440, amp = 1, pan = 0, width = 0.5,att = 0.001,rel = 0.001, gate = 1|
	var out,env;
	env = EnvGen.ar(Env.asr(att,1,rel),gate, doneAction: 2);
	out = Pulse.ar(freq, width, amp);
	out = Pan2.ar(out, pan);
	Out.ar(outbus,out)
	}).add;
)
