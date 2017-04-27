
SynthDef(\dxkBd1, {|t_trig = 1, freq = 45, len=0.3, att = 0.002, fgprop =0.3, fgdprop = 0.9, noisiness=0.0002, lop = 1250, amp = 1, pan = 0, out = 0|

	//fgprop = frequency glide in proportion to freq
	//fgdprop = freq glide duration in proportion to dur
	//freq = fundamental
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

SynthDef(\dxkBd2, {|t_trig = 1, freq = 70, rq = 0.1, samplen = 64, amp = 1, pan = 0, out = 0|
	var output,makeupgain = 3.5;
	output = Trig.ar(t_trig,samplen/SampleRate.ir);
	output = BPF.ar(output,freq,rq,amp*makeupgain);
	DetectSilence.ar(output, doneAction:2);
	output = Pan2.ar(output, pan);
	Out.ar(out, output);
}).add;

//adapted from joe sullivan's synthesizing hihats http://joesul.li/van/synthesizing-hi-hats/
SynthDef(\dxkHh1, {|t_trig = 1, freq = 40,  att = 0.001, len = 0.1, rq = 0.1, hpfreq = 7000, lopfreq = 10000, out = 0, pan = 0, amp = 1|
	var freqarr, output, env;
	freqarr = freq * [2,3,4.16, 5.43, 6.79,8.21];
	output = Mix.ar(Pulse.ar(freqarr, mul:1/freqarr.size));
	output = BPF.ar(output, 10000, rq);
	output = RHPF.ar(output, 7000, rq);
	env = EnvGen.ar(Env.perc(att, len, amp), t_trig, doneAction: 2);
	output = output *env;
	output = Pan2.ar(output, pan);
	Out.ar(out, output);
}).add;
)

SynthDef(\dxkHh2, {|t_trig = 1, len = 0.125, att = 0.001, rq = 0.35, lp = 10000, bplow = 5000, bphigh = 8000, amp = 1, pan = 0, out = 0|
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


SynthDef(\dxkSd1, {|t_trig = 1, freq = 300, len = 0.125, fgprop = 0.5, fgdprop = 0.75, rq = 0.1, lop = 5000, att = 0.002, amp = 1, pan = 0, out = 0|
	//penv = pitch envelope
	//fgprop = frequency glide in proportion to freq
	//fgdprop = freq glide duration in proportion to dur
	//freqbase = fundamental
	var output, ampenv, penv, gaincomp = 9;
	output = WhiteNoise.ar()*gaincomp;
	penv = EnvGen.ar(Env.perc(att, len*fgdprop, freq*fgprop), t_trig);
	penv = penv + freq;
	output = BPF.ar(output,penv, rq);
	output = LPF.ar(output, lop, amp);
	ampenv = EnvGen.ar(Env.perc(att, len), t_trig, doneAction: 2);
	output = output * ampenv;
	output = Pan2.ar(output, pan);
	Out.ar(out, output);
}).add;
	
	
	
	

	
//adapted from the ryan brown synthdef \cymbal808_ryan from the supercollider-quarks
//synthdefpool
SynthDef(\dxkCymb808_1, {|t_trig = 1, freq = 205.35, len = 0.25, sustain = 0.5, att = 0.001, out = 0, pan = 0, amp = 1|
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