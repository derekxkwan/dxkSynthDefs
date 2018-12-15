
SynthDef(\dxkBd1, {|t_trig = 1, basefreq = 45, overdrive = 2, len=0.5, att = 0.002, fgprop =0.3, fgdprop = 0.9, noisiness=0.2, lop = 1250, amp = 1, pan = 0, out = 0|

	//fgprop = frequency glide in proportion to freq
	//fgdprop = freq glide duration in proportion to dur
	//freq = fundamental
	var freqenv, noise, main, fgdur, fgact, env;
	fgdur = Clip.ir(len * fgdprop, 0, len); //real value of fgdprop
	fgact = fgprop*basefreq; //actual hz to glide over
	freqenv = EnvGen.ar(Env.perc(att, fgdur, fgact, -4),t_trig);
	freqenv = (freqenv + basefreq) + PinkNoise.ar(noisiness);
	main = SinOsc.ar(freqenv);
	main = LPF.ar(main, lop);
	env = EnvGen.ar(Env.perc(att, len, amp, -4), t_trig, doneAction: 2);
	main = main * env;
	main = (main * overdrive).tanh;
	main = Pan2.ar(main, pan);
	Out.ar(out, main);
}).add;

SynthDef(\dxkBd2, {|t_trig = 1, basefreq = 55, rq = 0.1, overdrive = 2, samplen = 100, amp = 1, pan = 0, out = 0|
	var output, failsafe, makeupgain = 3.5;
	output = Trig.ar(t_trig,samplen/SampleRate.ir);
	output = BPF.ar(output,basefreq,rq,amp*makeupgain);
	output = (output * overdrive).tanh;
	failsafe = FreeSelf.kr(Trig.kr(t_trig) * (amp <= 0));
	DetectSilence.ar(output, time: 0.1, doneAction:2);
	output = Pan2.ar(output*amp, pan);
	Out.ar(out, output);
}).add;

// abstracted out from 08091500Acid309 by_otophilia

SynthDef(\dxkBd3, {	|freq = 43, att = 0.005, ampnoise = 1, rel = 0.32, out = 0, pan = 0, amp = 1|
		var env0, env1, env1m, output;

		env0 =  EnvGen.ar(Env.new([0.5, 1, 0.5, 0], [att, 0.1875*rel, 0.8125*rel], [-4, -2, -4]), doneAction:2);
		env1 = EnvGen.ar(Env.new([2.52*freq, 1.35155167*freq, freq], [att, 0.90625*rel], [-4, -5]));


		output = LFPulse.ar(env1, 0, 0.5, 1, -0.5);
		output = output + WhiteNoise.ar(ampnoise);
		output = LPF.ar(output, env1*1.5, env0);
		output = output + SinOsc.ar(env1, 0.5, env0);

		output = output * 1.2;
		output = output.clip2(1)*amp;
	    output = Pan2.ar(output, pan);
		Out.ar(out, output);
}).add;

//adapted from joe sullivan's synthesizing hihats http://joesul.li/van/synthesizing-hi-hats/
SynthDef(\dxkHh1, {|t_trig = 1, basefreq = 40,  att = 0.001, len = 0.1, rq = 0.1, hpfreq = 7000, lopfreq = 10000, out = 0, pan = 0, amp = 1|
	var freqarr, output, env;
	freqarr = basefreq * [2,3,4.16, 5.43, 6.79,8.21];
	output = Mix.ar(Pulse.ar(freqarr, mul:1/freqarr.size));
	output = BPF.ar(output, 10000, rq);
	output = RHPF.ar(output, 7000, rq);
	env = EnvGen.ar(Env.perc(att, len, amp), t_trig, doneAction: 2);
	output = output *env;
	output = Pan2.ar(output, pan);
	Out.ar(out, output);
}).add;


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

