
SynthDef(\dxkBd1, {|t_trig, freq = 45, len=0.3, att = 0.002, fgprop =0.3, fgdprop = 0.9, noisiness=0.0002, lop = 1250, amp = 1, pan = 0, out = 0|

	//fgprop = frequency glide in proportion to freq
	//fgdprop = freq glide duration in proportion to dur
	//freqbase = fundamental
	var freqenv, noise, main, fgdur, fgact, env;
	fgdur = Clip.ir(len * fgdprop, 0, len); //real value of fgdprop
	fgact = fgprop*freq; //actual hz to glide over
	freqenv = EnvGen.ar(Env.perc(att, fgdur, fgact, -4));
	freqenv = (freqenv + freq) + PinkNoise.ar(noisiness);
	main = SinOsc.ar(freqenv);
	main = LPF.ar(main, lop);
	env = EnvGen.ar(Env.perc(att, len, amp, -4), doneAction: 2);
	main = main * env;
	main = Pan2.ar(main, pan);
	Out.ar(out, main);
}).add;

SynthDef(\dxkHh1, {|t_trig, len = 0.125, att = 0.001, rq = 0.35, lp = 10000, bplow = 5000, bphigh = 8000, amp = 1, pan = 0, out = 0|
	var bpenv, main, env,glide;
	env = EnvGen.ar(Env.perc(att, len, 1 -8), doneAction:2);
	glide = (bphigh-bplow).abs;
	main = WhiteNoise.ar() *env;
	bpenv = EnvGen.ar(Env.perc(att, len, glide, -8));
	bpenv = (glide-bpenv)+bplow.min(bphigh);
	main = BPF.ar(main, bpenv, rq);
	main = LPF.ar(main, lp);
	main = main * amp;
	main = Pan2.ar(main, pan);
	Out.ar(out, main);
}).add;

SynthDef(\dxkBd2, {|freq=60, len = 0.0015, rq = 0.1,t_trig = 1, amp = 1, out = 0, pan = 0|
	var main, makeupgain = 3.5;
	main = Trig.ar(t_trig, len);
	main = BPF.ar(main, freq, rq, amp*makeupgain);
	DetectSilence.ar(main, doneAction:2);
	main = Pan2.ar(main, pan);
	Out.ar(out, main);
}).add;

//adapted from the ryan brown synthdef \cymbal808_ryan from the supercollider-quarks
//synthdefpool
SynthDef(\dxkCymb808_1, {|t_trig, freq = 205.35, len = 0.25, sustain = 0.5, att = 0.001, out = 0, pan = 0, amp = 1|
	var freqArray, sig1, sig2,env, sig1env, output;
	freqArray = freq * [ 1, 1.4823959094229, 1.800048697346, 2.545458972486, 2.6322863403944, 3.9552471390309 ];
	sig2 = Pulse.ar(freqArray, 0.55, 0.9);
	sig2 = Mix.ar(sig2);
	sig1 = Pulse.ar(freqArray, 0.5);
	sig1 = Mix.ar(sig1);
	sig1 = ( BinaryOpUGen('==', sig1, 6) * 0.6) + ( BinaryOpUGen('==', sig1, 2)*0.2)+( BinaryOpUGen('==', sig1, 1)*0.9);
	sig1env = EnvGen.ar(Env([1.0, 1.0, 0.6], [att, len], -4));
	env = EnvGen.ar(Env([1.0, 0.4, 0], [att, len, 0.05], -4));
	output = sig1 + sig2;
	output = SOS.ar(output, 0.175812, 0.351623, 0.175812, 0.834059, -0.537305);
	output = SOS.ar(output, 0.669886, -1.33977, 0.669886, 0.968752, -0.710791);
	output = SOS.ar(output, 0.669886, -1.33977, 0.669886, 0.968752, -0.710791 );
	output = output * env;
	output = DelayN.ar(output, 0.005, 0.005);
	output = FreeVerb.ar(output, sustain, mul:amp);
	DetectSilence.ar(output, doneAction:2);
	output = Pan2.ar(output, pan);
	Out.ar(out, output);
}).add;