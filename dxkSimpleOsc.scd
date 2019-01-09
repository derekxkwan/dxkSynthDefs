
SynthDef(\dxkPulseASR, {|out = 0, freq = 440, amp = 1, pan = 0, width = 0.5,att = 0.01,rel = 0.001, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.asr(att,1,rel),gate, doneAction: 2);
	sig = Pulse.ar(freq, width, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;

SynthDef(\dxkPulseLinen, {|out = 0, freq = 440, amp = 1, pan = 0, width = 0.5,att = 0.01, sus = 1, rel = 0.001, curve = \lin, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.linen(att,sus,rel, 1, curve),gate, doneAction: 2);
	sig = Pulse.ar(freq, width, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;


SynthDef(\dxkPulseADSR, {|out = 0, freq = 440, amp = 1, pan = 0, width = 0.5,att = 0.01, decay = 0.3, sus = 0.5, rel = 1, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.adsr(att,decay,sus,rel),gate, doneAction: 2);
	sig = Pulse.ar(freq, width, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;


SynthDef(\dxkPulsePerc, {|t_trig = 1, out = 0, freq = 440, amp = 1, pan = 0, width = 0.5,att = 0.01,rel = 1, curve = -4|
	var sig,env;
	env = EnvGen.ar(Env.perc(att,rel, 1, curve),t_trig, doneAction: 2);
	sig = Pulse.ar(freq, width, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;

SynthDef(\dxkPulseTriangle, {|t_trig = 1, out = 0, freq = 440, amp = 1, pan = 0, width = 0.5,len = 1|
	var sig,env;
	env = EnvGen.ar(Env.triangle(len),t_trig, doneAction: 2);
	sig = Pulse.ar(freq, width, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;

SynthDef(\dxkPulseSine, {|t_trig = 1, out = 0, freq = 440, amp = 1, pan = 0, width = 0.5,len = 1|
	var sig,env;
	env = EnvGen.ar(Env.sine(len),t_trig, doneAction: 2);
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

SynthDef(\dxkSinLinen, {|out = 0, freq = 440, amp = 1, pan = 0, att = 0.01, sus = 1, rel = 1, curve = \lin, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.linen(att,sus,rel, 1, curve),gate, doneAction: 2);
	sig = SinOsc.ar(freq, 0, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;

SynthDef(\dxkSinADSR, {|out = 0, freq = 440, amp = 1, pan = 0, att = 0.01, decay = 0.3, sus = 0.5, rel = 1, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.adsr(att,decay,sus,rel),gate, doneAction: 2);
	sig = SinOsc.ar(freq, 0, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;



SynthDef(\dxkSinPerc, {|t_trig = 1, out = 0, freq = 440, amp = 1, pan = 0, att = 0.001,rel = 1, curve = -4|
	var sig,env;
	env = EnvGen.ar(Env.perc(att,rel, 1, curve),t_trig, doneAction: 2);
	sig = SinOsc.ar(freq, 0, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;

SynthDef(\dxkSinTriangle, {|t_trig = 1, out = 0, freq = 440, amp = 1, pan = 0, len = 1|
	var sig,env;
	env = EnvGen.ar(Env.triangle(len),t_trig, doneAction: 2);
	sig = SinOsc.ar(freq, 0, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;

SynthDef(\dxkSinSine, {|t_trig = 1, out = 0, freq = 440, amp = 1, pan = 0, len = 1|
	var sig,env;
	env = EnvGen.ar(Env.sine(len),t_trig, doneAction: 2);
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

SynthDef(\dxkVarSawLinen, {|out = 0, freq = 440, amp = 1, pan = 0, width = 0.5,att = 0.01, sus = 1, rel = 0.001, curve = \lin, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.linen(att,sus,rel, 1, curve),gate, doneAction: 2);
	sig = VarSaw.ar(freq, 0, width, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;

SynthDef(\dxkVarSawADSR, {|out = 0, freq = 440, amp = 1, pan = 0, width = 0.5, att = 0.01, decay = 0.3, sus = 0.5, rel = 1, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.adsr(att,decay,sus,rel),gate, doneAction: 2);
	sig = VarSaw.ar(freq, 0, width, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;


SynthDef(\dxkVarSawPerc, {|t_trig = 1, out = 0, freq = 440, amp = 1, pan = 0, width = 0.5,att = 0.01,rel = 1, curve = -4|
	var sig,env;
	env = EnvGen.ar(Env.perc(att,rel, 1, curve), t_trig, doneAction: 2);
	sig = VarSaw.ar(freq, 0,width, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;

SynthDef(\dxkVarSawTriangle, {|t_trig = 1, out = 0, freq = 440, amp = 1, pan = 0, width = 0.5, len = 1|
	var sig,env;
	env = EnvGen.ar(Env.triangle(len), t_trig, doneAction: 2);
	sig = VarSaw.ar(freq, 0,width, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;

SynthDef(\dxkVarSawSine, {|t_trig = 1, out = 0, freq = 440, amp = 1, pan = 0, width = 0.5, len = 1|
	var sig,env;
	env = EnvGen.ar(Env.sine(len), t_trig, doneAction: 2);
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

SynthDef(\dxkSawLinen, {|out = 0, freq = 440, amp = 1, pan = 0, att = 0.01, sus = 1, rel = 1, curve = \lin, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.asr(att,sus,rel,1, curve),gate, doneAction: 2);
	sig = Saw.ar(freq, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;


SynthDef(\dxkSawADSR, {|out = 0, freq = 440, amp = 1, pan = 0, att = 0.01, decay = 0.3, sus = 0.5, rel = 1, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.adsr(att,decay,sus,rel),gate, doneAction: 2);
	sig = Saw.ar(freq, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;



SynthDef(\dxkSawPerc, {|t_trig = 1, out = 0, freq = 440, amp = 1, pan = 0, att = 0.01,rel = 1, curve = -4|
	var sig,env;
	env = EnvGen.ar(Env.perc(att,rel, 1, curve), t_trig, doneAction: 2);
	sig = Saw.ar(freq, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;

SynthDef(\dxkSawTriangle, {|t_trig = 1, out = 0, freq = 440, amp = 1, pan = 0, len = 1|
	var sig,env;
	env = EnvGen.ar(Env.triangle(len), t_trig, doneAction: 2);
	sig = Saw.ar(freq, amp);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;

SynthDef(\dxkSawSine, {|t_trig = 1, out = 0, freq = 440, amp = 1, pan = 0, len = 1|
	var sig,env;
	env = EnvGen.ar(Env.sine(len), t_trig, doneAction: 2);
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

SynthDef(\dxkSin2Linen, {|out = 0, freq = 440, detune = 0.01, amp = 1, pan = 0, att = 0.01, rel = 1, sus = 1, curve = \lin, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.linen(att,sus,rel,1,curve),gate, doneAction: 2);
	sig = SinOsc.ar([freq,freq*(1+detune)], 0, amp);
	sig = Mix.new(sig);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;



SynthDef(\dxkSin2ADSR, {|out = 0, freq = 440, detune = 0.01, amp = 1, pan = 0, att = 0.01, decay = 0.3, sus = 0.5, rel = 1, gate = 1|
	var sig,env;
	env = EnvGen.ar(Env.adsr(att,decay,sus,rel),gate, doneAction: 2);
	sig = SinOsc.ar([freq,freq*(1+detune)], 0, amp);
	sig = Mix.new(sig);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;



SynthDef(\dxkSin2Perc, {|t_trig = 1, out = 0, freq = 440, detune = 0.01, amp = 1, pan = 0, att = 0.01,rel = 1, curve = -4|
	var sig,env;
	env = EnvGen.ar(Env.perc(att,rel, 1, curve), t_trig, doneAction: 2);
	sig = SinOsc.ar([freq,freq*(1+detune)], 0, amp);
	sig = Mix.new(sig);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;

SynthDef(\dxkSin2Triangle, {|t_trig = 1, out = 0, freq = 440, detune = 0.01, amp = 1, pan = 0, len = 1|
	var sig,env;
	env = EnvGen.ar(Env.triangle(len), t_trig, doneAction: 2);
	sig = SinOsc.ar([freq,freq*(1+detune)], 0, amp);
	sig = Mix.new(sig);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;

SynthDef(\dxkSin2Sine, {|t_trig = 1, out = 0, freq = 440, detune = 0.01, amp = 1, pan = 0, len = 1|
	var sig,env;
	env = EnvGen.ar(Env.sine(len), t_trig, doneAction: 2);
	sig = SinOsc.ar([freq,freq*(1+detune)], 0, amp);
	sig = Mix.new(sig);
	sig = Pan2.ar(sig, pan);
	Out.ar(out,sig*env);
	}).add;



// noise

SynthDef(\dxkWhiteNoiseBP, {
	arg out = 0, amp = 1, rq = 1, freq = 440, pan = 0, gate = 1, att = 0.01, rel = 0.01, curve = -4;
	var env = EnvGen.ar(Env.asr(att, 1, rel, curve), gate, doneAction: 2);
	var noise = WhiteNoise.ar();
	noise = BPF.ar(noise, freq, rq);
	noise = Pan2.ar(noise, pan, amp);
	Out.ar(out, noise*env);
}).add;

SynthDef(\dxkPinkNoiseBP, {
	arg out = 0, amp = 1, rq = 1, freq = 440, pan = 0, gate = 1, att = 0.01, rel = 0.01, curve = -4;
	var env = EnvGen.ar(Env.asr(att, 1, rel, curve), gate, doneAction: 2);
	var noise = PinkNoise.ar();
	noise = BPF.ar(noise, freq, rq);
	noise = Pan2.ar(noise, pan, amp);
	Out.ar(out, noise*env);
}).add;

SynthDef(\dxkBrownNoiseBP, {
	arg out = 0, amp = 1, rq = 1, freq = 440, pan = 0, gate = 1, att = 0.01, rel = 0.01, curve = -4;
	var env = EnvGen.ar(Env.asr(att, 1, rel, curve), gate, doneAction: 2);
	var noise = BrownNoise.ar();
	noise = BPF.ar(noise, freq, rq);
	noise = Pan2.ar(noise, pan, amp);
	Out.ar(out, noise*env);
}).add;

SynthDef(\dxkWhiteNoiseHL, {
	arg out = 0, amp = 1, lop = 20000, hip = 0, pan = 0, att = 0.01, rel = 0.01, curve = -4, gate = 1;
	var env = EnvGen.ar(Env.asr(att, 1, rel, curve), gate, doneAction: 2);
	var noise = WhiteNoise.ar();
	noise = LPF.ar(noise, lop);
	noise = HPF.ar(noise, hip);
	noise = Pan2.ar(noise, pan, amp);
	Out.ar(out, noise*env);
}).add;

SynthDef(\dxkBrownNoiseHL, {
	arg out = 0, amp = 1, lop = 20000, hip = 0, pan = 0, att = 0.01, rel = 0.01, curve = -4, gate = 1;
	var env = EnvGen.ar(Env.asr(att, 1, rel, curve), gate, doneAction: 2);
	var noise = BrownNoise.ar();
	noise = LPF.ar(noise, lop);
	noise = HPF.ar(noise, hip);
	noise = Pan2.ar(noise, pan, amp);
	Out.ar(out, noise*env);
}).add;

SynthDef(\dxkPinkNoiseHL, {
	arg out = 0, amp = 1, lop = 20000, hip = 0, pan = 0, att = 0.01, rel = 0.01, curve = -4, gate = 1;
	var env = EnvGen.ar(Env.asr(att, 1, rel, curve), gate, doneAction: 2);
	var noise = PinkNoise.ar();
	noise = LPF.ar(noise, lop);
	noise = HPF.ar(noise, hip);
	noise = Pan2.ar(noise, pan, amp);
	Out.ar(out, noise*env);
}).add;