// abstracted out from 08091500Acid309 by_otophilia
SynthDef(\dxkHh3, {|t_trig =1, rel = 0.2, hip1 = 1000, bp2 = 6000, brq1 = 2, brq2 = 0.9, bls2 = 3000, brs2 = 0.5, hip2 = 1000, hrq2 = 1.5, out = 0, amp = 1, pan = 0|
		var env1, env2, output, oscs1, noise, n = 5, n2 = 8;

		thisThread.randSeed = 4;

		env1 = EnvGen.ar(Env.new([0, 1.0, 0], [0.001, rel], [0, -12]), t_trig, doneAction: 2);
		env2 = EnvGen.ar(Env.new([0, 1.0, 0.05, 0], [0.002, 0.25*rel, 0.15*rel], [0, -4, -4]), t_trig, doneAction:0);

	    //tone
		oscs1 = Mix.fill(n, {|i|
			SinOsc.ar(
				( i.linlin(0, n-1, 42, 74) + rand2(4.0) ).midicps,
				SinOsc.ar( (i.linlin(0, n-1, 78, 80) + rand2(4.0) ).midicps, 0.0, 12),
				1/n
			)
		});

	    oscs1 = BHiPass.ar(oscs1, hip1, brq1, env1);

	    //noise
		noise = WhiteNoise.ar;
		noise = Mix.fill(n2, {|i|
			var freq;
			freq = (i.linlin(0, n-1, 40, 50) + rand2(4.0) ).midicps.reciprocal;
			CombN.ar(noise, 0.04, freq, 0.1)
		}) * (1/n) + noise;
		noise = BPF.ar(noise, bp2, brq2, 0.5, noise);
		noise = BLowShelf.ar(noise, bls2, brs2, -6);
		noise = BHiPass.ar(noise, hip2, hrq2, env2);

		output = noise + oscs1;
		output = output.softclip;
		output = output * amp;
		output = Pan2.ar(output, pan);
		Out.ar(out, output);
	}).add;



SynthDef(\dxkSd1, {|t_trig = 1, basefreq = 300, len = 0.125, fgprop = 0.5, fgdprop = 0.75, rq = 0.1, lop = 5000, att = 0.002, amp = 1, pan = 0, out = 0|
	//penv = pitch envelope
	//fgprop = frequency glide in proportion to freq
	//fgdprop = freq glide duration in proportion to dur
	//freqbase = fundamental
	var output, ampenv, penv, gaincomp = 9;
	output = WhiteNoise.ar()*gaincomp;
	penv = EnvGen.ar(Env.perc(att, len*fgdprop, basefreq*fgprop), t_trig);
	penv = penv + basefreq;
	output = BPF.ar(output,penv, rq);
	output = LPF.ar(output, lop, amp);
	ampenv = EnvGen.ar(Env.perc(att, len), t_trig, doneAction: 2);
	output = output * ampenv;
	output = Pan2.ar(output, pan);
	Out.ar(out, output);
}).add;

//adapted+modified from snare1.pd pure data patch by user ichabod of pdpatchrepo
SynthDef(\dxkSd2, {|t_trig = 1, basefreq = 180, freq1amp = 0.75, freq2amp = 1, lopfreq = 1000, hipfreq = 950, lopamp = 0.5, hipamp = 1, att = 0.001, len = 0.1, amp = 1, pan = 0, out = 0|
	var oscs, oenv1, oenv2, noise, lonoise, loenv, hinoise, hienv, output;
	oscs = SinOsc.ar([basefreq, basefreq*1.83], 0, [0.75, 1]);
	oenv1 = EnvGen.ar(Env.perc(att, len*0.53), t_trig);
	oenv2 = EnvGen.ar(Env.perc(att, len), t_trig, doneAction: 2);
	oscs = Mix.new(oscs * [oenv1, oenv2]);
	noise = WhiteNoise.ar();
	lonoise = LPF.ar(noise, lopfreq);
	loenv = EnvGen.ar(Env.perc(att, len*0.6, lopamp), t_trig);
	lonoise = lonoise * loenv;
	hinoise = HPF.ar(noise, hipfreq);
	hienv = EnvGen.ar(Env.perc(att, len*0.46,hipamp), t_trig);
	hinoise = hinoise*hienv;
	output = oscs + lonoise + hinoise;
	output = Pan2.ar(output, pan)*amp;
	Out.ar(out, output);
}).add;
	
