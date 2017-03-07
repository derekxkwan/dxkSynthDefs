
SynthDef(\dxkBd1, {|freq = 45, dur=0.3, att = 0.002, fgprop =0.3, fgdprop = 0.9, noisiness=0.0002, lop = 1250, mul = 1, outBus = 0|

	//fgprop = frequency glide in proportion to freq
	//fgdprop = freq glide duration in proportion to dur
	//freqbase = fundamental
	var freqenv, noise, main, fgdur, fgact, env;
	fgdur = Clip.ir(dur * fgdprop, 0, dur); //real value of fgdprop
	fgact = fgprop*freq; //actual hz to glide over
	freqenv = EnvGen.ar(Env.perc(att, fgdur, fgact, -4));
	freqenv = (freqenv + freq) + PinkNoise.ar(noisiness);
	main = SinOsc.ar(freqenv);
	main = LPF.ar(main, lop);
	env = EnvGen.ar(Env.perc(att, dur, mul, -4), doneAction: 2);
	main = main * env;
	Out.ar(outBus, main);
}).add;

SynthDef(\dxkHh1, {|dur = 0.125, att = 0.001, rq = 0.35, lp = 10000, bplow = 5000, bphigh = 8000, mul =1,outBus = 0|
	var bpenv, main, env,glide;
	env = EnvGen.ar(Env.perc(att, dur, 1 -8), doneAction:2);
	glide = (bphigh-bplow).abs;
	main = WhiteNoise.ar(mul) *env;
	bpenv = EnvGen.ar(Env.perc(att, dur, glide, -8));
	bpenv = (glide-bpenv)+bplow.min(bphigh);
	main = BPF.ar(main, bpenv, rq);
	main = LPF.ar(main, lp);
	Out.ar(outBus, main);
}).add;

SynthDef(\dxkBd2, {|freq=60, dur = 0.0015, rq = 0.1,t_trig = 1, mul = 1, outBus = 0|
	var main, makeupgain = 3.5;
	main = Trig.ar(t_trig, dur);
	main = BPF.ar(main, freq, rq, mul*makeupgain);
	DetectSilence.ar(main, doneAction:2);
	Out.ar(outBus, main);
}).add;

//adapted from the ryan brown synthdef \cymbal808_ryan from the supercollider-quarks
//synthdefpool
SynthDef(\dxkCymb808_1, {|dur = 0.25, sustain = 0.5, att = 0.001, outBus = 0, mul = 1|
	var freqArray, sig1, sig2,env, sig1env, out;
	freqArray = [205.35, 304.41, 369.84, 522.71, 540.54, 812.21];
	sig2 = Pulse.ar(freqArray, 0.55, 0.9);
	sig2 = Mix.ar(sig2);
	sig1 = Pulse.ar(freqArray, 0.5);
	sig1 = Mix.ar(sig1);
	sig1 = ( BinaryOpUGen('==', sig1, 6) * 0.6) + ( BinaryOpUGen('==', sig1, 2)*0.2)+( BinaryOpUGen('==', sig1, 1)*0.9);
	sig1env = EnvGen.ar(Env([1.0, 1.0, 0.6], [att, dur], -4));
	env = EnvGen.ar(Env([1.0, 0.4, 0], [att, dur, 0.05], -4));
	out = sig1 + sig2;
	out = SOS.ar(out, 0.175812, 0.351623, 0.175812, 0.834059, -0.537305);
	out = SOS.ar(out, 0.669886, -1.33977, 0.669886, 0.968752, -0.710791);
	out = SOS.ar(out, 0.669886, -1.33977, 0.669886, 0.968752, -0.710791 );
	out = out * env;
	out = DelayN.ar(out, 0.005, 0.005);
	out = FreeVerb.ar(out, sustain, mul:mul);
	DetectSilence.ar(out, doneAction:2);
	Out.ar(outBus, out);
}).add;