//adapted+modified from snare2.pd pure data patch by user ichabod of pdpatchrepo
SynthDef(\dxkSd3, {|t_trig = 1, basefreq = 150, att = 0.001, len = 0.3, lopfreq = 1200, rq = 0.3, tone = 0.7, snare = 0.5, amp = 1, pan = 0, out = 0|
	var freqs, rqs, bpmuls, fenv, drumhead, snares, noise, nmul, lonoise, hinoise, output, nenv, rand,  lofreq, hifreq, loenv, hienv, lomul;

	//random number
	rand = TIRand.kr(0,101, t_trig);
	
	freqs = basefreq * [1, 2.03, 3.26, 4.6];
	rqs = rq * [1/2, 1, 1/2, 1/2];
	bpmuls = 3 * [8.333, 10, 5, 1];
	fenv = EnvGen.ar(Env.perc(att, len), t_trig, doneAction: 2);
	noise = WhiteNoise.ar(1.4)+1.4;
	noise = Select.ar(noise, [DC.ar(-1), DC.ar(0), DC.ar(1)]);
	nmul = rand/800.0 + 0.875;
	nenv = EnvGen.ar(Env.perc(att, len*0.46, nmul), t_trig);
	noise = noise * nenv;
	
	//drum head formants
	drumhead = Resonz.ar(LPF.ar(noise, lopfreq), freqs, rqs, bpmuls);
	drumhead = drumhead * tone;

	//snares
	lofreq = rand + 900;
	hifreq = lofreq* 0.95;
	lonoise = LPF.ar(noise, lofreq);
	lomul = (rand/500.0) + 0.4;
	loenv = EnvGen.ar(Env.perc(att, len*0.66,lomul), t_trig);
	lonoise = lonoise * loenv;
	hinoise = HPF.ar(noise, hifreq);
	hienv = EnvGen.ar(Env.perc(att, len*0.466), t_trig);
	hinoise = hinoise * hienv;
	snares = lonoise + hinoise;
	snares = snares * snare;
	output = drumhead + snares;
	output = Pan2.ar(output, pan);
	Out.ar(out, output);
}).add;

// abstracted out from 08091500Acid309 by_otophilia
SynthDef(\dxkSd4, {	|t_trig = 1, freq = 60, fglide = 1.83, fdip - 0.82, rel = 0.13, hipsn = 200, snrq1 = 2, bpsn = 6900, snrq2 = 0.6, amptone = 1, ampsnares = 0.2, out = 0, amp = 1, pan = 0|
		var env0, env1, env2, env1m, oscs, noise, output;

		env0 = EnvGen.ar(Env.new([0.5, 1, 0.5, 0], [0.005, rel*0.23, rel*0.77], [-4, -2, -4]), t_trig, amptone);
		env1 = EnvGen.ar(Env.new([freq*fglide, freq, freq*fdip], [0.005, rel*0.77], [-4, -5]), t_trig);
		env1m = env1.midicps;
		env2 = EnvGen.ar(Env.new([1, 0.4, 0], [0.05, rel], [-2, -2]), t_trig, doneAction:2);

		oscs = LFPulse.ar(env1m, 0, 0.5, 1, -0.5) + LFPulse.ar(env1m * 1.6, 0, 0.5, 0.5, -0.25);
		oscs = LPF.ar(oscs, env1m*1.2, env0);
		oscs = oscs + SinOsc.ar(env1m, 0.8, env0);

		noise = WhiteNoise.ar(0.2);
		noise = HPF.ar(noise, hipsn, snrq1);
		noise = BPF.ar(noise, bpsn, snrq2, 3) + noise;
		noise = noise * env2;

		output = oscs + noise;
	    output = output.clip2(1) * amp;
	    output = Pan2.ar(output, pan);

		Out.ar(out, output);
}).add;


//adapted from the ryan brown synthdef \cymbal808_ryan from the supercollider-quarks
//synthdefpool
SynthDef(\dxkCymb808, {|t_trig = 1, basefreq = 205.35, len = 0.25, sustain = 0.5, att = 0.001, out = 0, pan = 0, amp = 1|
	var freqArray, sig1, sig2,env, sig1env, output, failsafe;
	freqArray = basefreq * [ 1, 1.4823959094229, 1.800048697346, 2.545458972486, 2.6322863403944, 3.9552471390309 ];
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
	output = FreeVerb.ar(output, sustain);
	failsafe = FreeSelf.kr(Trig.kr(t_trig) * (amp <= 0));
	DetectSilence.ar(output, time: 0.01, doneAction:2);
	output = Pan2.ar(output*amp, pan);
	Out.ar(out, output);
}).add;


//adapted from ryan brown's sc-users 2007-08-25, retrieved from the synthdefpool repo
//reintroduced use of baseFreq and redefined time to remove time scaling

SynthDef(\dxkCymb808_2, {|out=0, freq = 300, time = 0.25, amp=0.1|


	var freqs = freq * [ 1, 1.4823959094229, 1.800048697346, 2.545458972486, 2.6322863403944, 3.9552471390309 ];
	var signal, pulseEnv;

	pulseEnv = EnvGen.ar(Env.new([1.0, 0.6], [time], [-0.5]));
	signal = Mix.new(LFPulse.ar(freqs * 4.09));
	signal = (BinaryOpUGen('==', signal, 6.0) * 0.6) + (BinaryOpUGen('==', signal, 2.0) * 0.2) + (BinaryOpUGen('==', signal, 1.0) * 0.9); // XOR
 	signal = (signal * pulseEnv) + (Mix.new(LFPulse.ar(freqs, width:0.55)) * 0.9);
	signal = RLPF.ar(signal, 7000, 0.6);
 	signal = RHPF.ar(signal, 6800, 1.5);
	signal = RHPF.ar(signal, 6800, 1.5);
	signal = RHPF.ar(signal, 1200, 1.5);
	signal = signal + FreeVerb.ar(signal);
	signal = signal * EnvGen.ar(Env.new([0, 1, 0.4, 0, 0], [0.002, time, 0.05, 0.5], [0, -0.5, 0, -50]), doneAction:2);
	signal = [signal, DelayN.ar(signal, 0.005, 0.005)];
	OffsetOut.ar(out, signal*4*amp);
}).add;


//fm-gong from http://varioussmallfires.blogspot.ca/2012/01/supercollider-gong.html
//but with some tweaks for panning, etc and matrixing variables
SynthDef(\dxkGong1, {|freq = 100, amp = 1, dr = 1, out = 0, pan = 0|

	var modsig, modf = freq * [1.16, 3.14, 1.005];
	var idx = [[0.01, 0.3],[0.01,0.38], [0.01, 0.5]] * modf;
	var idxscaler = Array.fill(idx.size, {|i| idx[i][1] - idx[i][0]});
	var modenv = Array.newClear(modf.size);
	var ampenv, carsig, lfo, output;

	lfo = SinOsc.ar(3, 0, XLine.kr(freq*0.005, freq*0.05, dr));

	modenv[0] = EnvGen.kr(
		Env(levels: [0,1,1,0], times: [0.75*dr, 0.24*dr, 0.01*dr]),
		doneAction: 2);

	modenv[1] = EnvGen.kr(
		Env(levels: [0,1,0], times: [0.02*dr, 0.98*dr]),
		doneAction: 2);

	modenv[2] = EnvGen.kr(
		Env(levels: [ 0, 0.3, 1, 0.5, 0], times: [0.15 * dr, 0.15 *dr, 0.45*dr, 0.25*dr]),
		doneAction: 2);

	// Exp curve...
	ampenv = EnvGen.kr(
		Env(levels: [ 0, 1, 0.001], times: [0.002, dr - 0.002], curve: \exp),
		doneAction: 2);

	modsig = Mix.new(SinOsc.ar(modf) * ((idx + idxscaler)*modenv));
	carsig = SinOsc.ar(freq + lfo + modsig)*modf.size.reciprocal;
	output = carsig * ampenv * amp;
	output = Pan2.ar(output, pan);
	Out.ar(out, output);

}).add;


// abstracted out from 08091500Acid309 by_otophilia
SynthDef(\dxkClap1, {	|t_trig = 1, rel = 0.3, hip1 = 600, bp1 = 2000, brq1 = 3, hip2 = 1000, bp2 = 1200, brq2 = 0.7, ampn2 = 0.7, out = 0, pan = 0, amp = 1|
		var env1, env2, output, noise1, noise2;
		var env1lvl, env1time, env1curve;
		var env2lvl, env2time, env2curve;

		env1lvl = [0, 1, 0, 1, 0, 1, 0, 1, 0];
		env1time = [0.001, 0.013, 0, 0.01, 0, 0.01, 0, 0.03];
		env1curve = [0, -3, 0, -3, 0, -3, 0, -4];
		env2lvl = [0,1,0];
		env2time = [0.02, rel];
		env2curve = [0, -4];

	    env1 = EnvGen.ar(Env.new(env1lvl, env1time, env1curve), t_trig); //attack
     	env2 = EnvGen.ar(Env.new(env2lvl, env2time, env2curve), doneAction:2); //release

		noise1 = WhiteNoise.ar(env1);
		noise1 = HPF.ar(noise1, hip1);
		noise1 = BPF.ar(noise1, bp1, brq1);

		noise2 = WhiteNoise.ar(env2);
		noise2 = HPF.ar(noise2, hip2);
		noise2 = BPF.ar(noise2, bp2, brq2, ampn2);

		output = noise1 + noise2;
		output = output.softclip * amp;
		output = Pan2.ar(output, pan);

		Out.ar(out, output);
}).add;


